// To parse this JSON data, do
//
//     final couponListModel = couponListModelFromJson(jsonString);

import 'dart:convert';

CouponListModel couponListModelFromJson(String str) => CouponListModel.fromJson(json.decode(str));

String couponListModelToJson(CouponListModel data) => json.encode(data.toJson());

class CouponListModel {
  int? status;
  List<Datum>? data;
  String? message;

  CouponListModel({
    this.status,
    this.data,
    this.message,
  });

  factory CouponListModel.fromJson(Map<String, dynamic> json) => CouponListModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? title;
  int? categoryId;
  String? coin;
  dynamic link;
  String? details;
  CouponMediaId? couponMediaId;
  bool? redeemable;
  bool? redeemed;

  Datum({
    this.id,
    this.title,
    this.categoryId,
    this.coin,
    this.link,
    this.details,
    this.couponMediaId,
    this.redeemable,
    this.redeemed,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    categoryId: json["category_id"],
    coin: json["coin"],
    link: json["link"],
    details: json["details"],
    couponMediaId: json["coupon_media_id"] == null ? null : CouponMediaId.fromJson(json["coupon_media_id"]),
    redeemable: json["redeemable"],
    redeemed: json["redeemed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category_id": categoryId,
    "coin": coin,
    "link": link,
    "details": details,
    "coupon_media_id": couponMediaId?.toJson(),
    "redeemable": redeemable,
    "redeemed": redeemed,
  };
}

class CouponMediaId {
  int? id;
  String? name;
  String? url;

  CouponMediaId({
    this.id,
    this.name,
    this.url,
  });

  factory CouponMediaId.fromJson(Map<String, dynamic> json) => CouponMediaId(
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
