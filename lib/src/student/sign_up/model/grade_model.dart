// To parse this JSON data, do
//
//     final gradeModel = gradeModelFromJson(jsonString);

import 'dart:convert';

GradeModel gradeModelFromJson(String str) => GradeModel.fromJson(json.decode(str));

String gradeModelToJson(GradeModel data) => json.encode(data.toJson());

class GradeModel {
  int? status;
  Data? data;
  String? message;

  GradeModel({
    this.status,
    this.data,
    this.message,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
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
  List<LaGrade>? laGrades;

  Data({
    this.laGrades,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laGrades: json["laGrades"] == null ? [] : List<LaGrade>.from(json["laGrades"]!.map((x) => LaGrade.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laGrades": laGrades == null ? [] : List<dynamic>.from(laGrades!.map((x) => x.toJson())),
  };
}

class LaGrade {
  int? id;
  String? name;

  LaGrade({
    this.id,
    this.name,
  });

  factory LaGrade.fromJson(Map<String, dynamic> json) => LaGrade(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
