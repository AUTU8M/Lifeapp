import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class TrackerServices {

  final Dio dio = Dio();

  Future getTracker() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.tracker,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );
      debugPrint("Get Tracker URL: ${ApiHelper.baseUrl + ApiHelper.tracker}");
      debugPrint("Get Tracker Code: ${response.statusCode}");
      debugPrint("Get Tracker Response: $response");


      return response;
    } on DioException catch (e) {
      debugPrint("Get Tracker Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Tracker Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Get Tracker Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}