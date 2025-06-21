// To parse this JSON data, do
//
//     final sentFriendRequestModel = sentFriendRequestModelFromJson(jsonString);

import 'dart:convert';

SentFriendRequestModel sentFriendRequestModelFromJson(String str) => SentFriendRequestModel.fromJson(json.decode(str));

String sentFriendRequestModelToJson(SentFriendRequestModel data) => json.encode(data.toJson());

class SentFriendRequestModel {
  int? status;
  List<Datum>? data;
  String? message;

  SentFriendRequestModel({
    this.status,
    this.data,
    this.message,
  });

  factory SentFriendRequestModel.fromJson(Map<String, dynamic> json) => SentFriendRequestModel(
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
  String? name;
  dynamic email;
  String? mobileNo;
  dynamic username;
  School? school;
  String? state;
  dynamic profileImage;
  FiendRequest? fiendRequest;

  Datum({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
    this.fiendRequest,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    username: json["username"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    state: json["state"],
    profileImage: json["profile_image"],
    fiendRequest: json["fiend_request"] == null ? null : FiendRequest.fromJson(json["fiend_request"]),
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
    "fiend_request": fiendRequest?.toJson(),
  };
}

class FiendRequest {
  int? id;
  int? senderId;
  int? recipientId;
  String? status;
  DateTime? createdAt;

  FiendRequest({
    this.id,
    this.senderId,
    this.recipientId,
    this.status,
    this.createdAt,
  });

  factory FiendRequest.fromJson(Map<String, dynamic> json) => FiendRequest(
    id: json["id"],
    senderId: json["sender_id"],
    recipientId: json["recipient_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "recipient_id": recipientId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
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
