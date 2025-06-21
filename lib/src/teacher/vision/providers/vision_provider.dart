import 'package:flutter/material.dart';
import '../models/vision_model.dart';
import '../services/vision_services.dart';

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

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get subjects => _subjects;

  VisionProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchSubjects();
    await _fetchVideos();
  }

  Future<void> _fetchSubjects() async {
    try {
      _subjects = await _apiService.getSubjects();
      debugPrint('🎉 Fetched ${_subjects.length} subjects');

      // Add error handling for empty subjects
      if (_subjects.isEmpty) {
        debugPrint('⚠️ No subjects returned from API, using fallback');
        // Provide fallback subjects if needed
        _subjects = [
          {'id': '1', 'title': 'Science', 'name': 'Science'},
          {'id': '2', 'title': 'Maths', 'name': 'Maths'},
        ];
      }
    } catch (e) {
      debugPrint('❌ Error fetching subjects: $e');
      // Provide fallback subjects
      _subjects = [
        {'id': '1', 'title': 'Science', 'name': 'Science'},
        {'id': '2', 'title': 'Maths', 'name': 'Maths'},
      ];
    }
  }

  Future<void> _fetchVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch all vision videos from API
      final allVideos =
          await _apiService.getAllVisionVideos(subjectId: _selectedSubjectId);

      _allVideos.clear();
      _allVideos.addAll(allVideos);

      // Fetch assigned videos from API
      final assignedVideos =
          await _apiService.getAssignedVideos(subjectId: _selectedSubjectId);
      _assignedVideos.clear();
      _assignedVideos.addAll(assignedVideos);

      debugPrint(
          '🎉 Fetched ${_allVideos.length} total videos and ${_assignedVideos.length} assigned videos');

      _applyFilters();

      // Clear any previous error messages on successful fetch
      _errorMessage = null;
    } catch (e) {
      debugPrint('❌ Error fetching videos: $e');
      _errorMessage =
          'Failed to load videos. Please check your connection and try again.';

      // In case of error, still show mock data to prevent empty screen
      _allVideos.clear();
      _allVideos
          .addAll(_apiService.getMockVideos(subjectId: _selectedSubjectId));

      // For assigned videos, filter mock data
      final mockAssigned = _apiService
          .getMockVideos()
          .where((video) => video.teacherAssigned)
          .toList();
      _assignedVideos.clear();
      _assignedVideos.addAll(mockAssigned);

      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
