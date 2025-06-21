// To parse this JSON data, do
//
//     final workSheetModel = workSheetModelFromJson(jsonString);

import 'dart:convert';

WorkSheetModel workSheetModelFromJson(String str) => WorkSheetModel.fromJson(json.decode(str));

String workSheetModelToJson(WorkSheetModel data) => json.encode(data.toJson());

class WorkSheetModel {
  int? status;
  Data? data;
  String? message;

  WorkSheetModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkSheetModel.fromJson(Map<String, dynamic> json) => WorkSheetModel(
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
  LaWorkSheets? laWorkSheets;

  Data({
    this.laWorkSheets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    laWorkSheets: json["laWorkSheets"] == null ? null : LaWorkSheets.fromJson(json["laWorkSheets"]),
  );

  Map<String, dynamic> toJson() => {
    "laWorkSheets": laWorkSheets?.toJson(),
  };
}

class LaWorkSheets {
  List<Datum>? data;
  Links? links;
  Meta? meta;

  LaWorkSheets({
    this.data,
    this.links,
    this.meta,
  });

  factory LaWorkSheets.fromJson(Map<String, dynamic> json) => LaWorkSheets(
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
  Grade? grade;
  Subject? subject;
  String? title;
  Document? document;

  Datum({
    this.id,
    this.grade,
    this.subject,
    this.title,
    this.document,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    grade: json["grade"] == null ? null : Grade.fromJson(json["grade"]),
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    title: json["title"],
    document: json["document"] == null ? null : Document.fromJson(json["document"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "grade": grade?.toJson(),
    "subject": subject?.toJson(),
    "title": title,
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
