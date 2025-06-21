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
  });

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

  factory VisionVideo.fromJson(Map<String, dynamic> json) {
    // Extract YouTube video ID from URL if thumbnailUrl is not provided
    String videoId = '';
    String thumbnail = '';
    var stat = json;
    print('zzzzzz $stat');
    if (json.containsKey('youtubeUrl') && json['youtubeUrl'] != null) {
      videoId = getVideoIdFromUrl(json['youtubeUrl'] ?? '') ?? '';
      
      // Use thumbnailUrl from API if provided, otherwise generate from video ID
      thumbnail = json.containsKey('thumbnailUrl') && json['thumbnailUrl'] != null
          ? json['thumbnailUrl']
          : videoId.isNotEmpty 
              ? getThumbnailUrl(videoId)
              : 'https://via.placeholder.com/320x180?text=No+Thumbnail';
    } else {
      thumbnail = 'https://via.placeholder.com/320x180?text=No+Video+URL';
    }

    return VisionVideo(
        id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Video',
      description: json['description']?.toString() ?? '',
      youtubeUrl: json['youtubeUrl']?.toString() ?? '',
      thumbnailUrl: thumbnail,
      status: json['status']?.toString() ?? 'Start',
      teacherAssigned: json['teacherAssigned'] == true,
      isCompleted: json['status']?.toString() == 'completed',
      isSkipped :  json['status']?.toString() == 'skipped',
      isPending :  json['status']?.toString() == 'pending',
    );
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