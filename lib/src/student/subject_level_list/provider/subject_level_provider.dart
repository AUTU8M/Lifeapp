
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifelab3/src/student/subject_level_list/models/level_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/puzzle_topic_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/quiz_topic_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/riddle_topic_model.dart';
import 'package:lifelab3/src/student/subject_level_list/service/level_list_service.dart';

class SubjectLevelProvider extends ChangeNotifier {

  LevelModel? levels;
  MissionListModel? missionListModel;
  MissionListModel? jigyasaListModel;
  MissionListModel? visionListModel;
  MissionListModel? pragyaListModel;
  RiddleTopicModel? riddleTopicModel;
  QuizTopicModel? quizTopicModel;
  PuzzleTopicModel? puzzleTopicModel;

  void getLevel() async {
    Response response = await LevelListService().getLevelData();

    if(response.statusCode == 200) {
      levels = LevelModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getMission(Map<String, dynamic> data, {params}) async {
    Response response = await LevelListService().getMissionData(
      type: data["type"],
        subjectId: data["la_subject_id"]?.toString() ?? '',
        levelId: data["la_level_id"]?.toString() ?? '',
        params: params ?? ""
    );
    if(response.statusCode == 200) {
      missionListModel = MissionListModel.fromJson(response.data);
    } else {
      missionListModel = null;
    }
    notifyListeners();
  }

  Future<void> getJigyasaMission(Map<String, dynamic> data) async {
    Response response = await LevelListService().getMissionData(
      type: data["type"],
      subjectId: data["la_subject_id"],
      levelId: data["la_level_id"],
    );

    if(response.statusCode == 200) {
      jigyasaListModel = MissionListModel.fromJson(response.data);
    } else {
      jigyasaListModel = null;
    }
    notifyListeners();
  }

  Future<void> getVisionMission(Map<String, dynamic> data) async {
    Response response = await LevelListService().getMissionData(
      type: data["type"],
      subjectId: data["la_subject_id"],
      levelId: data["la_level_id"],
    );

    if(response.statusCode == 200) {
      visionListModel = MissionListModel.fromJson(response.data);
    } else {
      visionListModel = null;
    }
    notifyListeners();
  }

  Future<void> getPragyaMission(Map<String, dynamic> data) async {
    Response response = await LevelListService().getMissionData(
      type: data["type"],
      subjectId: data["la_subject_id"],
      levelId: data["la_level_id"],
    );

    if(response.statusCode == 200) {
      pragyaListModel = MissionListModel.fromJson(response.data);
    } else {
      pragyaListModel = null;
    }
    notifyListeners();
  }

  Future<void> getRiddleTopic(Map<String, dynamic> body) async {
    Response response = await LevelListService().getRiddleTopicData(body);

    if(response.statusCode == 200) {
      riddleTopicModel = RiddleTopicModel.fromJson(response.data);
    } else {
      riddleTopicModel = null;
    }
    notifyListeners();
  }

  Future<void> getQuizTopic(Map<String, dynamic> body) async {
    Response response = await LevelListService().getQuizTopicData(body);

    if(response.statusCode == 200) {
      quizTopicModel = QuizTopicModel.fromJson(response.data);
    } else {
      quizTopicModel = null;
    }
    notifyListeners();
  }

  Future<void> getPuzzleTopic(Map<String, dynamic> body) async {
    Response response = await LevelListService().getPuzzleTopicData(body);

    if(response.statusCode == 200) {
      puzzleTopicModel = PuzzleTopicModel.fromJson(response.data);
    } else {
      puzzleTopicModel = null;
    }
    notifyListeners();
  }

}