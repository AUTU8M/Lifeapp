// To parse this JSON data, do
//
//     final addQuizModel = addQuizModelFromJson(jsonString);

import 'dart:convert';

AddQuizModel addQuizModelFromJson(String str) => AddQuizModel.fromJson(json.decode(str));

String addQuizModelToJson(AddQuizModel data) => json.encode(data.toJson());

class AddQuizModel {
  int? status;
  Data? data;
  String? message;

  AddQuizModel({
    this.status,
    this.data,
    this.message,
  });

  factory AddQuizModel.fromJson(Map<String, dynamic> json) => AddQuizModel(
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
  int? time;
  dynamic gameCode;
  Subject? subject;
  Level? level;
  Topic? topic;
  List<Participant>? participants;
  int? coins;
  DateTime? createdAt;
  dynamic status;

  Data({
    this.id,
    this.time,
    this.gameCode,
    this.subject,
    this.level,
    this.topic,
    this.participants,
    this.coins,
    this.createdAt,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    time: json["time"],
    gameCode: json["game_code"],
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    level: json["level"] == null ? null : Level.fromJson(json["level"]),
    topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
    participants: json["participants"] == null ? [] : List<Participant>.from(json["participants"]!.map((x) => Participant.fromJson(x))),
    coins: json["coins"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "game_code": gameCode,
    "subject": subject?.toJson(),
    "level": level?.toJson(),
    "topic": topic?.toJson(),
    "participants": participants == null ? [] : List<dynamic>.from(participants!.map((x) => x.toJson())),
    "coins": coins,
    "created_at": createdAt?.toIso8601String(),
    "status": status,
  };
}

class Level {
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

  Level({
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
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
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
  };
}

class Participant {
  int? id;
  int? status;
  User? user;
  DateTime? createdAt;

  Participant({
    this.id,
    this.status,
    this.user,
    this.createdAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    id: json["id"],
    status: json["status"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "user": user?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class User {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  String? username;
  dynamic school;
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
    school: json["school"],
    state: json["state"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "username": username,
    "school": school,
    "state": state,
    "profile_image": profileImage,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  ImageData? image;
  bool? isCouponAvailable;
  bool? couponCodeUnlock;

  Subject({
    this.id,
    this.title,
    this.heading,
    this.image,
    this.isCouponAvailable,
    this.couponCodeUnlock,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json["id"],
    title: json["title"],
    heading: json["heading"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
    isCouponAvailable: json["is_coupon_available"],
    couponCodeUnlock: json["coupon_code_unlock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "heading": heading,
    "image": image?.toJson(),
    "is_coupon_available": isCouponAvailable,
    "coupon_code_unlock": couponCodeUnlock,
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

class Topic {
  int? id;
  String? title;
  dynamic image;

  Topic({
    this.id,
    this.title,
    this.image,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
  };
}
