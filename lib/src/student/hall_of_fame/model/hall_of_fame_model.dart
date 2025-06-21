// To parse this JSON data, do
//
//     final hallOfFameModel = hallOfFameModelFromJson(jsonString);

import 'dart:convert';

HallOfFameModel hallOfFameModelFromJson(String str) => HallOfFameModel.fromJson(json.decode(str));

String hallOfFameModelToJson(HallOfFameModel data) => json.encode(data.toJson());

class HallOfFameModel {
  int? status;
  Data? data;
  String? message;

  HallOfFameModel({
    this.status,
    this.data,
    this.message,
  });

  factory HallOfFameModel.fromJson(Map<String, dynamic> json) => HallOfFameModel(
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
  Champion? quizChampion;
  Champion? missionChampion;
  Champion? coinChampion;

  Data({
    this.quizChampion,
    this.missionChampion,
    this.coinChampion,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    quizChampion: json["quiz_champion"] == null ? null : Champion.fromJson(json["quiz_champion"]),
    missionChampion: json["mission_champion"] == null ? null : Champion.fromJson(json["mission_champion"]),
    coinChampion: json["coin_champion"] == null ? null : Champion.fromJson(json["coin_champion"]),
  );

  Map<String, dynamic> toJson() => {
    "quiz_champion": quizChampion,
    "mission_champion": missionChampion,
    "coin_champion": coinChampion,
  };
}

class Champion {
  int? totalCoins;
  User? user;

  Champion({
    this.totalCoins,
    this.user,
  });

  factory Champion.fromJson(Map<String, dynamic> json) => Champion(
    totalCoins: json["total_coins"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "total_coins": totalCoins,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  dynamic username;
  School? school;
  String? state;
  dynamic profileImage;

  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
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
    "state": state,
    "profile_image": profileImage,
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
