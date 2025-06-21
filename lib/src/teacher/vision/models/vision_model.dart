import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SubjectInfo {
  final int id;
  final String title;
  final String? heading;
  final String? image;

  SubjectInfo({
    required this.id,
    required this.title,
    this.heading,
    this.image,
  });

  factory SubjectInfo.fromJson(Map<String, dynamic> json) {
    // Handle different title formats like "(en: Science)", "{en: Science}" or just "Science"
    String titleText = '';
    if (json['title'] != null) {
      String rawTitle = json['title'].toString();
      
      // Extract text from formats like "(en: Science)" or "{en: Science}"
      if (rawTitle.contains(':')) {
        // Handle both parentheses and curly braces
        RegExp regex = RegExp(r'[\(\{].*?:\s*(.+?)[\)\}]');
        final match = regex.firstMatch(rawTitle);
        titleText = match?.group(1) ?? rawTitle;
      } else {
        titleText = rawTitle;
      }
    }

    return SubjectInfo(
      id: json['id'] ?? 0,
      title: titleText,
      heading: json['heading']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'heading': heading,
      'image': image,
    };
  }

  // Add toString method to return clean title when object is converted to string
  @override
  String toString() {
    return title;
  }

  // Add a getter for display purposes
  String get displayName => title;
}

class LevelInfo {
  final int id;
  final String title;
  final String description;
  final int missionPoints;
  final int quizPoints;
  final int riddlePoints;
  final int puzzlePoints;
  final int jigyasaPoints;
  final int pragyaPoints;
  final int quizTime;
  final int riddleTime;
  final int puzzleTime;
  final int unlock;

  LevelInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.missionPoints,
    required this.quizPoints,
    required this.riddlePoints,
    required this.puzzlePoints,
    required this.jigyasaPoints,
    required this.pragyaPoints,
    required this.quizTime,
    required this.riddleTime,
    required this.puzzleTime,
    required this.unlock,
  });

  factory LevelInfo.fromJson(Map<String, dynamic> json) {
    return LevelInfo(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      missionPoints: json['mission_points'] ?? 0,
      quizPoints: json['quiz_points'] ?? 0,
      riddlePoints: json['riddle_points'] ?? 0,
      puzzlePoints: json['puzzle_points'] ?? 0,
      jigyasaPoints: json['jigyasa_points'] ?? 0,
      pragyaPoints: json['pragya_points'] ?? 0,
      quizTime: json['quiz_time'] ?? 0,
      riddleTime: json['riddle_time'] ?? 0,
      puzzleTime: json['puzzle_time'] ?? 0,
      unlock: json['unlock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'mission_points': missionPoints,
      'quiz_points': quizPoints,
      'riddle_points': riddlePoints,
      'puzzle_points': puzzlePoints,
      'jigyasa_points': jigyasaPoints,
      'pragya_points': pragyaPoints,
      'quiz_time': quizTime,
      'riddle_time': riddleTime,
      'puzzle_time': puzzleTime,
      'unlock': unlock,
    };
  }

  // Add toString method to return clean title when object is converted to string
  @override
  String toString() {
    return title;
  }

  // Add a getter for display purposes
  String get displayName => title;
}

class TeacherVisionVideo {
  final String id;
  final String title;
  final String description;
  final String youtubeUrl;
  final String thumbnailUrl;
  final String subject; // Keep as String for backward compatibility
  final SubjectInfo? subjectInfo; // Add detailed subject info separately
  final String level; // Keep as String for backward compatibility
  final LevelInfo? levelInfo; // Add detailed level info separately
  bool teacherAssigned;
  final List<dynamic>? studentsAssigned;
  final String? dueDate;
  final String? la_subject_id;
  final int? submittedCount;
  final int? totalAssignedStudents;

  TeacherVisionVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.subject,
    this.subjectInfo,
    required this.la_subject_id,
    required this.level,
    this.levelInfo,
    required this.teacherAssigned,
    this.studentsAssigned,
    this.dueDate,
    this.submittedCount,
    this.totalAssignedStudents,
  });

  // Getter for clean subject display
  String get subjectDisplay => subjectInfo?.displayName ?? subject;
  
  // Getter for clean level display  
  String get levelDisplay => levelInfo?.displayName ?? level;

  static String? getVideoIdFromUrl(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  static String getThumbnailUrl(String videoId, {bool highQuality = false}) {
    if (videoId.isEmpty) {
      return 'https://via.placeholder.com/320x180?text=No+Video+ID';
    }
    String quality = highQuality ? 'hqdefault' : 'mqdefault';
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }

  factory TeacherVisionVideo.fromJson(Map<String, dynamic> json) {
    // Debug print to see what we're receiving
    print('Parsing TeacherVisionVideo JSON: $json');
    
    String videoId = '';
    String thumbnail = '';

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

    // Parse subject - handle both object and string cases
    String subjectString = '';
    SubjectInfo? subjectInfo;
    
    if (json['subject'] != null) {
      if (json['subject'] is Map<String, dynamic>) {
        try {
          subjectInfo = SubjectInfo.fromJson(json['subject'] as Map<String, dynamic>);
          subjectString = subjectInfo.title; // Use the clean title as the subject string
        } catch (e) {
          print('Error parsing subject object: $e');
          subjectString = json['subject'].toString();
        }
      } else {
        // If it's just a string, use it directly
        subjectString = json['subject'].toString();
      }
    }

    // Parse level - handle both object and string cases
    String levelString = '';
    LevelInfo? levelInfo;
    
    if (json['level'] != null) {
      if (json['level'] is Map<String, dynamic>) {
        try {
          levelInfo = LevelInfo.fromJson(json['level'] as Map<String, dynamic>);
          levelString = levelInfo.title; // Use the clean title as the level string
        } catch (e) {
          print('Error parsing level object: $e');
          levelString = json['level'].toString();
        }
      } else {
        // If it's just a string, use it directly
        levelString = json['level'].toString();
      }
    }

    return TeacherVisionVideo(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Video',
      description: json['description']?.toString() ?? '',
      youtubeUrl: json['youtubeUrl']?.toString() ?? '',
      thumbnailUrl: thumbnail,
      subject: subjectString,
      subjectInfo: subjectInfo,
      la_subject_id: json['la_subject_id']?.toString() ?? '',
      level: levelString,
      levelInfo: levelInfo,
      teacherAssigned: json['teacherAssigned'] ?? false,
      studentsAssigned: json['studentsAssigned'],
      dueDate: json['dueDate']?.toString(),
      submittedCount: json['submittedCount'] as int?,
      totalAssignedStudents: json['totalAssignedStudents'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeUrl': youtubeUrl,
      'thumbnailUrl': thumbnailUrl,
      'subject': subjectInfo?.toJson() ?? subject, // Return detailed info if available, otherwise string
      'la_subject_id': la_subject_id,
      'level': levelInfo?.toJson() ?? level, // Return detailed info if available, otherwise string
      'teacherAssigned': teacherAssigned,
      'studentsAssigned': studentsAssigned,
      'dueDate': dueDate,
      'submittedCount': submittedCount,
      'totalAssignedStudents': totalAssignedStudents,
    };
  }

  TeacherVisionVideo copyWith({
    String? id,
    String? title,
    String? description,
    String? youtubeUrl,
    String? thumbnailUrl,
    String? subject,
    SubjectInfo? subjectInfo,
    String? la_subject_id,
    String? level,
    LevelInfo? levelInfo,
    bool? teacherAssigned,
    List<dynamic>? studentsAssigned,
    String? dueDate,
    int? submittedCount,
    int? totalAssignedStudents,
  }) {
    return TeacherVisionVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      subject: subject ?? this.subject,
      subjectInfo: subjectInfo ?? this.subjectInfo,
      la_subject_id: la_subject_id ?? this.la_subject_id,
      level: level ?? this.level,
      levelInfo: levelInfo ?? this.levelInfo,
      teacherAssigned: teacherAssigned ?? this.teacherAssigned,
      studentsAssigned: studentsAssigned ?? this.studentsAssigned,
      dueDate: dueDate ?? this.dueDate,
      submittedCount: submittedCount ?? this.submittedCount,
      totalAssignedStudents: totalAssignedStudents ?? this.totalAssignedStudents,
    );
  }
}