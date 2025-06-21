import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

class SignUpApiService {

  Dio dio = Dio();

  Future sendOtp({required Map<String, dynamic> map}) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.sendOtp,
        data: map,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      debugPrint("Send Otp Code: ${response.statusCode}");

      if(response.statusCode == 200) {
        return response;
      }

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Send Otp Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } on DioException catch(e) {
      debugPrint("Send Otp Dio Error ${e.response}");
      Loader.hide();
    } catch (e) {
      Loader.hide();
      debugPrint("Send Otp Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future verifyOtp({required Map<String, dynamic> map}) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.verifyOtp,
        data: map,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      debugPrint("Verify Otp Code: ${response.statusCode}");
      debugPrint("Verify Otp Data: ${response.data}");

      if(response.statusCode == 200) {
        return response;
      }

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Verify Oto Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } on DioException catch(e) {
      debugPrint("Verify Otp Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } catch (e) {
      Loader.hide();
      debugPrint("Verify Otp Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}