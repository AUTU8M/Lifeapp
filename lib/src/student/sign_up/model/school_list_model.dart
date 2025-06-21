// To parse this JSON data, do
//
//     final schoolListModel = schoolListModelFromJson(jsonString);

import 'dart:convert';

SchoolListModel schoolListModelFromJson(String str) => SchoolListModel.fromJson(json.decode(str));

String schoolListModelToJson(SchoolListModel data) => json.encode(data.toJson());

class SchoolListModel {
  int? status;
  Data? data;
  String? message;

  SchoolListModel({
    this.status,
    this.data,
    this.message,
  });

  factory SchoolListModel.fromJson(Map<String, dynamic> json) => SchoolListModel(
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
  List<School>? school;

  Data({
    this.school,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    school: json["school"] == null ? [] : List<School>.from(json["school"]!.map((x) => School.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "school": school == null ? [] : List<dynamic>.from(school!.map((x) => x.toJson())),
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
