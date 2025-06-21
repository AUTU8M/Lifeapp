// To parse this JSON data, do
//
//     final teacherMissonParticipantModel = teacherMissonParticipantModelFromJson(jsonString);

import 'dart:convert';

TeacherMissionParticipantModel teacherMissionParticipantModelFromJson(String str) => TeacherMissionParticipantModel.fromJson(json.decode(str));

String teacherMissionParticipantModelToJson(TeacherMissionParticipantModel data) => json.encode(data.toJson());

class TeacherMissionParticipantModel {
  int? status;
  Data? data;
  String? message;

  TeacherMissionParticipantModel({
    this.status,
    this.data,
    this.message,
  });

  factory TeacherMissionParticipantModel.fromJson(Map<String, dynamic> json) => TeacherMissionParticipantModel(
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
  List<Datum>? data;
  Links? links;
  Meta? meta;

  Data({
    this.data,
    this.links,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  User? user;
  Submission? submission;

  Datum(
      {this.id,
        this.user,
        this.submission});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id : json['id'],
    user : json['user'] != null ? User.fromJson(json['user']) : null,
    submission : json['submission'] != null ? Submission.fromJson(json['submission']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'user' : user?.toJson(),
    'submission' : submission?.toJson(),
  };
}
 
class Submission {
  int? id;
  User? user;
  dynamic title;
  Media? media;
  String? description;
  dynamic comments;
  dynamic approvedAt;
  dynamic rejectedAt;
  int? points;
  int? timing;

  Submission({
    this.id,
    this.user,
    this.title,
    this.media,
    this.description,
    this.comments,
    this.approvedAt,
    this.rejectedAt,
    this.points,
    this.timing,
  });

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    title: json["title"],
    media: json["media"] == null ? null : Media.fromJson(json["media"]),
    description: json["description"],
    comments: json["comments"],
    approvedAt: json["approved_at"],
    rejectedAt: json["rejected_at"],
    points: json["points"],
    timing: json["timing"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "title": title,
    "media": media?.toJson(),
    "description": description,
    "comments": comments,
    "approved_at": approvedAt,
    "rejected_at": rejectedAt,
    "points": points,
    "timing": timing,
  };
}

class Media {
  int? id;
  String? name;
  String? url;

  Media({
    this.id,
    this.name,
    this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
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

class User {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  dynamic username;
  School? school;
  String? state;
  String? profileImage;

  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    username: json["username"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    state: json["state"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "username": username,
    "school": school?.toJson(),
    "state": state,
    "profile_image": profileImage,
  };
}

class School {
  int? id;
  String? name;
  String? state;
  String? city;
  int? code;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
    this.code,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    city: json["city"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "city": city,
    "code": code,
  };
}

class Links {
  String? first;
  String? last;
  dynamic prev;
  String? next;

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
