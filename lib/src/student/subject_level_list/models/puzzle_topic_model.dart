// To parse this JSON data, do
//
//     final riddleTopicModel = riddleTopicModelFromJson(jsonString);

import 'dart:convert';

PuzzleTopicModel riddleTopicModelFromJson(String str) => PuzzleTopicModel.fromJson(json.decode(str));

String riddleTopicModelToJson(PuzzleTopicModel data) => json.encode(data.toJson());

class PuzzleTopicModel {
  int? status;
  Data? data;
  String? message;

  PuzzleTopicModel({
    this.status,
    this.data,
    this.message,
  });

  factory PuzzleTopicModel.fromJson(Map<String, dynamic> json) => PuzzleTopicModel(
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
  List<LaTopic>? laTopics;

  Data({
    this.laTopics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laTopics: json["laTopics"] == null ? [] : List<LaTopic>.from(json["laTopics"]!.map((x) => LaTopic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laTopics": laTopics == null ? [] : List<dynamic>.from(laTopics!.map((x) => x.toJson())),
  };
}

class LaTopic {
  int? id;
  String? title;
  ImageData? image;

  LaTopic({
    this.id,
    this.title,
    this.image,
  });

  factory LaTopic.fromJson(Map<String, dynamic> json) => LaTopic(
    id: json["id"],
    title: json["title"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image?.toJson(),
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


