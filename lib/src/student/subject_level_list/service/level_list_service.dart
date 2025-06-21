import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class LevelListService {

  final Dio dio = Dio();

  Future getLevelData() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.levels,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Level Code: ${response.statusCode}");
      debugPrint("Get Level Code: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Level Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Level Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Level Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getMissionData({required int type, required String subjectId, required String levelId, String params = ""}) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.mission + params,
        data: {
          "la_subject_id": subjectId,
          "la_level_id": levelId,
          "type": type,
        },
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Mission Code: ${response.statusCode}");
      debugPrint("Get Mission Data: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Mission Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Mission Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Mission Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getRiddleTopicData(Map<String, dynamic> body) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.topic,
        data: body,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Riddle Topic Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Riddle Topic Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Riddle Topic Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Riddle Topic Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getQuizTopicData(Map<String, dynamic> body) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.topic,
        data: body,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Quiz Topic Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Quiz Topic Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Quiz Topic Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Quiz Topic Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getPuzzleTopicData(Map<String, dynamic> body) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.topic,
        data: body,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Puzzle Topic Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Puzzle Topic Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Puzzle Topic Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Puzzle Topic Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

}