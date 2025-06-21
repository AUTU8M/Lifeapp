// To parse this JSON data, do
//
//     final conceptCartoonHeaderModel = conceptCartoonHeaderModelFromJson(jsonString);

import 'dart:convert';

ConceptCartoonHeaderModel conceptCartoonHeaderModelFromJson(String str) => ConceptCartoonHeaderModel.fromJson(json.decode(str));

String conceptCartoonHeaderModelToJson(ConceptCartoonHeaderModel data) => json.encode(data.toJson());

class ConceptCartoonHeaderModel {
  int? status;
  Data? data;
  String? message;

  ConceptCartoonHeaderModel({
    this.status,
    this.data,
    this.message,
  });

  factory ConceptCartoonHeaderModel.fromJson(Map<String, dynamic> json) => ConceptCartoonHeaderModel(
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
  int? id;
  String? heading;
  String? description;
  String? buttonOneText;
  String? buttonOneLink;
  String? buttonTwoText;
  String? buttonTwoLink;
  Document? document;

  Data({
    this.id,
    this.heading,
    this.description,
    this.buttonOneText,
    this.buttonOneLink,
    this.buttonTwoText,
    this.buttonTwoLink,
    this.document,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    heading: json["heading"],
    description: json["description"],
    buttonOneText: json["button_one_text"],
    buttonOneLink: json["button_one_link"],
    buttonTwoText: json["button_two_text"],
    buttonTwoLink: json["button_two_link"],
    document: json["document"] == null ? null : Document.fromJson(json["document"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "description": description,
    "button_one_text": buttonOneText,
    "button_one_link": buttonOneLink,
    "button_two_text": buttonTwoText,
    "button_two_link": buttonTwoLink,
    "document": document?.toJson(),
  };
}

class Document {
  int? id;
  String? name;
  String? url;

  Document({
    this.id,
    this.name,
    this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
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
