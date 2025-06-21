// To parse this JSON data, do
//
//     final myFriendListModel = myFriendListModelFromJson(jsonString);

import 'dart:convert';

MyFriendListModel myFriendListModelFromJson(String str) => MyFriendListModel.fromJson(json.decode(str));

String myFriendListModelToJson(MyFriendListModel data) => json.encode(data.toJson());

class MyFriendListModel {
  int? status;
  Data? data;
  String? message;

  MyFriendListModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyFriendListModel.fromJson(Map<String, dynamic> json) => MyFriendListModel(
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
  int? friendsCount;
  List<Friend>? friends;

  Data({
    this.friendsCount,
    this.friends,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    friendsCount: json["friends_count"],
    friends: json["friends"] == null ? [] : List<Friend>.from(json["friends"]!.map((x) => Friend.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "friends_count": friendsCount,
    "friends": friends == null ? [] : List<dynamic>.from(friends!.map((x) => x.toJson())),
  };
}

class Friend {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  dynamic username;
  School? school;
  String? state;
  dynamic profileImage;

  Friend({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
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
