// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  int? status;
  Data? data;
  String? message;

  VerifyOtpModel({
    this.status,
    this.data,
    this.message,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
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
  String? type;
  String? token;
  List<dynamic>? subjects;

  Data({
    this.type,
    this.token,
    this.subjects,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    token: json["token"],
    subjects: json["subjects"] == null ? [] : List<dynamic>.from(json["subjects"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "token": token,
    "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x)),
  };
}
