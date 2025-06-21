// To parse this JSON data, do
//
//     final levelModel = levelModelFromJson(jsonString);

import 'dart:convert';

LevelModel levelModelFromJson(String str) => LevelModel.fromJson(json.decode(str));

String levelModelToJson(LevelModel data) => json.encode(data.toJson());

class LevelModel {
  int? status;
  Data? data;
  String? message;

  LevelModel({
    this.status,
    this.data,
    this.message,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
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
  List<LaLevel>? laLevels;

  Data({
    this.laLevels,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laLevels: json["laLevels"] == null ? [] : List<LaLevel>.from(json["laLevels"]!.map((x) => LaLevel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laLevels": laLevels == null ? [] : List<dynamic>.from(laLevels!.map((x) => x.toJson())),
  };
}

class LaLevel {
  int? id;
  String? title;
  String? description;
  int? missionPoints;
  int? quizPoints;
  int? riddlePoints;
  int? puzzlePoints;
  int? jigyasaPoints;
  int? pragyaPoints;
  int? quizTime;
  int? riddleTime;
  int? puzzleTime;
  int? unlock;

  LaLevel({
    this.id,
    this.title,
    this.description,
    this.missionPoints,
    this.quizPoints,
    this.riddlePoints,
    this.puzzlePoints,
    this.jigyasaPoints,
    this.pragyaPoints,
    this.quizTime,
    this.riddleTime,
    this.puzzleTime,
    this.unlock,
  });

  factory LaLevel.fromJson(Map<String, dynamic> json) => LaLevel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    missionPoints: json["mission_points"],
    quizPoints: json["quiz_points"],
    riddlePoints: json["riddle_points"],
    puzzlePoints: json["puzzle_points"],
    jigyasaPoints: json["jigyasa_points"],
    pragyaPoints: json["pragya_points"],
    quizTime: json["quiz_time"],
    riddleTime: json["riddle_time"],
    puzzleTime: json["puzzle_time"],
    unlock: json["unlock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "mission_points": missionPoints,
    "quiz_points": quizPoints,
    "riddle_points": riddlePoints,
    "puzzle_points": puzzlePoints,
    "jigyasa_points": jigyasaPoints,
    "pragya_points": pragyaPoints,
    "quiz_time": quizTime,
    "riddle_time": riddleTime,
    "puzzle_time": puzzleTime,
    "unlock": unlock,
  };
}
