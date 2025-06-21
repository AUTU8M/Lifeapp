// To parse this JSON data, do
//
//     final allStudentReportModel = allStudentReportModelFromJson(jsonString);

import 'dart:convert';

AllStudentReportModel allStudentReportModelFromJson(String str) => AllStudentReportModel.fromJson(json.decode(str));

String allStudentReportModelToJson(AllStudentReportModel data) => json.encode(data.toJson());

class AllStudentReportModel {
  int? status;
  Data? data;
  String? message;

  AllStudentReportModel({
    this.status,
    this.data,
    this.message,
  });

  factory AllStudentReportModel.fromJson(Map<String, dynamic> json) => AllStudentReportModel(
    status: json["status"],
    data: json["data"] == null || json["data"].toString() == "[]" ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  List<Student>? student;
  int? totalMission;
  int? totalQuiz;
  int? totalPuzzle;
  int? totalCoins;

  Data({
    this.student,
    this.totalMission,
    this.totalQuiz,
    this.totalPuzzle,
    this.totalCoins,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    student: json["student"] == null ? [] : List<Student>.from(json["student"]!.map((x) => Student.fromJson(x))),
    totalMission: json["total_mission"],
    totalQuiz: json["total_quiz"],
    totalPuzzle: json["total_puzzle"],
    totalCoins: json["total_coins"],
  );

  Map<String, dynamic> toJson() => {
    "student": student == null ? [] : List<dynamic>.from(student!.map((x) => x.toJson())),
    "total_mission": totalMission,
    "total_quiz": totalQuiz,
    "total_puzzle": totalPuzzle,
    "total_coins": totalCoins,
  };
}

class Student {
  User? user;
  int? mission;
  int? quiz;
  int? riddle;
  int? puzzle;
  int? coins;
  int? vision;

  Student({
    this.user,
    this.mission,
    this.quiz,
    this.riddle,
    this.puzzle,
    this.coins,
    this.vision,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    mission: json["mission"],
    quiz: json["quiz"],
    riddle: json["riddle"],
    puzzle: json["puzzle"],
    coins: json["coins"],
    vision : json["vision"]
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "mission": mission,
    "quiz": quiz,
    "riddle": riddle,
    "puzzle": puzzle,
    "coins": coins,
    "vision": vision,
  };
}

class User {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  dynamic username;
  School? school;
  Section? section;
  String? state;
  dynamic profileImage;

  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.section,
    this.state,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    username: json["username"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    section: json["section"] == null ? null : Section.fromJson(json["section"]),
    state: json["state"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "username": username,
    "school": school?.toJson(),
    "section": section?.toJson(),
    "state": state,
    "profile_image": profileImage,
  };
}

class School {
  int? id;
  String? name;
  String? state;
  String? city;
  int? code;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
    this.code,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    city: json["city"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "city": city,
    "code": code,
  };
}

class Section {
  String? name;

  Section({
    this.name,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
