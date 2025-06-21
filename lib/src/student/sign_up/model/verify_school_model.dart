// To parse this JSON data, do
//
//     final verifySchoolModel = verifySchoolModelFromJson(jsonString);

import 'dart:convert';

VerifySchoolModel verifySchoolModelFromJson(String str) => VerifySchoolModel.fromJson(json.decode(str));

String verifySchoolModelToJson(VerifySchoolModel data) => json.encode(data.toJson());

class VerifySchoolModel {
  int? status;
  Data? data;
  String? message;

  VerifySchoolModel({
    this.status,
    this.data,
    this.message,
  });

  factory VerifySchoolModel.fromJson(Map<String, dynamic> json) => VerifySchoolModel(
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
  School? school;

  Data({
    this.school,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    school: json["school"] == null ? null : School.fromJson(json["school"]),
  );

  Map<String, dynamic> toJson() => {
    "school": school?.toJson(),
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
