import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/connect/service/connect_service.dart';

import '../../../common/helper/color_code.dart';
import '../../../mentor/mentor_home/model/mentor_session_details_model.dart';
import '../../../mentor/mentor_home/model/mentor_upcoming_session_model.dart';
import '../../../mentor/mentor_home/services/mentor_home_service.dart';

class ConnectProvider extends ChangeNotifier {

  MentorUpcomingSessionModel? upcomingSessionModel;
  MentorUpcomingSessionModel? attendedSessionModel;
  MentorSessionDetailsModel? sessionDetailsModel;

  int tabIndex = 0;

  void updateTabIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future upcomingSession(BuildContext context) async {
    // Loader.show(
    //   context,
    //   progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
    //   overlayColor: Colors.black54,
    // );


    Response response = await MentorHomeService().upcomingSession();

    Loader.hide();

    if(response.statusCode == 200) {
      upcomingSessionModel = MentorUpcomingSessionModel.fromJson(response.data);
    } else {
      upcomingSessionModel = null;
    }
    notifyListeners();
  }

  Future attendSession(BuildContext context) async {
    // Loader.show(
    //   context,
    //   progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
    //   overlayColor: Colors.black54,
    // );


    Response response = await ConnectService().attendSession();

    Loader.hide();

    if(response.statusCode == 200) {
      attendedSessionModel = MentorUpcomingSessionModel.fromJson(response.data);
    } else {
      attendedSessionModel = null;
    }
    notifyListeners();
  }

  Future bookSession(BuildContext context, String id) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );


    Response response = await ConnectService().bookSession(id);

    Loader.hide();

    if(response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data["message"]);
      sessionDetails(id);
      upcomingSession(context);
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
    }
    notifyListeners();
  }

  Future sessionDetails(String id) async {

    Response response = await ConnectService().sessionDetails(id);

    if(response.statusCode == 200) {
      sessionDetailsModel = MentorSessionDetailsModel.fromJson(response.data);
    } else {
      sessionDetailsModel = null;
    }
    notifyListeners();
  }
}