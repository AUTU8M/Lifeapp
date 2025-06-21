import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:lifelab3/src/mentor/mentor_home/model/mentor_session_details_model.dart';
import 'package:lifelab3/src/mentor/mentor_home/model/mentor_upcoming_session_model.dart';
import 'package:lifelab3/src/mentor/mentor_home/services/mentor_home_service.dart';
import 'package:lifelab3/src/student/home/models/dashboard_model.dart';

import '../../../common/helper/string_helper.dart';
import '../../../student/home/services/dashboard_services.dart';
import '../../../teacher/teacher_tool/services/tool_services.dart';
import '../../../utils/storage_utils.dart';

class MentorHomeProvider extends ChangeNotifier {

  MentorUpcomingSessionModel? upcomingSessionModel;
  MentorSessionDetailsModel? sessionDetailsModel;
  DashboardModel? dashboardModel;

  Future<void> storeToken() async {
    await ToolServices().storeToken(deviceToken: StorageUtil.getString(StringHelper.fcmToken));
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

  Future<void> getDashboardData() async {
    Response response = await DashboardServices().getDashboardData();

    if(response.statusCode == 200) {
      dashboardModel = DashboardModel.fromJson(response.data);
      notifyListeners();
    }
  }
}