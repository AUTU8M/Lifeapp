// To parse this JSON data, do
//
//     final missionDetailsModel = missionDetailsModelFromJson(jsonString);

import 'dart:convert';

MissionDetailsModel missionDetailsModelFromJson(String str) => MissionDetailsModel.fromJson(json.decode(str));

String missionDetailsModelToJson(MissionDetailsModel data) => json.encode(data.toJson());

class MissionDetailsModel {
  int? status;
  Data? data;
  String? message;

  MissionDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory MissionDetailsModel.fromJson(Map<String, dynamic> json) => MissionDetailsModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  int? id;
  String? title;
  dynamic description;
  Document? image;
  Document? document;
  dynamic question;
  Subject? subject;
  List<Resource>? resources;
  Submission? submission;

  Data({
    this.id,
    this.title,
    this.description,
    this.image,
    this.document,
    this.question,
    this.subject,
    this.resources,
    this.submission,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"] == null ? null : Document.fromJson(json["image"]),
    document: json["document"] == null ? null : Document.fromJson(json["document"]),
    question: json["question"],
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    resources: json["resources"] == null ? [] : List<Resource>.from(json["resources"]!.map((x) => Resource.fromJson(x))),
    submission: json["submission"] == null ? null : Submission.fromJson(json["submission"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image?.toJson(),
    "document": document?.toJson(),
    "question": question,
    "subject": subject?.toJson(),
    "resources": resources == null ? [] : List<dynamic>.from(resources!.map((x) => x.toJson())),
    "submission": submission?.toJson(),
  };
}

class Document {
  En? en;

  Document({
    this.en,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    en: json["en"] == null ? null : En.fromJson(json["en"]),
  );

  Map<String, dynamic> toJson() => {
    "en": en?.toJson(),
  };
}

class En {
  int? id;
  String? name;
  String? url;

  En({
    this.id,
    this.name,
    this.url,
  });

  factory En.fromJson(Map<String, dynamic> json) => En(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}

class Resource {
  int? id;
  String? title;
  En? media;
  String? locale;

  Resource({
    this.id,
    this.title,
    this.media,
    this.locale,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"],
    title: json["title"],
    media: json["media"] == null ? null : En.fromJson(json["media"]),
    locale: json["locale"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "media": media?.toJson(),
    "locale": locale,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  ImageData? image;

  Subject({
    this.id,
    this.title,
    this.heading,
    this.image,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json["id"],
    title: json["title"],
    heading: json["heading"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "heading": heading,
    "image": image?.toJson(),
  };
}

class ImageData {
  int? id;
  String? name;
  String? url;

  ImageData({
    this.id,
    this.name,
    this.url,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}

class Submission {
  int? id;
  int? laMissionId;
  int? userId;
  int? mediaId;
  String? description;
  dynamic comments;
  int? points;
  dynamic approvedAt;
  dynamic rejectedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Media ? media;

  Submission({
    this.id,
    this.laMissionId,
    this.userId,
    this.mediaId,
    this.description,
    this.comments,
    this.points,
    this.approvedAt,
    this.rejectedAt,
    this.createdAt,
    this.updatedAt,
    this.media,
  });

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
    id: json["id"],
    laMissionId: json["la_mission_id"],
    userId: json["user_id"],
    mediaId: json["media_id"],
    description: json["description"],
    comments: json["comments"],
    points: json["points"],
    approvedAt: json["approved_at"],
    rejectedAt: json["rejected_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    media: json["media"] == null ? null : Media.fromJson(json["media"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "la_mission_id": laMissionId,
    "user_id": userId,
    "media_id": mediaId,
    "description": description,
    "comments": comments,
    "points": points,
    "approved_at": approvedAt,
    "rejected_at": rejectedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "media" : media
  };
}

class Media{
  String? url;

  Media({
    this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
