// To parse this JSON data, do
//
//     final lessonPlanModel = lessonPlanModelFromJson(jsonString);

import 'dart:convert';

LessonPlanModel lessonPlanModelFromJson(String str) => LessonPlanModel.fromJson(json.decode(str));

String lessonPlanModelToJson(LessonPlanModel data) => json.encode(data.toJson());

class LessonPlanModel {
  int? status;
  Data? data;
  String? message;

  LessonPlanModel({
    this.status,
    this.data,
    this.message,
  });

  factory LessonPlanModel.fromJson(Map<String, dynamic> json) => LessonPlanModel(
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
  List<LaLessionPlan>? laLessionPlans;

  Data({
    this.laLessionPlans,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laLessionPlans: json["laLessionPlans"] == null ? [] : List<LaLessionPlan>.from(json["laLessionPlans"]!.map((x) => LaLessionPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laLessionPlans": laLessionPlans == null ? [] : List<dynamic>.from(laLessionPlans!.map((x) => x.toJson())),
  };
}

class LaLessionPlan {
  int? id;
  Board? language;
  // Board? board;
  String? title;
  Document? document;

  LaLessionPlan({
    this.id,
    this.language,
    // this.board,
    this.title,
    this.document,
  });

  factory LaLessionPlan.fromJson(Map<String, dynamic> json) => LaLessionPlan(
    id: json["id"],
    language: json["language"] == null ? null : Board.fromJson(json["language"]),
    // board: json["board"] == null && json['board'] is List ? null : Board.fromJson(json["board"]),
    title: json["title"],
    document: json["document"] == null ? null : Document.fromJson(json["document"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language": language?.toJson(),
    // "board": board?.toJson(),
    "title": title,
    "document": document?.toJson(),
  };
}

class Board {
  int? id;
  String? name;

  Board({
    this.id,
    this.name,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Document {
  int? id;
  String? name;
  String? url;

  Document({
    this.id,
    this.name,
    this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
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
