// To parse this JSON data, do
//
//     final registerStudentModel = registerStudentModelFromJson(jsonString);

import 'dart:convert';

RegisterStudentModel registerStudentModelFromJson(String str) => RegisterStudentModel.fromJson(json.decode(str));

String registerStudentModelToJson(RegisterStudentModel data) => json.encode(data.toJson());

class RegisterStudentModel {
  int? status;
  Data? data;
  String? message;

  RegisterStudentModel({
    this.status,
    this.data,
    this.message,
  });

  factory RegisterStudentModel.fromJson(Map<String, dynamic> json) => RegisterStudentModel(
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
  User? user;

  Data({
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  dynamic studentId;
  School? school;
  String? name;
  dynamic username;
  String? mobileNo;
  dynamic dob;
  dynamic gender;
  dynamic grade;
  String? city;
  String? state;
  dynamic address;
  dynamic imagePath;
  dynamic profileImage;
  int? missionCompletes;
  int? quiz;
  int? friends;
  dynamic earnCoins;
  dynamic subjects;
  String? token;
  int? userRank;
  dynamic lastMission;
  List<dynamic>? missions;

  User({
    this.id,
    this.studentId,
    this.school,
    this.name,
    this.username,
    this.mobileNo,
    this.dob,
    this.gender,
    this.grade,
    this.city,
    this.state,
    this.address,
    this.imagePath,
    this.profileImage,
    this.missionCompletes,
    this.quiz,
    this.friends,
    this.earnCoins,
    this.subjects,
    this.token,
    this.userRank,
    this.lastMission,
    this.missions,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    studentId: json["student_id"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    name: json["name"],
    username: json["username"],
    mobileNo: json["mobile_no"],
    dob: json["dob"],
    gender: json["gender"],
    grade: json["grade"],
    city: json["city"],
    state: json["state"],
    address: json["address"],
    imagePath: json["image_path"],
    profileImage: json["profile_image"],
    missionCompletes: json["mission_completes"],
    quiz: json["quiz"],
    friends: json["friends"],
    earnCoins: json["earn_coins"],
    subjects: json["subjects"],
    token: json["token"],
    userRank: json["user_rank"],
    lastMission: json["last_mission"],
    missions: json["missions"] == null ? [] : List<dynamic>.from(json["missions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "school": school?.toJson(),
    "name": name,
    "username": username,
    "mobile_no": mobileNo,
    "dob": dob,
    "gender": gender,
    "grade": grade,
    "city": city,
    "state": state,
    "address": address,
    "image_path": imagePath,
    "profile_image": profileImage,
    "mission_completes": missionCompletes,
    "quiz": quiz,
    "friends": friends,
    "earn_coins": earnCoins,
    "subjects": subjects,
    "token": token,
    "user_rank": userRank,
    "last_mission": lastMission,
    "missions": missions == null ? [] : List<dynamic>.from(missions!.map((x) => x)),
  };
}

class School {
  int? id;
  String? name;
  String? state;
  String? city;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "city": city,
  };
}
