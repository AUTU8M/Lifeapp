// To parse this JSON data, do
//
//     final trackerModel = trackerModelFromJson(jsonString);

import 'dart:convert';

TrackerModel trackerModelFromJson(String str) => TrackerModel.fromJson(json.decode(str));

String trackerModelToJson(TrackerModel data) => json.encode(data.toJson());

class TrackerModel {
  int? status;
  Data? data;
  String? message;

  TrackerModel({
    this.status,
    this.data,
    this.message,
  });

  factory TrackerModel.fromJson(Map<String, dynamic> json) => TrackerModel(
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
  Map<String, English> subjects;

  Data({required this.subjects});

  factory Data.fromJson(Map<String, dynamic> json) {
    final map = <String, English>{};
    json.forEach((key, value) {
      map[key] = English.fromJson(value);
    });
    return Data(subjects: map);
  }

  Map<String, dynamic> toJson() => {
    for (var entry in subjects.entries) entry.key: entry.value.toJson(),
  };
}


class English {
  Map<String, Jigyasa> topics;

  English({required this.topics});

  factory English.fromJson(Map<String, dynamic> json) {
    final map = <String, Jigyasa>{};
    json.forEach((key, value) {
      map[key] = Jigyasa.fromJson(value);
    });
    return English(topics: map);
  }

  Map<String, dynamic> toJson() => {
    for (var entry in topics.entries) entry.key: entry.value.toJson(),
  };
}


class Jigyasa {
  int? pending;
  int? complete;

  Jigyasa({
    this.pending,
    this.complete,
  });

  factory Jigyasa.fromJson(Map<String, dynamic> json) => Jigyasa(
    pending: json["pending"],
    complete: json["complete"],
  );

  Map<String, dynamic> toJson() => {
    "pending": pending,
    "complete": complete,
  };
}
