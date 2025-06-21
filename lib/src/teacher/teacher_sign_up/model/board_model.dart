// To parse this JSON data, do
//
//     final boardModel = boardModelFromJson(jsonString);

import 'dart:convert';

BoardModel boardModelFromJson(String str) =>
    BoardModel.fromJson(json.decode(str));

String boardModelToJson(BoardModel data) => json.encode(data.toJson());

class BoardModel {
  int? status;
  Data? data;
  String? message;
  Board? board;

  BoardModel({
    this.status,
    this.data,
    this.message,
    this.board,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
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
  List<Board>? boards;

  Data({
    this.boards,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        boards: json["boards"] == null
            ? []
            : List<Board>.from(json["boards"]!.map((x) => Board.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "boards": boards == null
            ? []
            : List<dynamic>.from(boards!.map((x) => x.toJson())),
      };
}

class Board {
  int? id;
  String? name;
  int? status;

  Board({
    this.id,
    this.name,
    this.status,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}
