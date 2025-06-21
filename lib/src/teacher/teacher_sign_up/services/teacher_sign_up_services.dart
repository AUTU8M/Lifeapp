import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';

class TeacherSignUpServices {

  Dio dio = Dio();

  Future getSchoolList() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.getSchoolList,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      debugPrint("Get School List Code: ${response.statusCode}");

      if(response.statusCode == 200) {
        return response;
      }

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get School List Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } on DioException catch(e) {
      debugPrint("Get School List Dio Error ${e.response}");
      Loader.hide();
    } catch (e) {
      Loader.hide();
      debugPrint("Get School List Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }


  Future getSectionList() async {
  try {
    Response response = await dio.get(
      ApiHelper.baseUrl + ApiHelper.getSectionList,
      options: Options(
        contentType: "application/json",
        headers: {
          HttpHeaders.acceptHeader: "application/json",
        },
      ),
    );

    debugPrint("Get Section List Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return response;
    }

  } on SocketException catch (e) {
    Loader.hide();
    debugPrint("Get Section List Socket Error: $e");
    Fluttertoast.showToast(msg: StringHelper.badInternet);
  } on DioException catch (e) {
    debugPrint("Get Section List Dio Error ${e.response}");
    Fluttertoast.showToast(msg: e.response!.data!["message"]);
    Loader.hide();
  } catch (e) {
    Loader.hide();
    debugPrint("Get Section List Catch Error: $e");
    Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
  }
}


  Future getGradesList() async {
  try {
    Response response = await dio.get(
      ApiHelper.baseUrl + ApiHelper.getGradesList,
      options: Options(
        contentType: "application/json",
        headers: {
          HttpHeaders.acceptHeader: "application/json",
        },
      ),
    );

    debugPrint("Get Grade List Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return response;
    }

  } on SocketException catch (e) {
    Loader.hide();
    debugPrint("Get Grade List Socket Error: $e");
    Fluttertoast.showToast(msg: StringHelper.badInternet);
  } on DioException catch (e) {
    debugPrint("Get Grade List Dio Error ${e.response}");
    Fluttertoast.showToast(msg: e.response!.data!["message"]);
    Loader.hide();
  } catch (e) {
    Loader.hide();
    debugPrint("Get Grade List Catch Error: $e");
    Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
  }
}

Future subjects() async {
  try {
    Response response = await dio.get(
      ApiHelper.baseUrl + ApiHelper.subjects,
      options: Options(
        contentType: "application/json",
        headers: {
          HttpHeaders.acceptHeader: "application/json",
        },
      ),
    );

    debugPrint("Get Subject Data Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return response;
    }

  } on SocketException catch (e) {
    Loader.hide();
    debugPrint("Get Subject Data Socket Error: $e");
    Fluttertoast.showToast(msg: StringHelper.badInternet);
  } on DioException catch (e) {
    debugPrint("Get Subject Data Dio Error ${e.response}");
    Fluttertoast.showToast(msg: e.response!.data!["message"]);
    Loader.hide();
  } catch (e) {
    Loader.hide();
    debugPrint("Get Subject Data Catch Error: $e");
    Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
  }
}


  Future getBoard() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.getBoard,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      debugPrint("Get Board List Code: ${response.statusCode}");

      if(response.statusCode == 200) {
        return response;
      }

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get Board List Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } on DioException catch(e) {
      debugPrint("Get Board List Dio Error ${e.response}");
      Loader.hide();
    } catch (e) {
      Loader.hide();
      debugPrint("Get Board List Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getStateList() async {
    try {
      Response response = await dio.get(
        ApiHelper.baseUrl + ApiHelper.getStateList,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      debugPrint("Get State List Code: ${response.statusCode}");

      if(response.statusCode == 200) {
        return response;
      }

    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Get State List Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } on DioException catch(e) {
      debugPrint("Verify Otp Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } catch (e) {
      Loader.hide();
      debugPrint("Get State List Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future registerStudent(Map<String, dynamic> body) async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.register,
        data: FormData.fromMap(body),
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          },
          sendTimeout: const Duration(seconds: 3),
        ),
      );

      debugPrint("Register Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Register Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Register Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Register Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }
}