import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VisionVideo {
  final String id;
  final String title;
  final String description;
  final String youtubeUrl;
  final String thumbnailUrl;
  final String status; // "Completed", "Pending", "Start"
  final bool teacherAssigned;
  final bool isCompleted;
  final bool isSkipped;
  final bool isPending;
  final String? levelId;
  final VisionSubject? subject;


  VisionVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.status,
    required this.teacherAssigned,
    required this.isCompleted,
    required this.isSkipped,
    required this.isPending,
    this.levelId,
    this.subject,
  });
  factory VisionVideo.fromJson(Map<String, dynamic> json) {
    String videoId = '';
    String thumbnail = '';
    final statusStr = (json['status']?.toString() ?? '').toLowerCase();

    if (json.containsKey('youtubeUrl') && json['youtubeUrl'] != null) {
      videoId = getVideoIdFromUrl(json['youtubeUrl'] ?? '') ?? '';
      thumbnail = json.containsKey('thumbnailUrl') && json['thumbnailUrl'] != null
          ? json['thumbnailUrl']
          : videoId.isNotEmpty
          ? getThumbnailUrl(videoId)
          : 'https://via.placeholder.com/320x180?text=No+Thumbnail';
    } else {
      thumbnail = 'https://via.placeholder.com/320x180?text=No+Video+URL';
    }
    String? levelId;
    if (json.containsKey('level') && json['level'] != null) {
      final level = json['level'];
      if (level is Map<String, dynamic> && level.containsKey('id')) {
        levelId = level['id'].toString();
      }
    } else {
      // fallback
      levelId = json['levelId']?.toString() ?? json['level_id']?.toString();
    }

    return VisionVideo(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Video',
      description: json['description']?.toString() ?? '',
      youtubeUrl: json['youtubeUrl']?.toString() ?? '',
      thumbnailUrl: thumbnail,
      status: json['status']?.toString() ?? 'start',
      teacherAssigned: json['teacherAssigned'] == true,
      isCompleted: statusStr == 'completed',
      isSkipped: statusStr == 'skipped',
      isPending: statusStr == 'pending',
      levelId: levelId,
    );
  }

  // Extract YouTube video ID from a URL
  static String? getVideoIdFromUrl(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }
  
  // Get YouTube thumbnail URL from video ID
  static String getThumbnailUrl(String videoId, {bool highQuality = false}) {
    if (videoId.isEmpty) {
      return 'https://via.placeholder.com/320x180?text=No+Video+ID';
    }
    
    // Use mqdefault for medium quality or hqdefault for high quality
    String quality = highQuality ? 'hqdefault' : 'mqdefault';
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }


  // Convert model to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeUrl': youtubeUrl,
      'thumbnailUrl': thumbnailUrl,
      'status': status,
      'teacherAssigned': teacherAssigned,
    };
  }
  
  // Create a copy of this VisionVideo with modified fields
  VisionVideo copyWith({
    String? id,
    String? title,
    String? description,
    String? youtubeUrl,
    String? thumbnailUrl,
    String? status,
    bool? teacherAssigned,
  }) {
    return VisionVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      status: status ?? this.status,
      teacherAssigned: teacherAssigned ?? this.teacherAssigned,
      isCompleted: isCompleted, // Keep original completion status
      isPending: isPending,
      isSkipped: isSkipped,
    );
  }
}
class VisionSubject {
  final String id;
  final Map<String, dynamic> title;

  VisionSubject({
    required this.id,
    required this.title,
  });

  factory VisionSubject.fromJson(Map<String, dynamic> json) {
    return VisionSubject(
      id: json['id'].toString(),
      title: json['title'] ?? {},
    );
  }

  String get name => title['en'] ?? 'Unknown';
}
