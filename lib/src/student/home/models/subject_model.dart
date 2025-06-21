// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

SubjectModel subjectModelFromJson(String str) => SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
  int? status;
  Data? data;
  String? message;

  SubjectModel({
    this.status,
    this.data,
    this.message,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
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
  List<Subject>? subject;

  Data({
    this.subject,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    subject: json["subject"] == null ? [] : List<Subject>.from(json["subject"]!.map((x) => Subject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subject": subject == null ? [] : List<dynamic>.from(subject!.map((x) => x.toJson())),
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
