import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class QueServices {

  Dio dio = Dio();

  Future submitQuiz({required Map<String, dynamic> data, required String id}) async {
    try {
      Response response = await dio.post(
        "${ApiHelper.baseUrl}${ApiHelper.submitQuiz}$id/answers",
        data: FormData.fromMap(data),
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Submit Quiz Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Submit Quiz Dio Error ${e.response}");
      Fluttertoast.showToast(msg: "No answer selected, restart the quiz.");
      Loader.hide();
      return e.response;
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Submit Quiz Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Submit Quiz Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future quizResult({required String id}) async {
    try {
      Response response = await dio.get(
        "${ApiHelper.baseUrl}${ApiHelper.submitQuiz}$id/results",
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Quiz Result Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Quiz Result Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Quiz Result Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Quiz Result Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future quizReviewData({required String id}) async {
    try {
      Response response = await dio.get(
        "${ApiHelper.baseUrl}${ApiHelper.submitQuiz}$id/answers",
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Quiz Review Code: ${response.statusCode}");
      log("Quiz Review Data: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Quiz Review Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Quiz Review Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Quiz Review Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}