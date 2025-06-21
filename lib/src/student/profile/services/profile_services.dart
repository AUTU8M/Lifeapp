import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class ProfileService {

  Dio dio = Dio();

  Future logout() async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.logout,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Logout Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Logout Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Logout Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Logout Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future uploadProfile(File file) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.uploadImage,
        data: FormData.fromMap({
          "media": await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last)
        }),
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Upload Image Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Upload Image Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Upload Image Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Upload Image Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future updateProfileData(Map<String, dynamic> body, {bool isStudent = false}) async {
    try {

      String endpoint = isStudent ? ApiHelper.uploadProfile : ApiHelper.uploadTeacherProfile;
      
      if (!isStudent) {
        debugPrint("Teacher Profile Update:");
        debugPrint("Endpoint: ${ApiHelper.baseUrl}$endpoint");
        debugPrint("Request Body: $body");
      }


      Response response = await dio.post(
        ApiHelper.baseUrl + (isStudent?ApiHelper.uploadProfile:ApiHelper.uploadTeacherProfile),
        data: body,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );


      if (!isStudent) {
        debugPrint("Teacher Profile Response Status: ${response.statusCode}");
        debugPrint("Teacher Profile Response Body: ${response.data}");
      }


      debugPrint("Update Profile Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      Loader.hide();
      debugPrint("Update Profile Dio Error ${e.response}");
      Fluttertoast.showToast(msg: "Try again later");

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Update Profile Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Update Profile Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

}