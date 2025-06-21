import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class NotificationServices {

  Dio dio = Dio();

  Future getNotification() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.notification,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Notification Code: ${response.statusCode}");
      log("Notification Code: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Notification Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Notification Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Notification Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future clearNotification() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.clearNotification,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Clear Notification Code: ${response.statusCode}");
      log("Clear Notification Code: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Clear Notification Dio Error ${e.response}");
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Clear Notification Socket Error: $e");
    } catch (e) {
      Loader.hide();
      debugPrint("Clear Notification Catch Error: $e");
    }
  }
}