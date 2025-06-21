// To parse this JSON data, do
//
//     final riddleQuizModel = riddleQuizModelFromJson(jsonString);

import 'dart:convert';

QuestionModel riddleQuizModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String riddleQuizModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  int? status;
  Data? data;
  String? message;

  QuestionModel({
    this.status,
    this.data,
    this.message,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
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
  List<QuestionsData>? data;
  Links? links;
  Meta? meta;

  Data({
    this.data,
    this.links,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? [] : List<QuestionsData>.from(json["data"]!.map((x) => QuestionsData.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class QuestionsData {
  int? id;
  Subject? subject;
  Level? level;
  Topic? topic;
  dynamic title;
  List<Questions>? questions;
  Answer? answer;
  int? questionType;
  int? type;

  QuestionsData({
    this.id,
    this.subject,
    this.level,
    this.topic,
    this.title,
    this.questions,
    this.answer,
    this.questionType,
    this.type,
  });

  factory QuestionsData.fromJson(Map<String, dynamic> json) => QuestionsData(
    id: json["id"],
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    level: json["level"] == null ? null : Level.fromJson(json["level"]),
    topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
    title: json["title"],
    questions: json["questions"] == null ? [] : List<Questions>.from(json["questions"]!.map((x) => Questions.fromJson(x))),
    answer: json["answer"] == null ? null : Answer.fromJson(json["answer"]),
    questionType: json["question_type"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject?.toJson(),
    "level": level?.toJson(),
    "topic": topic?.toJson(),
    "title": title,
    "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
    "answer": answer?.toJson(),
    "question_type": questionType,
    "type": type,
  };
}

class Questions {
  int? id;
  String? title;

  Questions({
    this.id,
    this.title,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}


class Answer {
  int? id;
  String? title;

  Answer({
    this.id,
    this.title,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Level {
  int? id;
  String? title;
  String? description;
  int? missionPoints;
  int? quizPoints;
  int? riddlePoints;
  int? puzzlePoints;
  int? jigyasaPoints;
  int? pragyaPoints;
  int? quizTime;
  int? riddleTime;
  int? puzzleTime;

  Level({
    this.id,
    this.title,
    this.description,
    this.missionPoints,
    this.quizPoints,
    this.riddlePoints,
    this.puzzlePoints,
    this.jigyasaPoints,
    this.pragyaPoints,
    this.quizTime,
    this.riddleTime,
    this.puzzleTime,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    missionPoints: json["mission_points"],
    quizPoints: json["quiz_points"],
    riddlePoints: json["riddle_points"],
    puzzlePoints: json["puzzle_points"],
    jigyasaPoints: json["jigyasa_points"],
    pragyaPoints: json["pragya_points"],
    quizTime: json["quiz_time"],
    riddleTime: json["riddle_time"],
    puzzleTime: json["puzzle_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "mission_points": missionPoints,
    "quiz_points": quizPoints,
    "riddle_points": riddlePoints,
    "puzzle_points": puzzlePoints,
    "jigyasa_points": jigyasaPoints,
    "pragya_points": pragyaPoints,
    "quiz_time": quizTime,
    "riddle_time": riddleTime,
    "puzzle_time": puzzleTime,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  QImage? image;
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
    image: json["image"] == null ? null : QImage.fromJson(json["image"]),
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


class QImage {
  int? id;
  String? name;
  String? url;

  QImage({
    this.id,
    this.name,
    this.url,
  });

  factory QImage.fromJson(Map<String, dynamic> json) => QImage(
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


class Topic {
  int? id;
  String? title;
  dynamic image;

  Topic({
    this.id,
    this.title,
    this.image,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
  };
}


class Links {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
