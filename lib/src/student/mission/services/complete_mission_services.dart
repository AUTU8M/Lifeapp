import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class CompleteMissionServices {

  final Dio dio = Dio();

  Future submitMission(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.completeMission,
        data: FormData.fromMap(data),
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Submit Mission Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      Loader.hide();
      debugPrint("Submit Mission Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["error"]);
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Submit Mission Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Submit Mission Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getMissionDetails(String id) async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.getMissionDetails + id,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Get Mission Details Code: ${response.statusCode}");
      debugPrint("Get Mission Details Code: ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("Get Mission Details Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Mission Details Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Mission Details Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}