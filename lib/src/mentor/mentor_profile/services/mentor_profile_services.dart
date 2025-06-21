import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class MentorProfileService {

  Dio dio = Dio();

  Future updateProfileData(Map<String, dynamic> body) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.updateMentorProfile,
        data: body,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Update Mentor Profile Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Update Mentor Profile Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Update Mentor Profile Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Update Mentor Profile Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

}