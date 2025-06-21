// To parse this JSON data, do
//
//     final stateCityListModel = stateCityListModelFromJson(jsonString);

import 'dart:convert';

List<StateCityListModel> stateCityListModelFromJson(String str) => List<StateCityListModel>.from(json.decode(str).map((x) => StateCityListModel.fromJson(x)));

String stateCityListModelToJson(List<StateCityListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateCityListModel {
  String? stateName;
  int? active;
  List<City>? cities;

  StateCityListModel({
    this.stateName,
    this.active,
    this.cities,
  });

  factory StateCityListModel.fromJson(Map<String, dynamic> json) => StateCityListModel(
    stateName: json["state_name"],
    active: json["active"],
    cities: json["cities"] == null ? [] : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state_name": stateName,
    "active": active,
    "cities": cities == null ? [] : List<dynamic>.from(cities!.map((x) => x.toJson())),
  };
}

class City {
  String? cityName;
  int? active;

  City({
    this.cityName,
    this.active,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    cityName: json["city_name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "city_name": cityName,
    "active": active,
  };
}
