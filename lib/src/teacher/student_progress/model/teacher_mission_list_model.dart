// To parse this JSON data, do
//
//     final teacherMissonListModel = teacherMissonListModelFromJson(jsonString);

import 'dart:convert';

TeacherMissionListModel teacherMissionListModelFromJson(String str) => TeacherMissionListModel.fromJson(json.decode(str));

String teacherMissionListModelToJson(TeacherMissionListModel data) => json.encode(data.toJson());

class TeacherMissionListModel {
  int? status;
  Data? data;
  String? message;

  TeacherMissionListModel({
    this.status,
    this.data,
    this.message,
  });

  factory TeacherMissionListModel.fromJson(Map<String, dynamic> json) => TeacherMissionListModel(
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
  Missions? missions;

  Data({
    this.missions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    missions: json["missions"] == null ? null : Missions.fromJson(json["missions"]),
  );

  Map<String, dynamic> toJson() => {
    "missions": missions?.toJson(),
  };
}

class Missions {
  List<Datum>? data;
  Links? links;
  Meta? meta;

  Missions({
    this.data,
    this.links,
    this.meta,
  });

  factory Missions.fromJson(Map<String, dynamic> json) => Missions(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Datum {
  int? id;
  Level? level;
  List<dynamic>? topic;
  int? type;
  String? title;
  String? description;
  Document? image;
  Document? document;
  String? question;
  Subject? subject;
  List<Resource>? resources;
  dynamic submission;
  String? assignedBy;

  Datum({
    this.id,
    this.level,
    this.topic,
    this.type,
    this.title,
    this.description,
    this.image,
    this.document,
    this.question,
    this.subject,
    this.resources,
    this.submission,
    this.assignedBy,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    level: json["level"] == null ? null : Level.fromJson(json["level"]),
    topic: json["topic"] == null ? [] : List<dynamic>.from(json["topic"]!.map((x) => x)),
    type: json["type"],
    title: json["title"],
    description: json["description"],
    image: json["image"] == null ? null : Document.fromJson(json["image"]),
    document: json["document"] == null ? null : Document.fromJson(json["document"]),
    question: json["question"],
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    resources: json["resources"] == null ? [] : List<Resource>.from(json["resources"]!.map((x) => Resource.fromJson(x))),
    submission: json["submission"],
    assignedBy: json["assigned_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level": level?.toJson(),
    "topic": topic == null ? [] : List<dynamic>.from(topic!.map((x) => x)),
    "type": type,
    "title": title,
    "description": description,
    "image": image?.toJson(),
    "document": document?.toJson(),
    "question": question,
    "subject": subject?.toJson(),
    "resources": resources == null ? [] : List<dynamic>.from(resources!.map((x) => x.toJson())),
    "submission": submission,
    "assigned_by": assignedBy,
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
  int? unlock;

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
    this.unlock,
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
    unlock: json["unlock"],
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
    "unlock": unlock,
  };
}

class Resource {
  int? id;
  String? title;
  Document? media;
  String? locale;

  Resource({
    this.id,
    this.title,
    this.media,
    this.locale,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"],
    title: json["title"],
    media: json["media"] == null ? null : Document.fromJson(json["media"]),
    locale: json["locale"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "media": media?.toJson(),
    "locale": locale,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  Document? image;
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
    image: json["image"] == null ? null : Document.fromJson(json["image"]),
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
