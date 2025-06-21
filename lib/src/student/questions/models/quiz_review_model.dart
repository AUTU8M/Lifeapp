// To parse this JSON data, do
//
//     final quizReviewModel = quizReviewModelFromJson(jsonString);

import 'dart:convert';

QuizReviewModel quizReviewModelFromJson(String str) => QuizReviewModel.fromJson(json.decode(str));

String quizReviewModelToJson(QuizReviewModel data) => json.encode(data.toJson());

class QuizReviewModel {
  int? status;
  List<Datum>? data;
  QuizGame? quizGame;
  String? message;

  QuizReviewModel({
    this.status,
    this.data,
    this.quizGame,
    this.message,
  });

  factory QuizReviewModel.fromJson(Map<String, dynamic> json) => QuizReviewModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    quizGame: json["quiz_game"] == null ? null : QuizGame.fromJson(json["quiz_game"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "quiz_game": quizGame?.toJson(),
    "message": message,
  };
}

class Datum {
  int? id;
  int? createdBy;
  int? laSubjectId;
  dynamic title;
  int? laLevelId;
  int? status;
  int? index;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? answerOptionId;
  Pivot? pivot;
  List<Option>? options;

  Datum({
    this.id,
    this.createdBy,
    this.laSubjectId,
    this.title,
    this.laLevelId,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
    this.answerOptionId,
    this.pivot,
    this.options,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdBy: json["created_by"],
    laSubjectId: json["la_subject_id"],
    title: json["title"],
    laLevelId: json["la_level_id"],
    status: json["status"],
    index: json["index"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    answerOptionId: json["answer_option_id"],
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_by": createdBy,
    "la_subject_id": laSubjectId,
    "title": title,
    "la_level_id": laLevelId,
    "status": status,
    "index": index,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "answer_option_id": answerOptionId,
    "pivot": pivot?.toJson(),
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  int? id;
  int? questionId;
  dynamic title;
  DateTime? createdAt;
  DateTime? updatedAt;

  Option({
    this.id,
    this.questionId,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    questionId: json["question_id"],
    title: json["title"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_id": questionId,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Title {
  String? en;

  Title({
    this.en,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class Pivot {
  int? laQuizGameId;
  int? laQuestionId;
  int? laQuestionOptionId;
  int? userId;
  int? isCorrect;
  int? coins;

  Pivot({
    this.laQuizGameId,
    this.laQuestionId,
    this.laQuestionOptionId,
    this.userId,
    this.isCorrect,
    this.coins,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    laQuizGameId: json["la_quiz_game_id"],
    laQuestionId: json["la_question_id"],
    laQuestionOptionId: json["la_question_option_id"],
    userId: json["user_id"],
    isCorrect: json["is_correct"],
    coins: json["coins"],
  );

  Map<String, dynamic> toJson() => {
    "la_quiz_game_id": laQuizGameId,
    "la_question_id": laQuestionId,
    "la_question_option_id": laQuestionOptionId,
    "user_id": userId,
    "is_correct": isCorrect,
    "coins": coins,
  };
}

class QuizGame {
  int? id;
  int? status;
  int? gameParticipantStatus;

  QuizGame({
    this.id,
    this.status,
    this.gameParticipantStatus,
  });

  factory QuizGame.fromJson(Map<String, dynamic> json) => QuizGame(
    id: json["id"],
    status: json["status"],
    gameParticipantStatus: json["game_participant_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "game_participant_status": gameParticipantStatus,
  };
}
