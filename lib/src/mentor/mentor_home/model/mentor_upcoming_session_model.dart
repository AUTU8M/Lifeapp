// To parse this JSON data, do
//
//     final mentorUpcomingSessionModel = mentorUpcomingSessionModelFromJson(jsonString);

import 'dart:convert';

MentorUpcomingSessionModel mentorUpcomingSessionModelFromJson(String str) => MentorUpcomingSessionModel.fromJson(json.decode(str));

String mentorUpcomingSessionModelToJson(MentorUpcomingSessionModel data) => json.encode(data.toJson());

class MentorUpcomingSessionModel {
  int? status;
  Data? data;
  String? message;

  MentorUpcomingSessionModel({
    this.status,
    this.data,
    this.message,
  });

  factory MentorUpcomingSessionModel.fromJson(Map<String, dynamic> json) => MentorUpcomingSessionModel(
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
  Sessions? sessions;

  Data({
    this.sessions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessions: json["sessions"] == null ? null : Sessions.fromJson(json["sessions"]),
  );

  Map<String, dynamic> toJson() => {
    "sessions": sessions?.toJson(),
  };
}

class Sessions {
  List<Datum>? data;
  Links? links;
  Meta? meta;

  Sessions({
    this.data,
    this.links,
    this.meta,
  });

  factory Sessions.fromJson(Map<String, dynamic> json) => Sessions(
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
  String? heading;
  String? description;
  User? user;
  String? zoomLink;
  String? zoomPassword;
  DateTime? date;
  String? time;
  String? isBooked;

  Datum({
    this.id,
    this.heading,
    this.description,
    this.user,
    this.zoomLink,
    this.zoomPassword,
    this.date,
    this.time,
    this.isBooked,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    heading: json["heading"],
    description: json["description"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    zoomLink: json["zoom_link"],
    zoomPassword: json["zoom_password"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    isBooked: json["is_booked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "description": description,
    "user": user?.toJson(),
    "zoom_link": zoomLink,
    "zoom_password": zoomPassword,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "is_booked": isBooked,
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
  dynamic profileImage;

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
  int? isLifeLab;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
    this.isLifeLab,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    city: json["city"],
    isLifeLab: json["is_life_lab"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "city": city,
    "is_life_lab": isLifeLab,
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
