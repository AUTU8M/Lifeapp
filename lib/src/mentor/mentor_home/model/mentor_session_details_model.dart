// To parse this JSON data, do
//
//     final mentorSessionDetailsModel = mentorSessionDetailsModelFromJson(jsonString);

import 'dart:convert';

MentorSessionDetailsModel mentorSessionDetailsModelFromJson(String str) => MentorSessionDetailsModel.fromJson(json.decode(str));

String mentorSessionDetailsModelToJson(MentorSessionDetailsModel data) => json.encode(data.toJson());

class MentorSessionDetailsModel {
  int? status;
  SessionDetailsData? data;
  String? message;

  MentorSessionDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory MentorSessionDetailsModel.fromJson(Map<String, dynamic> json) => MentorSessionDetailsModel(
    status: json["status"],
    data: json["data"] == null ? null : SessionDetailsData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class SessionDetailsData {
  int? id;
  String? heading;
  String? description;
  User? user;
  String? zoomLink;
  String? zoomPassword;
  DateTime? date;
  String? time;
  String? isBooked;

  SessionDetailsData({
    this.id,
    this.heading,
    this.description,
    this.user,
    this.zoomLink,
    this.zoomPassword,
    this.date,
    this.time,
    this.isBooked,
  });

  factory SessionDetailsData.fromJson(Map<String, dynamic> json) => SessionDetailsData(
    id: json["id"],
    heading: json["heading"],
    description: json["description"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    zoomLink: json["zoom_link"],
    zoomPassword: json["zoom_password"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    isBooked: json["is_booked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "description": description,
    "user": user?.toJson(),
    "zoom_link": zoomLink,
    "zoom_password": zoomPassword,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "is_booked": isBooked,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobileNo;
  dynamic username;
  dynamic school;
  dynamic state;
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
