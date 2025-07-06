import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/vision_model.dart';
import '../services/vision_services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VisionProvider with ChangeNotifier {
  final TeacherVisionAPIService _apiService = TeacherVisionAPIService();

  final List<TeacherVisionVideo> _allVideos = [];
  final List<TeacherVisionVideo> _assignedVideos = [];
  List<TeacherVisionVideo> filteredNonAssignedVideos = [];
  List<TeacherVisionVideo> filteredAssignedVideos = [];
  List<Map<String, dynamic>> _subjects = [];

  String _subjectFilter = '';
  String _levelFilter = '';
  String _searchQuery = '';
  String? _selectedSubjectId;
  bool _isLoading = false;
  String? _errorMessage;
  // Pagination controls
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMoreAllVideos = true;
  bool _hasMoreAssignedVideos = true;
  bool _isLoadingMore = false;

  // Getters
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get subjects => _subjects;
  bool _hasLoadedFromCache = false;
  bool get hasMoreAllVideos => _hasMoreAllVideos;
  bool get hasMoreAssignedVideos => _hasMoreAssignedVideos;

  VisionProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchSubjects();

    if (!_hasLoadedFromCache) {
      final hasCache = await _loadCachedVideos();
      _hasLoadedFromCache = true;
      if (!hasCache) {
        await _fetchVideos(); // no cache — fetch now
      }
    } else {
      await _fetchVideos(); // already loaded once — fetch fresh
    }
  }

  Future<bool> _loadCachedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_vision_videos');

    if (cachedData != null) {
      final List<dynamic> jsonData = jsonDecode(cachedData);
      _allVideos.clear();
      _allVideos.addAll(jsonData.map((e) => TeacherVisionVideo.fromJson(e)));
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> _fetchSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      _subjects = await _apiService.getSubjects();
      debugPrint('🎉 Fetched ${_subjects.length} subjects');

      if (_subjects.isEmpty) {
        _subjects = [
          {'id': '1', 'title': 'Science', 'name': 'Science'},
          {'id': '2', 'title': 'Maths', 'name': 'Maths'},
        ];
      }

      // Cache the subjects
      prefs.setString('cached_subjects', jsonEncode(_subjects));
    } catch (e) {
      debugPrint('❌ Error fetching subjects: $e');

      // Try to load from cache
      final cached = prefs.getString('cached_subjects');
      if (cached != null) {
        _subjects = List<Map<String, dynamic>>.from(jsonDecode(cached));
        debugPrint('📦 Loaded subjects from cache');
      } else {
        // Provide fallback
        _subjects = [
          {'id': '1', 'title': 'Science', 'name': 'Science'},
          {'id': '2', 'title': 'Maths', 'name': 'Maths'},
        ];
      }
    }
  }

  Future<void> _fetchVideos({bool loadMore = false}) async {
    if (_isLoading && !loadMore) return;
    if (loadMore && (_isLoadingMore || (!_hasMoreAllVideos && !_hasMoreAssignedVideos))) return;

    // Set loading states
    if (!loadMore) {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreAllVideos = true;
      _hasMoreAssignedVideos = true;
      _allVideos.clear();
      _assignedVideos.clear();
    } else {
      _isLoadingMore = true;
      _currentPage++;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    try {
      // Fetch both types of videos in parallel
      final results = await Future.wait([
        _fetchAllVideosPage(),
        _fetchAssignedVideosPage(),
      ]);

      final newAllVideos = results[0] as List<TeacherVisionVideo>;
      final newAssignedVideos = results[1] as List<TeacherVisionVideo>;

      // Update video lists
      _allVideos.addAll(newAllVideos);
      _assignedVideos.addAll(newAssignedVideos);

      // Update pagination states
      _hasMoreAllVideos = newAllVideos.length >= _perPage;
      _hasMoreAssignedVideos = newAssignedVideos.length >= _perPage;

      // Cache only first page
      if (!loadMore) {
        await prefs.setString('cached_all_videos', jsonEncode(_allVideos.map((e) => e.toJson()).toList()));
        await prefs.setString('cached_assigned_videos', jsonEncode(_assignedVideos.map((e) => e.toJson()).toList()));
      }

      _applyFilters();
    } catch (e) {
      debugPrint('❌ Error fetching videos: $e');
      _errorMessage = 'Failed to load videos. ${e.toString()}';

      if (!loadMore) {
        await _loadCachedVideos();
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<List<TeacherVisionVideo>> _fetchAllVideosPage() async {
    if (!_hasMoreAllVideos && _currentPage > 1) return [];

    if (_selectedSubjectId != null) {
      return await _apiService.getVisionVideosBySubject(
        _selectedSubjectId!,
        page: _currentPage,
        perPage: _perPage,
      );
    }
    return await _apiService.getAllVisionVideos(
      page: _currentPage,
      perPage: _perPage,
    );
  }

  Future<List<TeacherVisionVideo>> _fetchAssignedVideosPage() async {
    if (!_hasMoreAssignedVideos && _currentPage > 1) return [];

    return await _apiService.getAssignedVideos(
      subjectId: _selectedSubjectId,
    );
  }

  Future<void> loadMoreVideos() async {
    await _fetchVideos(loadMore: true);
  }

  void _applyFilters() {
    // Filter non-assigned videos (videos that are not assigned by teacher)
    filteredNonAssignedVideos = _allVideos.where((video) {
      final matchesSubject = _subjectFilter.isEmpty ||
          video.subject.toLowerCase().contains(_subjectFilter.toLowerCase());
      final matchesLevel = _levelFilter.isEmpty ||
          video.level.toLowerCase().contains(_levelFilter.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          video.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // Show videos that are not assigned by teacher
      return matchesSubject &&
          matchesLevel &&
          matchesSearch &&
          !video.teacherAssigned;
    }).toList();

    // Filter assigned videos (videos that are assigned by teacher)
    filteredAssignedVideos = _assignedVideos.where((video) {
      final matchesSubject = _subjectFilter.isEmpty ||
          video.subject.toLowerCase().contains(_subjectFilter.toLowerCase());
      final matchesLevel = _levelFilter.isEmpty ||
          video.level.toLowerCase().contains(_levelFilter.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          video.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesSubject && matchesLevel && matchesSearch;
    }).toList();

    debugPrint(
        '🔍 Filtered: ${filteredNonAssignedVideos.length} non-assigned, ${filteredAssignedVideos.length} assigned');
  }

  // Enhanced filter methods with better backend integration
  void setSubjectFilter(String subject) {
    _subjectFilter = subject;

    // Find the subject ID for backend filtering
    if (subject.isNotEmpty && _subjects.isNotEmpty) {
      try {
        final matchingSubject = _subjects.firstWhere(
              (s) {
            final name = s['name']?.toString() ?? s['title']?.toString() ?? '';
            return name.toLowerCase() == subject.toLowerCase();
          },
          orElse: () => <String, dynamic>{},
        );

        _selectedSubjectId = matchingSubject['id']?.toString();
        debugPrint(
            '🔍 Selected subject ID: $_selectedSubjectId for subject: $subject');
      } catch (e) {
        debugPrint('⚠️ Error finding subject ID for $subject: $e');
        _selectedSubjectId = null;
      }
    } else {
      _selectedSubjectId = null;
    }

    // Re-fetch from backend with new subject filter
    _fetchVideos();
  }

  void setLevelFilter(String level) {
    _levelFilter = level;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  Future<void> refreshVideos() async {
    await _fetchVideos();
  }


  // Method to clear all filters
  void clearFilters() {
    _subjectFilter = '';
    _levelFilter = '';
    _searchQuery = '';
    _selectedSubjectId = null;
    _fetchVideos();
  }

  Future<bool> assignVideoToStudents(String videoId, List<String> studentIds,
      {String? dueDate}) async {
    try {
      // Call API to assign video
      final success = await _apiService.assignVideoToStudents(
        videoId: videoId,
        studentIds: studentIds,
        dueDate: dueDate,
      );

      if (success) {
        // Refresh data to get updated state from backend
        await refreshVideos();
      }

      return success;
    } catch (e) {
      debugPrint('❌ Error assigning video: $e');
      return false;
    }
  }

  Future<bool> unassignVideo(String assignmentId) async {
    try {
      final success = await _apiService.unassignVision(assignmentId);

      if (success) {
        // Refresh the data to get updated assignment status
        await refreshVideos();
      }

      return success;
    } catch (e) {
      debugPrint('❌ Error unassigning video: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getVisionParticipants(
      String visionId, String selectedClassFilter) async {
    try {
      return await _apiService.getVisionParticipants(visionId , selectedClassFilter);
    } catch (e) {
      debugPrint('❌ Error fetching vision participants: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsForAssignment(
      Map<String, dynamic> data) async {
    try {
      final students = await _apiService.getStudentsForAssignment(data);
      debugPrint('✅ VisionProvider: Fetched ${students.length} students');
      return students;
    } catch (e) {
      debugPrint(
          '❌ VisionProvider: Error fetching students for assignment: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getStudentProgress(String assignmentId) async {
    try {
      return await _apiService.getStudentProgress(assignmentId);
    } catch (e) {
      debugPrint('❌ Error fetching student progress: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getVisionDetails(String visionId) async {
    try {
      return await _apiService.getVisionDetails(visionId);
    } catch (e) {
      debugPrint('❌ Error fetching vision details: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSubmissionStatus(
      String visionCompleteId , newStatus) async {
    try {
      print('hel1 $visionCompleteId');
      return await _apiService.getSubmissionStatus(visionCompleteId , newStatus);
    } catch (e) {
      debugPrint('❌ Error fetching submission status: $e');
      return {};
    }
  }

  // Method to fetch videos by specific subject ID
  Future<void> fetchVideosBySubject(String? subjectId) async {
    _selectedSubjectId = subjectId;
    await _fetchVideos();
  }

  // Get unique subjects from current videos (fallback if subjects API fails)
  List<String> getAvailableSubjects() {
    // Prefer subjects from API if available
    if (_subjects.isNotEmpty) {
      return _subjects
          .map((subject) {
        // Try both 'name' and 'title' fields
        return subject['name']?.toString() ??
            subject['title']?.toString() ??
            '';
      })
          .where((name) => name.isNotEmpty)
          .toSet() // Remove duplicates
          .toList();
    }

    // Fallback to extracting from current videos
    return _allVideos.map((video) => video.subject).toSet().toList();
  }

  // Get unique levels from current videos
  List<String> getAvailableLevels() {
    return _allVideos.map((video) => video.level).toSet().toList();
  }

  // Get subject name by ID
  String getSubjectNameById(String? subjectId) {
    if (subjectId == null || _subjects.isEmpty) return '';

    try {
      final subject = _subjects.firstWhere(
            (s) => s['id']?.toString() == subjectId,
        orElse: () => <String, dynamic>{},
      );

      // Try both 'name' and 'title' fields
      return subject['name']?.toString() ?? subject['title']?.toString() ?? '';
    } catch (e) {
      debugPrint('⚠️ Error getting subject name for ID $subjectId: $e');
      return '';
    }
  }

  // Get subject ID by name
  String? getSubjectIdByName(String subjectName) {
    if (subjectName.isEmpty || _subjects.isEmpty) return null;

    try {
      final subject = _subjects.firstWhere(
            (s) {
          final name = s['name']?.toString() ?? s['title']?.toString() ?? '';
          return name.toLowerCase() == subjectName.toLowerCase();
        },
        orElse: () => <String, dynamic>{},
      );

      return subject['id']?.toString();
    } catch (e) {
      debugPrint('⚠️ Error getting subject ID for name $subjectName: $e');
      return null;
    }
  }
}
