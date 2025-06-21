// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  int? status;
  Data? data;
  String? message;

  LanguageModel({
    this.status,
    this.data,
    this.message,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
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
  List<LaLessionPlanLanguage>? laLessionPlanLanguages;

  Data({
    this.laLessionPlanLanguages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laLessionPlanLanguages: json["laLessionPlanLanguages"] == null ? [] : List<LaLessionPlanLanguage>.from(json["laLessionPlanLanguages"]!.map((x) => LaLessionPlanLanguage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "laLessionPlanLanguages": laLessionPlanLanguages == null ? [] : List<dynamic>.from(laLessionPlanLanguages!.map((x) => x.toJson())),
  };
}

class LaLessionPlanLanguage {
  int? id;
  String? name;

  LaLessionPlanLanguage({
    this.id,
    this.name,
  });

  factory LaLessionPlanLanguage.fromJson(Map<String, dynamic> json) => LaLessionPlanLanguage(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
