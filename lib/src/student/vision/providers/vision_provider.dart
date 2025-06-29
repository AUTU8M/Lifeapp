import 'package:flutter/foundation.dart';
import '../services/vision_services.dart';
import '../models/vision_video.dart';

class VisionNotFoundException implements Exception {
  final String message;
  VisionNotFoundException([this.message = 'Vision not found']);

  @override
  String toString() => message;
}

class VisionInactiveException implements Exception {
  final String message;
  VisionInactiveException([this.message = 'Vision is inactive']);

  @override
  String toString() => message;
}

class VisionProvider with ChangeNotifier {
  final VisionAPIService _apiService = VisionAPIService();

  Map<String, dynamic>? _currentQuestions;
  bool _isLoadingQuestions = false;
  String _questionsError = '';
  List<VisionVideo> _videos = [];
  bool _isLoading = false;
  String _error = '';
  String _searchText = '';
  String? _currentSubjectId;
  String? _currentLevelId;
  Map<String, bool> _activeFilters = {
  'all': false,
  'completed': false,
  'pending': false,
  'skipped': false,
  'teachersAssigned': false,
    'submitted':false,
    'rejected':false,
  };

  Map<String, dynamic>? get currentQuestions => _currentQuestions;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String get questionsError => _questionsError;
  List<VisionVideo> get videos => _videos;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchText => _searchText;
  Map<String, bool> get activeFilters => _activeFilters;

  List<VisionVideo> get filteredVideos {
    var filtered = _videos;

    // Apply search filter first
    if (_searchText.isNotEmpty) {
      filtered = filtered.where((video) =>
      video.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          video.description.toLowerCase().contains(_searchText.toLowerCase())
      ).toList();
    }

    // Check if "all" is selected — return everything
    if (_activeFilters['all'] == true) return filtered;

    // Get active filters (excluding 'all')
    final activeKeys = _activeFilters.entries
        .where((entry) => entry.value == true && entry.key != 'all')
        .map((e) => e.key)
        .toList();

    // If no filters, return current filtered
    if (activeKeys.isEmpty) return filtered;

    // OR logic: include videos that match any of the selected filters
    filtered = filtered.where((video) {
      final status = video.status.toLowerCase();

      return
        (activeKeys.contains('completed') && status == 'completed') ||
            (activeKeys.contains('pending') && status == 'pending') ||
            (activeKeys.contains('skipped') && status == 'skipped') ||
            (activeKeys.contains('submitted') && status == 'submitted') ||
            (activeKeys.contains('rejected') && status == 'rejected') ||
            (activeKeys.contains('teachersAssigned') && video.teacherAssigned);
    }).toList();


    return filtered;
  }


  Future<void> initWithSubject(String subjectId , String? levelId) async {
    print('xzzzz $subjectId');
    _currentSubjectId = subjectId;
    _currentLevelId = levelId;
    _videos = [];
    _searchText = '';
    _activeFilters = {'completed': false, 'pending': false};
    _error = '';
    _currentQuestions = null;
    _questionsError = '';
    notifyListeners();
    await fetchVideos();
  }

  Future<void> fetchVideos() async {
    if (_currentSubjectId == null || _currentSubjectId!.isEmpty) {
      _error = 'No subject selected';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final videosData = await _apiService.getVisionVideos(_currentSubjectId! , _currentLevelId!);
      _videos = videosData;
      _error = '';
      debugPrint('✅ Successfully loaded ${videosData.length} videos');
    } catch (e) {
      _error = _formatErrorMessage(e);
      debugPrint('❌ Error fetching videos in provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  bool isCurrentLevelCompleted() {
    if (_currentLevelId == null || _currentLevelId!.isEmpty) return false;

    final levelVideos = _videos.where((v) => v.levelId.toString() == _currentLevelId).toList();

    if (levelVideos.isEmpty) return false;

    return levelVideos.every((v) => v.isCompleted);
  }

  String? get currentLevel => _currentLevelId;

  Future<void> refreshVideos() async {
    await fetchVideos();
  }

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchText = '';
    notifyListeners();
  }

  void setFilters(Map<String, bool> filters) {
    print('qaaaaaaaaaaaa $filters');
    _activeFilters = Map.from(filters);
    notifyListeners();
  }
  void toggleFilter(String filterKey) {
    if (_activeFilters.containsKey(filterKey)) {
      _activeFilters[filterKey] = !_activeFilters[filterKey]!;
      notifyListeners();
    }
  }
  void clearFilters() {
    _activeFilters = {'completed': false, 'pending': false};
    notifyListeners();
  }

  Future<void> fetchQuizQuestions(String visionId) async {
    _isLoadingQuestions = true;
    _questionsError = '';
    _currentQuestions = null;
    notifyListeners();

    try {
      final questions = await _apiService.getVisionQuestions(visionId);
      debugPrint('qwer $questions');
      _currentQuestions = questions;
      debugPrint('✅ Successfully loaded quiz questions for vision: $visionId');
    } catch (e) {
      _questionsError = _formatErrorMessage(e);
      debugPrint('❌ Error fetching quiz questions: $e');
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  void clearQuizQuestions() {
    _currentQuestions = null;
    _questionsError = '';
    notifyListeners();
  }

  Future<Map<String, dynamic>?> submitAnswersAndGetResult(
      String visionId, List<Map<String, dynamic>> answers) async {
    try {
      final sanitizedAnswers = answers.map((answer) {
        final sanitized = <String, dynamic>{};
        answer.forEach((key, value) {
          final stringKey = key.toString();
          if (value is int && (key.toLowerCase().contains('id'))) {
            sanitized[stringKey] = value.toString();
          } else {
            if (key == 'answer') {
              sanitized[stringKey] = value ?? '';
            } else {
              sanitized[stringKey] = value;
            }

          }
        });
        return sanitized;
      }).toList();

      final result = await _apiService.submitVideoAnswersAndGetResult(visionId, sanitizedAnswers);

      if (result == null) {
        throw Exception('No response from server');
      }

      if (result['submission_successful'] != true) {
        throw Exception(result['error'] ?? 'Submission failed');
      }

      debugPrint('✅ Successfully submitted answers for vision: $visionId');
      await fetchVideos();
      clearQuizQuestions();
      return result;
    } catch (e) {
      debugPrint('❌ Error submitting answers: $e');
      _questionsError = _formatErrorMessage(e);
      notifyListeners();
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getQuizResult(String visionId) async {
    try {
      final result = await _apiService.getQuizResult(visionId);
      debugPrint('✅ Successfully retrieved quiz result for vision: $visionId');
      return result;
    } catch (e) {
      debugPrint('❌ Error getting quiz result: $e');
      throw Exception(_formatErrorMessage(e));
    }
  }

  Future<bool> skipQuiz(String visionId) async {
    try {
      final success = await _apiService.skipQuiz(visionId);
      print('qwqqqaaa $success');

      if (success) {
        debugPrint('✅ Successfully skipped quiz for vision: $visionId');
        await fetchVideos();
        clearQuizQuestions();
        return true;
      }
      throw Exception('Failed to skip quiz');
    } catch (e) {
      debugPrint('❌ Error skipping quiz: $e');
      throw Exception(_formatErrorMessage(e));
    }
  }

  Future<bool> markQuizPending(String visionId) async {
    try {
      final success = await _apiService.markQuizPending(visionId);
      if (success) {
        debugPrint('✅ Successfully marked quiz pending for vision: $visionId');
        await fetchVideos();
        clearQuizQuestions();
        return true;
      }
      throw Exception('Failed to mark quiz pending');
    } catch (e) {
      debugPrint('❌ Error marking quiz pending: $e');
      throw Exception(_formatErrorMessage(e));
    }
  }

  String _formatErrorMessage(dynamic error) {
    if (error is VisionNotFoundException) {
      return 'Vision not found. Please try another quiz.';
    } else if (error is VisionInactiveException) {
      return 'This quiz is no longer available.';
    } else {
      return error.toString();
    }
  }

  bool get hasActiveFilters => _activeFilters.values.any((filter) => filter);

  int get filteredVideoCount => filteredVideos.length;

  bool hasVideo(String visionId) {
    return _videos.any((video) => video.id.toString() == visionId);
  }

  VisionVideo? getVideoById(String visionId) {
    try {
      return _videos.firstWhere((video) => video.id.toString() == visionId);
    } catch (e) {
      return null;
    }
  }
}