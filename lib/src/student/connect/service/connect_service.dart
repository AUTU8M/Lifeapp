import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class ConnectService {

  Dio dio = Dio();

  Future sessionDetails(String id) async {

    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.sessionDetails + id,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Session Details Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Session Details Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Session Details Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Session Details Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future bookSession(String id) async {

    try {
      Response response = await dio.post(
        "${ApiHelper.baseUrl}${ApiHelper.sessionDetails}$id/participate",
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Book Session Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Book Session Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Book Session Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Book Session Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future attendSession() async {

    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.attendSession,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Attended Session Code: ${response.statusCode}");
      debugPrint("Attended Session Data: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Attended Session Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Attended Session Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Attended Session Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}