import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';

import '../../../common/helper/api_helper.dart';

class DashboardServices {

  Dio dio = Dio();

  Future getDashboardData() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.dashboard,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Dashboard Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Dashboard Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Dashboard Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Dashboard Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getSubjectData() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.subjects,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Subject Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Subject Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Subject Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Subject Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getCoinHistory() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.coinHistory,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Coin History Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Coin History Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Coin History Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Coin History Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future subscribeCode({required String code, required String type}) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.subscribeCode,
        data: {
          "enrollment_code": code,
          "type": type
        },
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Subscribe Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Subscribe Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Subscribe Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Subscribe Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future checkSubscription() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.checkSubscription,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Check Subscribe Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      Loader.hide();
      debugPrint("Check Subscribe Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Check Subscribe Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Check Subscribe Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

}