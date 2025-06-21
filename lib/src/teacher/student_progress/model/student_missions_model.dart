// To parse this JSON data, do
//
//     final teacherMissonParticipantModel = teacherMissonParticipantModelFromJson(jsonString);

import 'dart:convert';

StudentMissionsModel teacherMissionParticipantModelFromJson(String str) => StudentMissionsModel.fromJson(json.decode(str));

String studentMissionsModelToJson(StudentMissionsModel data) => json.encode(data.toJson());

class StudentMissionsModel {
  int? status;
  List<Datum>? data;
  String? message;

  StudentMissionsModel({
    this.status,
    this.data,
    this.message,
  });

  factory StudentMissionsModel.fromJson(Map<String, dynamic> json) => StudentMissionsModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  dynamic title;
  String? description;
  dynamic comments;
  dynamic approvedAt;
  dynamic rejectedAt;

  Datum({
    this.id,
    this.title,
    this.description,
    this.comments,
    this.approvedAt,
    this.rejectedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["mission_title"],
    description: json["description"],
    comments: json["comments"],
    approvedAt: json["approved_at"],
    rejectedAt: json["rejected_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mission_title": title,
    "description": description,
    "comments": comments,
    "approved_at": approvedAt,
    "rejected_at": rejectedAt,
  };
}


