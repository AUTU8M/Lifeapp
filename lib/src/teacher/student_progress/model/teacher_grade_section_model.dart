// To parse this JSON data, do
//
//     final teacherGradeSectionModel = teacherGradeSectionModelFromJson(jsonString);

import 'dart:convert';

TeacherGradeSectionModel teacherGradeSectionModelFromJson(String str) => TeacherGradeSectionModel.fromJson(json.decode(str));

String teacherGradeSectionModelToJson(TeacherGradeSectionModel data) => json.encode(data.toJson());

class TeacherGradeSectionModel {
  int? status;
  Data? data;
  String? message;

  TeacherGradeSectionModel({
    this.status,
    this.data,
    this.message,
  });

  factory TeacherGradeSectionModel.fromJson(Map<String, dynamic> json) => TeacherGradeSectionModel(
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
  List<TeacherGrade>? teacherGrades;

  Data({
    this.teacherGrades,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherGrades: json["teacherGrades"] == null ? [] : List<TeacherGrade>.from(json["teacherGrades"]!.map((x) => TeacherGrade.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "teacherGrades": teacherGrades == null ? [] : List<dynamic>.from(teacherGrades!.map((x) => x.toJson())),
  };
}

class TeacherGrade {
  int? id;
  Grade? grade;
  Subject? subject;
  Grade? section;

  TeacherGrade({
    this.id,
    this.grade,
    this.subject,
    this.section,
  });

  factory TeacherGrade.fromJson(Map<String, dynamic> json) => TeacherGrade(
    id: json["id"],
    grade: json["grade"] == null ? null : Grade.fromJson(json["grade"]),
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    section: json["section"] == null ? null : Grade.fromJson(json["section"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "grade": grade?.toJson(),
    "subject": subject?.toJson(),
    "section": section?.toJson(),
  };
}

class Grade {
  int? id;
  String? name;

  Grade({
    this.id,
    this.name,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  Image? image;
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
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
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

class Image {
  int? id;
  String? name;
  String? url;

  Image({
    this.id,
    this.name,
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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
