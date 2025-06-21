// To parse this JSON data, do
//
//     final searchFriendModel = searchFriendModelFromJson(jsonString);

import 'dart:convert';

SearchFriendModel searchFriendModelFromJson(String str) => SearchFriendModel.fromJson(json.decode(str));

String searchFriendModelToJson(SearchFriendModel data) => json.encode(data.toJson());

class SearchFriendModel {
  int? status;
  List<Datum>? data;
  String? message;

  SearchFriendModel({
    this.status,
    this.data,
    this.message,
  });

  factory SearchFriendModel.fromJson(Map<String, dynamic> json) => SearchFriendModel(
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
  FriendRequest? friendRequest;

  Datum({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
    this.friendRequest,
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
    friendRequest: json["friend_request"] == null ? null : FriendRequest.fromJson(json["friend_request"]),
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
    "friend_request": friendRequest?.toJson(),
  };
}

class FriendRequest {
  int? id;
  int? senderId;
  int? recipientId;
  String? status;
  DateTime? createdAt;

  FriendRequest({
    this.id,
    this.senderId,
    this.recipientId,
    this.status,
    this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
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
