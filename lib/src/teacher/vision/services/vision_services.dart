import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/storage_utils.dart';
import '../../../common/helper/string_helper.dart';
import '../models/vision_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}

class TeacherVisionAPIService {
  static const String baseUrl = "https://api.life-lab.org/v3";
  static const int _REQUEST_TIMEOUT = 15;

  Future<String?> _getAuthToken() async {
    return StorageUtil.getString(StringHelper.token);
  }

  // Method to get all videos across all subjects
  Future<List<TeacherVisionVideo>> getAllVisionVideos({
    String? subjectId,
    int page = 1,
    int perPage = 10, // Default page size
  })  async {
    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token not found, using mock data');
        return getMockVideos(subjectId: subjectId);
      }

      // Handle the case where API requires subject ID
      if (subjectId == null || subjectId.isEmpty) {
        debugPrint(
            '⚠️ No subject ID provided, fetching videos for all subjects');
        return getAllVisionVideosAcrossSubjects();
      }

      final Map<String, String> queryParams = {
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      if (subjectId != null && subjectId.isNotEmpty) {
        queryParams['la_subject_id'] = subjectId;
      }

      debugPrint('🔍 Filtering by subject ID: $subjectId');

      const endpoint = '$baseUrl/teachers/visions-list';
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      debugPrint('🔄 Trying endpoint: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Request timed out for $uri');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('📊 Response data structure: ${responseData.keys}');

        if (responseData['status'] == 200 && responseData['data'] != null) {
          List<dynamic> visionsData = [];

          // Handle paginated response structure
          if (responseData['data']['visions'] != null) {
            final visionsObject = responseData['data']['visions'];

            if (visionsObject is Map<String, dynamic> &&
                visionsObject['data'] != null) {
              visionsData = visionsObject['data'] as List<dynamic>;
              debugPrint(
                  '✅ Found ${visionsData.length} visions in paginated data.visions.data');
            } else if (visionsObject is List) {
              visionsData = visionsObject;
              debugPrint('✅ Found visions directly in data.visions list');
            }
          } else if (responseData['data']['videos'] != null) {
            final videosObject = responseData['data']['videos'];
            if (videosObject is Map<String, dynamic> &&
                videosObject['data'] != null) {
              visionsData = videosObject['data'] as List<dynamic>;
            } else if (videosObject is List) {
              visionsData = videosObject;
            }
          } else if (responseData['data'] is List) {
            visionsData = responseData['data'];
          }

          if (visionsData.isNotEmpty) {
            final videos = visionsData.map((item) {
              debugPrint('🎬 Processing video item: ${item.keys}');
              return TeacherVisionVideo.fromJson(item);
            }).toList();
            debugPrint(
                '🎉 Successfully fetched ${videos.length} videos from API');
            return videos;
          } else {
            debugPrint('⚠️ API returned empty visions list');
            return [];
          }
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else if (response.statusCode == 401) {
        debugPrint('🔐 Authentication failed - token may be invalid');
        await SharedPreferences.getInstance()
            .then((prefs) => prefs.remove(StringHelper.token));
      } else {
        debugPrint('❌ HTTP Error ${response.statusCode}: ${response.body}');
      }

      debugPrint('⚠️ API call failed, using mock data');
      return getMockVideos(subjectId: subjectId);
    } catch (e) {
      debugPrint('💥 General API Error: $e');
      return getMockVideos(subjectId: subjectId);
    }
  }

// Method to get videos for a specific subject (requires subject ID)
  Future<List<TeacherVisionVideo>> getVisionVideosBySubject(
      String subjectId, {
        int page = 1,
        int perPage = 10, // Default page size
      })  async {
    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token not found, using mock data');
        return getMockVideos(subjectId: subjectId);
      }

      final Map<String, String> queryParams = {
        'la_subject_id': subjectId,
        'per_page': perPage.toString(),
        'page': page.toString(),
      };


      debugPrint('🔍 Fetching videos for subject ID: $subjectId');

      const endpoint = '$baseUrl/teachers/visions-list';
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      debugPrint('🔄 Calling endpoint: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Request timed out for $uri');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 200 && responseData['data'] != null) {
          List<dynamic> visionsData = [];

          // Handle the paginated response structure
          if (responseData['data']['visions'] != null) {
            final visionsObject = responseData['data']['visions'];

            // Check if it's a paginated response with 'data' field
            if (visionsObject is Map<String, dynamic> &&
                visionsObject['data'] != null) {
              visionsData = visionsObject['data'] as List<dynamic>;
              debugPrint(
                  '✅ Found ${visionsData.length} visions in paginated data.visions.data');

              // Log pagination info
              if (visionsObject['meta'] != null) {
                final meta = visionsObject['meta'];
                debugPrint(
                    '📄 Pagination: Page ${meta['current_page']} of ${meta['last_page']}, Total: ${meta['total']}');
              }
            }
            // Fallback: if it's directly a list
            else if (visionsObject is List) {
              visionsData = visionsObject;
              debugPrint(
                  '✅ Found ${visionsData.length} visions directly in data.visions');
            }
          }
          // Alternative structures
          else if (responseData['data']['videos'] != null) {
            final videosObject = responseData['data']['videos'];
            if (videosObject is Map<String, dynamic> &&
                videosObject['data'] != null) {
              visionsData = videosObject['data'] as List<dynamic>;
            } else if (videosObject is List) {
              visionsData = videosObject;
            }
          } else if (responseData['data'] is List) {
            visionsData = responseData['data'];
          }
          if (visionsData.isNotEmpty) {
            final videos = visionsData.map((item) {
              debugPrint('🎬 Processing video item: ${item.keys}');
              return TeacherVisionVideo.fromJson(item);
            }).toList();
            debugPrint(
                '🎉 Successfully fetched ${videos.length} videos for subject $subjectId');
            return videos;
          } else {
            debugPrint(
                '⚠️ API returned empty videos list for subject $subjectId');
            // Return empty list instead of mock data when API returns empty but valid response
            return [];
          }
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else {
        debugPrint('❌ HTTP Error ${response.statusCode}: ${response.body}');
      }

      debugPrint('⚠️ API call failed, using mock data');
      return getMockVideos(subjectId: subjectId);
    } catch (e) {
      debugPrint('💥 Error fetching videos for subject $subjectId: $e');
      return getMockVideos(subjectId: subjectId);
    }
  }

// Method to get videos across all subjects
  Future<List<TeacherVisionVideo>> getAllVisionVideosAcrossSubjects() async {
    try {
      // First, get all available subjects
      final subjects = await getSubjects();

      if (subjects.isEmpty) {
        debugPrint('⚠️ No subjects found, using mock data');
        return getMockVideos();
      }

      List<TeacherVisionVideo> allVideos = [];

      // Fetch videos for each subject
      for (final subject in subjects) {
        final subjectId = subject['id']?.toString();
        if (subjectId != null) {
          debugPrint(
              '🔄 Fetching videos for subject: ${subject['name']} (ID: $subjectId)');
          final videos = await getVisionVideosBySubject(subjectId);
          allVideos.addAll(videos);
        }
      }

      debugPrint(
          '🎉 Successfully fetched ${allVideos.length} videos across all subjects');
      return allVideos;
    } catch (e) {
      debugPrint('💥 Error fetching videos across subjects: $e');
      return getMockVideos();
    }
  }

  // Updated method to fetch assigned visions using the new endpoint
  Future<List<TeacherVisionVideo>> getAssignedVideos(
      {String? subjectId}) async {
    try {
      // Check authentication
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _getMockAssignedVideos();
      }

      // Build query parameters
      final Map<String, String> queryParams = {};
      if (subjectId != null && subjectId.isNotEmpty) {
        queryParams['la_subject_id'] = subjectId;
      }

      // Define endpoints to try in order of preference
      final endpoints = [
        '$baseUrl/teachers/assigned-visions',
        '$baseUrl/teachers/visions/assigned',
        '$baseUrl/teachers/visions',
      ];

      // Try each endpoint
      for (final endpoint in endpoints) {
        try {
          final result = await _fetchFromEndpoint(endpoint, queryParams, token);
          if (result.isNotEmpty) {
            debugPrint(
                '✅ Successfully fetched ${result.length} assigned videos from: $endpoint');
            return result;
          }
          debugPrint('⚠️ Empty response from: $endpoint, trying next...');
        } catch (e) {
          debugPrint('💥 Error with endpoint $endpoint: $e');
          continue;
        }
      }

      // All endpoints failed
      debugPrint('⚠️ All assigned video endpoints failed, using mock data');
      return _getMockAssignedVideos();
    } catch (e) {
      debugPrint('❌ Unexpected error in getAssignedVideos: $e');
      return _getMockAssignedVideos();
    }
  }

  /// Fetch data from a specific endpoint
  Future<List<TeacherVisionVideo>> _fetchFromEndpoint(
      String endpoint, Map<String, String> queryParams, String token) async {
    final uri = Uri.parse(endpoint)
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    debugPrint('🔄 Fetching assigned videos from: $uri');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(
      const Duration(seconds: _REQUEST_TIMEOUT),
      onTimeout: () => throw TimeoutException(
          'Request timed out after $_REQUEST_TIMEOUT seconds'),
    );

    debugPrint('📡 Response status: ${response.statusCode}');
    debugPrint('📡 Response body: ${response.body}');

    // Handle different HTTP status codes
    switch (response.statusCode) {
      case 200:
        return _parseSuccessResponse(response.body);
      case 401:
        throw Exception('Unauthorized - invalid token');
      case 403:
        throw Exception('Forbidden - insufficient permissions');
      case 404:
        throw Exception('Endpoint not found');
      case 422:
        throw Exception('Unprocessable entity - backend method error');
      case 500:
        throw Exception('Internal server error');
      default:
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  /// Parse successful API response
  List<TeacherVisionVideo> _parseSuccessResponse(String responseBody) {
    try {
      final Map<String, dynamic> responseData = json.decode(responseBody);

      // Validate response structure
      if (responseData['status'] != 200) {
        throw Exception(
            'API error: ${responseData['message'] ?? 'Unknown error'}');
      }

      if (responseData['data'] == null) {
        throw Exception('No data field in response');
      }

      // Extract video data using multiple possible structures
      final List<dynamic> videoData = _extractVideoData(responseData['data']);

      if (videoData.isEmpty) {
        debugPrint('⚠️ No videos found in response');
        return [];
      }

      // Convert to TeacherVisionVideo objects
      final videos = videoData
          .map((item) {
            try {
              return TeacherVisionVideo.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              debugPrint('⚠️ Failed to parse video item: $e');
              return null;
            }
          })
          .where((video) => video != null)
          .cast<TeacherVisionVideo>()
          .toList();

      debugPrint('🎉 Successfully parsed ${videos.length} videos');
      return videos;
    } catch (e) {
      debugPrint('💥 Error parsing response: $e');
      throw Exception('Failed to parse API response: $e');
    }
  }

  /// Extract video data from various possible response structures
  List<dynamic> _extractVideoData(Map<String, dynamic> data) {
    // Try different possible structures in order of likelihood

    // Structure 1: data.assigned_visions (direct array)
    if (data['assigned_visions'] is List) {
      debugPrint('📝 Using structure: data.assigned_visions');
      return data['assigned_visions'];
    }

    // Structure 2: data.visions.data (nested object with data array) - YOUR CURRENT API
    if (data['visions'] is Map) {
      final visions = data['visions'] as Map<String, dynamic>;
      if (visions['data'] is List) {
        debugPrint('📝 Using structure: data.visions.data');
        return visions['data'];
      }
    }

    // Structure 3: data.visions (direct array)
    if (data['visions'] is List) {
      debugPrint('📝 Using structure: data.visions');
      return data['visions'];
    }

    // Structure 4: data.assignments (alternative naming)
    if (data['assignments'] is List) {
      debugPrint('📝 Using structure: data.assignments');
      return data['assignments'];
    }

    // No recognized structure found
    debugPrint('⚠️ No recognized data structure found in response');
    debugPrint('📋 Available keys: ${data.keys.toList()}');
    return [];
  }

  /// Get mock assigned videos as fallback
  List<TeacherVisionVideo> _getMockAssignedVideos() {
    final mockData = getMockVideos();
    return mockData.where((video) => video.teacherAssigned).toList();
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found');
        return [];
      }

      final uri = Uri.parse('$baseUrl/subjects');
      debugPrint('🔄 Fetching subjects from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Subjects request timed out');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Subjects response status: ${response.statusCode}');
      debugPrint('📡 Subjects response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 200 && responseData['data'] != null) {
          // FIX: Handle the correct response structure
          final dynamic data = responseData['data'];

          // Check if data has a 'subject' key (as shown in your logs)
          if (data is Map<String, dynamic> && data['subject'] != null) {
            final List<dynamic> subjectList = data['subject'] as List;
            return subjectList
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
          }
          // If data is directly a list
          else if (data is List) {
            return data.map((item) => Map<String, dynamic>.from(item)).toList();
          }
          // If data is a map with other possible keys
          else if (data is Map<String, dynamic>) {
            // Look for common keys that might contain the subjects array
            for (String key in ['subjects', 'items', 'list']) {
              if (data[key] is List) {
                final List<dynamic> subjectList = data[key] as List;
                return subjectList
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();
              }
            }
          }
        }
      }
      debugPrint('❌ Error fetching subjects: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching subjects: $e');
      return [];
    }
  }

  Future<bool> assignVideoToStudents({
    required String videoId,
    required List<String> studentIds,
    String? dueDate,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found');
        return false;
      }

      final uri = Uri.parse('$baseUrl/teachers/assign-visions');

      // Convert IDs to integers if needed
      final payload = {
        'vision_id': int.tryParse(videoId) ?? videoId,
        'user_ids': studentIds.map((id) => int.tryParse(id) ?? id).toList(),
        'due_date': dueDate,
      };

      debugPrint('📤 Sending payload: $payload');

      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      )
          .timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Assign request timed out');
        return http.Response(
            '{"status": 408, "message": "Request timed out"}', 408);
      });

      debugPrint('📡 Assign response status: ${response.statusCode}');
      debugPrint('📡 Assign response body: ${response.body}');

      // Handle different success scenarios
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          // Check for different success indicators
          return responseData['status'] == 200 ||
              responseData['success'] == true ||
              responseData.containsKey('data');
        } catch (e) {
          // If JSON parsing fails but status is 200, assume success
          debugPrint('⚠️ JSON parsing failed but status is success: $e');
          return true;
        }
      } else {
        debugPrint(
            '❌ Error assigning video: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Assign video error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getStudentProgress(String assignmentId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _mockProgress();
      }

      final uri = Uri.parse('$baseUrl/vision/progress/$assignmentId');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Progress request timed out, using mock data');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Progress response status: ${response.statusCode}');
      debugPrint('📡 Progress response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          return responseData;
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
          return _mockProgress();
        }
      } else {
        debugPrint('❌ Error: ${response.statusCode} - ${response.body}');
        return _mockProgress();
      }
    } catch (e) {
      debugPrint('❌ API Error: $e');
      return _mockProgress();
    }
  }

  Future<Map<String, dynamic>> getVisionDetails(String visionId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _mockVisionDetails(visionId);
      }

      final uri = Uri.parse('$baseUrl/vision/$visionId');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Vision details request timed out, using mock data');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Vision details response status: ${response.statusCode}');
      debugPrint('📡 Vision details response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          return responseData;
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
          return _mockVisionDetails(visionId);
        }
      } else {
        debugPrint('❌ Error: ${response.statusCode} - ${response.body}');
        return _mockVisionDetails(visionId);
      }
    } catch (e) {
      debugPrint('❌ API Error: $e');
      return _mockVisionDetails(visionId);
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsForAssignment(
      Map<String, dynamic> data) async {
    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _mockStudents();
      }

      // Validate required fields
      if (!data.containsKey('school_id') || data['school_id'] == null) {
        debugPrint('❌ Missing school_id in request data');
        throw Exception('School ID is required');
      }
      if (!data.containsKey('la_section_id') ||
          data['la_section_id'] == null ||
          data['la_section_id'].toString().isEmpty) {
        debugPrint('❌ Missing or empty la_section_id in request data: $data');
        throw Exception('Section ID is required');
      }

      final uri = Uri.parse('$baseUrl/teachers/class-students');
      debugPrint('🔄 Fetching students from: $uri');
      debugPrint('📤 Request data: $data');

      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      )
          .timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Students request timed out');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Students response status: ${response.statusCode}');
      debugPrint('📡 Students response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('📊 Response data structure: ${responseData.keys}');

        if (responseData['status'] == 200 && responseData['data'] != null) {
          List<dynamic> studentsData = [];

          // Handle the specific API response structure: data.users.data
          if (responseData['data']['users'] != null) {
            final usersObject = responseData['data']['users'];

            // Check if users has a 'data' field (paginated response)
            if (usersObject is Map<String, dynamic> &&
                usersObject['data'] != null) {
              studentsData = usersObject['data'];
              debugPrint(
                  '✅ Found ${studentsData.length} students in data.users.data');

              // Log pagination info if available
              if (usersObject['meta'] != null) {
                final meta = usersObject['meta'];
                debugPrint(
                    '📄 Pagination: Page ${meta['current_page']} of ${meta['last_page']}, Total: ${meta['total']}');
              }
            }
            // Fallback: if users is directly a list
            else if (usersObject is List) {
              studentsData = usersObject;
              debugPrint(
                  '✅ Found ${studentsData.length} students directly in data.users');
            }
          }
          // Handle other possible response structures
          else if (responseData['data'] is List) {
            studentsData = responseData['data'];
            debugPrint('✅ Found ${studentsData.length} students in data list');
          } else if (responseData['data']['students'] != null) {
            studentsData = responseData['data']['students'];
            debugPrint(
                '✅ Found ${studentsData.length} students in data.students');
          } else if (responseData['data']['class_students'] != null) {
            studentsData = responseData['data']['class_students'];
            debugPrint(
                '✅ Found ${studentsData.length} students in data.class_students');
          } else if (responseData['data']['data'] != null) {
            studentsData = responseData['data']['data'];
            debugPrint('✅ Found ${studentsData.length} students in data.data');
          } else {
            debugPrint('⚠️ No students found in response, checking other keys');
            // Try to find any list in the response
            for (var key in responseData['data'].keys) {
              final value = responseData['data'][key];
              if (value is List) {
                studentsData = value;
                debugPrint(
                    '✅ Found ${studentsData.length} students in data.$key');
                break;
              } else if (value is Map<String, dynamic> &&
                  value['data'] is List) {
                studentsData = value['data'];
                debugPrint(
                    '✅ Found ${studentsData.length} students in data.$key.data');
                break;
              }
            }
          }

          if (studentsData.isEmpty) {
            debugPrint('⚠️ API returned empty students list');
            return [];
          }

          // Transform the student data to ensure consistent format
          final studentsList = studentsData.map((item) {
            final student = Map<String, dynamic>.from(item);

            // Ensure required fields exist with fallback values
            if (!student.containsKey('id') || student['id'] == null) {
              debugPrint('⚠️ Student missing ID: $student');
              student['id'] = student['user_id']?.toString() ??
                  'unknown_${DateTime.now().millisecondsSinceEpoch}';
            } else {
              // Ensure ID is string
              student['id'] = student['id'].toString();
            }

            if (!student.containsKey('name') ||
                student['name'] == null ||
                student['name'].toString().isEmpty) {
              student['name'] = 'Student ${student['id']}';
            }

            return student;
          }).toList();

          debugPrint(
              '✅ Successfully fetched ${studentsList.length} students from API');
          debugPrint(
              '👥 Sample student: ${studentsList.isNotEmpty ? studentsList.first : 'none'}');
          return studentsList;
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
          return [];
        }
      } else if (response.statusCode == 401) {
        debugPrint('🔐 Authentication failed - token may be invalid');
        await SharedPreferences.getInstance()
            .then((prefs) => prefs.remove(StringHelper.token));
        return [];
      } else if (response.statusCode == 422) {
        debugPrint('⚠️ Validation error: ${response.body}');
        throw Exception('Validation error: ${response.body}');
      } else {
        debugPrint('❌ HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      debugPrint('⏰ Request timeout: $e');
      return [];
    } on FormatException catch (e) {
      debugPrint('❌ JSON parsing error: $e');
      return [];
    } catch (e) {
      debugPrint('❌ API Error: $e');
      return [];
    }
  }

  Future<bool> unassignVision(String assignmentId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found');
        return false;
      }

      final uri = Uri.parse('$baseUrl/vision/assignment/$assignmentId');
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Unassign request timed out');
        return http.Response(
            '{"status": 408, "message": "Request timed out"}', 408);
      });

      debugPrint('📡 Unassign response status: ${response.statusCode}');
      debugPrint('📡 Unassign response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == 200;
      } else {
        debugPrint('❌ Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Unassign vision error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getVisionParticipants(
      String visionId, String? className) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _mockParticipants();
      }

      final uri = Uri.parse('$baseUrl/teachers/vision/$visionId/participants-with-answers?class=$className');
      debugPrint('🔄 Fetching participants from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Participants request timed out, using mock data');
        throw TimeoutException('Request timed out');
      });

      debugPrint('📡 Participants response status: ${response.statusCode}');
      debugPrint('📡 Participants response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 200 && responseData['data'] != null) {
          // FIXED: Changed from 'participants' to 'data'
          final Map<String, dynamic> data = responseData['data'];
          final List<dynamic> participantsData = data['participants'] ?? [];

          debugPrint('📊 Found ${participantsData.length} participants');

          if (participantsData.isEmpty) {
            debugPrint('ℹ️ No participants found for vision $visionId');
            // Don't use mock data for empty results - this is valid
            return [];
          }

          // Debug: Print each participant
          for (var participant in participantsData) {
            debugPrint(
                '👤 Student: ${participant['student_name']} - Status: ${participant['submission_status']}');
          }

          return participantsData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
          return _mockParticipants();
        }
      } else {
        debugPrint('❌ Error: ${response.statusCode} - ${response.body}');
        return _mockParticipants();
      }
    } catch (e) {
      debugPrint('❌ API Error: $e');
      return _mockParticipants();
    }
  }

  Future<Map<String, dynamic>> getSubmissionStatus(
      String visionCompleteId , newStatus) async {
    try {
      print('zzzz ${newStatus}');
      final token = await _getAuthToken();
      if (token == null) {
        debugPrint('❌ Authentication token not found, using mock data');
        return _mockSubmissionStatus();
      }

      final uri =
          Uri.parse('$baseUrl/teachers/vision-submission/$visionCompleteId/status');
      debugPrint('🔄 Fetching submission status from: $uri');

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'comment': 'Ok',
          'status': newStatus.toString().split('.').last,
        }),
      ).timeout(const Duration(seconds: _REQUEST_TIMEOUT), onTimeout: () {
        debugPrint('⏰ Submission status request timed out, using mock data');
        throw TimeoutException('Request timed out');
      });


      debugPrint(
          '📡 Submission status response status: ${response.statusCode}');
      debugPrint('📡 Submission status response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          print('weqqq $responseData');
          return responseData;
        } else {
          debugPrint(
              '❌ API error: ${responseData['message'] ?? 'Unknown error'}');
          return _mockSubmissionStatus();
        }
      } else {
        debugPrint('❌ Error: ${response.statusCode} - ${response.body}');
        return _mockSubmissionStatus();
      }
    } catch (e) {
      debugPrint('❌ API Error: $e');
      return _mockSubmissionStatus();
    }
  }

  String _extractYouTubeId(String url) {
    if (url.isEmpty) return '';

    final RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  int min(int a, int b) => a < b ? a : b;

  List<TeacherVisionVideo> getMockVideos({String? subjectId}) {
    List<TeacherVisionVideo> all = [
      TeacherVisionVideo(
        id: '101',
        title: 'Science Basics - Gravity',
        description: 'Understanding gravity for beginners...',
        youtubeUrl: 'https://youtu.be/uzjA5d0QXv8?si=N6tIBTAKV83bk5Lp',
        thumbnailUrl: TeacherVisionVideo.getThumbnailUrl('uzjA5d0QXv8'),
        subject: 'Science',
        la_subject_id: '1',
        level: 'Beginner',
        teacherAssigned: true,
        submittedCount: 3,
        totalAssignedStudents: 10,
        dueDate: '2024-12-31',
      ),
      TeacherVisionVideo(
        id: '102',
        title: 'Advanced Algebra Concepts',
        description: 'Dive deep into algebraic structures...',
        youtubeUrl: 'https://youtu.be/moigYK2ixBo?si=nRfYrZrK6cMUzAyZ',
        thumbnailUrl: TeacherVisionVideo.getThumbnailUrl('moigYK2ixBo'),
        subject: 'Maths',
        la_subject_id: '2',
        level: 'SAdvanced',
        teacherAssigned: false,
      ),
      TeacherVisionVideo(
        id: '103',
        title: 'Introduction to Chemistry',
        description: 'Learn the basics of chemistry...',
        youtubeUrl: 'https://www.youtube.com/watch?v=0Rqw6YKfDC8',
        thumbnailUrl: TeacherVisionVideo.getThumbnailUrl('0Rqw6YKfDC8'),
        subject: 'Science',
        la_subject_id: '1',
        level: 'Beginner',
        teacherAssigned: false,
      ),
      TeacherVisionVideo(
        id: '104',
        title: 'Geometry Fundamentals',
        description: 'Understand the principles of geometry...',
        youtubeUrl: 'https://www.youtube.com/watch?v=WEDIj9JBTC8',
        thumbnailUrl: TeacherVisionVideo.getThumbnailUrl('WEDIj9JBTC8'),
        subject: 'Maths',
        la_subject_id: '2',
        level: 'Intermediate',
        teacherAssigned: true,
        submittedCount: 7,
        totalAssignedStudents: 15,
        dueDate: '2024-11-30',
      ),
    ];

    debugPrint(
        '🎭 Returning ${subjectId != null ? 'filtered' : 'all'} mock videos (${all.length} total)');

    if (subjectId != null) {
      final filtered = all.where((v) => v.la_subject_id == subjectId).toList();
      debugPrint(
          '🔍 Filtered to ${filtered.length} videos for subject $subjectId');
      return filtered;
    }

    return all;
  }

  Map<String, dynamic> _mockProgress() => {
        'status': 200,
        'data': {
          'total_students': 25,
          'completed': 12,
          'in_progress': 8,
          'not_started': 5,
          'students': []
        }
      };

  Map<String, dynamic> _mockVisionDetails(String visionId) => {
        'status': 200,
        'data': {
          'id': visionId,
          'title': 'Mock Vision Video',
          'description': 'This is a mock video description...',
          'youtube_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          'questions': [
            {
              'id': '1',
              'text': 'What is the main topic of this video?',
              'options': ['Science', 'Mathematics']
            },
            {
              'id': '2',
              'text': 'What did you learn from this video?',
              'type': 'text'
            }
          ]
        }
      };

  List<Map<String, dynamic>> _mockStudents() => [
        {
          'id': '1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'grade': '10A'
        },
        {
          'id': '2',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'grade': '10A'
        },
        {
          'id': '3',
          'name': 'Bob Johnson',
          'email': 'bob@example.com',
          'grade': '10B'
        },
        {
          'id': '4',
          'name': 'Alice Brown',
          'email': 'alice@example.com',
          'grade': '10B'
        },
      ];

  List<Map<String, dynamic>> _mockParticipants() => [
        {
          'id': '1',
          'student_id': '1',
          'student_name': 'John Doe',
          'email': 'john@example.com',
          'grade': '10A',
          'status': 'completed',
          'completion_date': '2024-11-15',
          'score': 85,
        },
        {
          'id': '2',
          'student_id': '2',
          'student_name': 'Jane Smith',
          'email': 'jane@example.com',
          'grade': '10A',
          'status': 'in_progress',
          'completion_date': null,
          'score': null,
        },
        {
          'id': '3',
          'student_id': '3',
          'student_name': 'Bob Johnson',
          'email': 'bob@example.com',
          'grade': '10B',
          'status': 'not_started',
          'completion_date': null,
          'score': null,
        },
      ];

  Map<String, dynamic> _mockSubmissionStatus() => {
        'status': 200,
        'data': {
          'id': '1',
          'vision_id': '101',
          'student_id': '1',
          'student_name': 'John Doe',
          'submission_status': 'completed',
          'submitted_at': '2024-11-15T10:30:00Z',
          'score': 85,
          'answers': [
            {
              'question_id': '1',
              'question_text': 'What is the main topic of this video?',
              'answer': 'Science',
              'is_correct': true,
            },
            {
              'question_id': '2',
              'question_text': 'What did you learn from this video?',
              'answer': 'I learned about gravity and its effects on objects.',
              'is_correct': null,
            }
          ],
          'total_questions': 2,
          'correct_answers': 1,
        }
      };
}
