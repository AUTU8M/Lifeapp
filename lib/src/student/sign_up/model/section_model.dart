// To parse this JSON data, do
//
//     final sectionModel = sectionModelFromJson(jsonString);

import 'dart:convert';

SectionModel sectionModelFromJson(String str) => SectionModel.fromJson(json.decode(str));

String sectionModelToJson(SectionModel data) => json.encode(data.toJson());

class SectionModel {
  int? status;
  Data? data;
  String? message;

  SectionModel({
    this.status,
    this.data,
    this.message,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
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
  List<LaSection>? laSections;

  Data({
    this.laSections,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laSections: json["laSections"] == null ? [] : List<LaSection>.from(json["laSections"]!.map((x) => LaSection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laSections": laSections == null ? [] : List<dynamic>.from(laSections!.map((x) => x.toJson())),
  };
}

class LaSection {
  int? id;
  String? name;

  LaSection({
    this.id,
    this.name,
  });

  factory LaSection.fromJson(Map<String, dynamic> json) => LaSection(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
