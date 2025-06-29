import 'package:flutter/foundation.dart'; // for debugPrint

class NotificationModel {
  final int? status;
  final List<NotificationData>? data;
  final String? message;

  NotificationModel({
    this.status,
    this.data,
    this.message,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as List?)
            ?.map((dynamic e) {
          debugPrint('NotificationModel.fromJson: notification raw data: $e');
          return NotificationData.fromJson(e as Map<String, dynamic>);
        })
            .toList(),
        message = json['message'] as String? {
    debugPrint('NotificationModel.fromJson: status=$status, message=$message');
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.map((e) => e.toJson()).toList(),
    'message': message,
  };
}

class NotificationData {
  final String? id;
  final String? type;
  final String? notifiableType;
  final int? notifiableId;
  final NotificationInner1Data? data;
  final dynamic readAt;
  final String? createdAt;
  final String? updatedAt;
  final String? subjectId;

  NotificationData({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
    this.subjectId,
  });

  NotificationData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        type = json['type'] as String?,
        notifiableType = json['notifiable_type'] as String?,
        notifiableId = json['notifiable_id'] as int?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? NotificationInner1Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        readAt = json['read_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        subjectId = (json['data'] != null
            ? NotificationInner1Data.fromJson(json['data'] as Map<String, dynamic>)
            : null)
            ?.data
            ?.laSubjectId
            ?.toString() {
    debugPrint('NotificationData.fromJson: id=$id, type=$type, subjectId=$subjectId');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'notifiable_type': notifiableType,
    'notifiable_id': notifiableId,
    'data': data?.toJson(),
    'read_at': readAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'subject_id': subjectId,
  };
}

class NotificationInner1Data {
  final String? title;
  final String? message;
  final ActionData? data;

  NotificationInner1Data({
    this.title,
    this.message,
    this.data,
  });

  NotificationInner1Data.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? ActionData.fromJson(json['data'] as Map<String, dynamic>)
            : null {
    debugPrint('NotificationInner1Data.fromJson: title=$title, message=$message');
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'data': data?.toJson(),
  };
}

class ActionData {
  final int? action;
  final dynamic actionId;
  final dynamic mediaUrl;
  final dynamic laSubjectId;
  final dynamic laLevelId;
  final dynamic missionId;
  final dynamic visionId;
  final int? time;
  final String? visionTitle;

  ActionData({
    this.action,
    this.actionId,
    this.mediaUrl,
    this.laSubjectId,
    this.laLevelId,
    this.missionId,
    this.visionId,
    this.time,
    this.visionTitle,
  });

  ActionData.fromJson(Map<String, dynamic> json)
      : action = json['action'] as int?,
        actionId = json['action_id'],
        mediaUrl = json['media_url'],
        laSubjectId = json['la_subject_id'],
        laLevelId = json['la_level_id'],
        missionId = json['mission_id'],
        visionId = json['vision_id'],
        time = json["quiz_time"],
        visionTitle = json["vision_title"] as String? {
    debugPrint('ActionData.fromJson: action=$action, laSubjectId=$laSubjectId, visionId=$visionId, visionTitle=$visionTitle');
  }

  Map<String, dynamic> toJson() => {
    'action': action,
    'action_id': actionId,
    'media_url': mediaUrl,
    'la_subject_id': laSubjectId,
    'la_level_id': laLevelId,
    'mission_id': missionId,
    'vision_id': visionId,
    'quiz_time': time,
    'vision_title': visionTitle,
  };
}
