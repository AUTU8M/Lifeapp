import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/home/models/coin_history_model.dart';
import 'package:lifelab3/src/student/home/models/dashboard_model.dart';
import 'package:lifelab3/src/student/home/models/subject_model.dart';
import 'package:lifelab3/src/student/home/services/dashboard_services.dart';
import 'package:lifelab3/src/teacher/teacher_tool/services/tool_services.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';
import 'package:lifelab3/src/student/home/models/campaign_model.dart';
import '../../../common/helper/color_code.dart';


class DashboardProvider extends ChangeNotifier {

  DashboardModel? dashboardModel;
  SubjectModel? subjectModel;
  CoinsHistoryModel? coinsHistoryModel;

  List<Campaign> _campaigns = [];
  List<Campaign> get campaigns => _campaigns;

  String? subscribeCode;

  // Fetch campaigns
  Future<void> getTodayCampaigns() async {
    _campaigns = await DashboardServices().getTodayCampaigns();
    notifyListeners();

  }
  Future<void> getDashboardData() async {
    Response response = await DashboardServices().getDashboardData();

    if(response.statusCode == 200) {
      dashboardModel = DashboardModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> storeToken() async {
    await ToolServices().storeToken(deviceToken: StorageUtil.getString(StringHelper.fcmToken));
  }

  Future<void> getSubjectsData() async {
    Response response = await DashboardServices().getSubjectData();

    if(response.statusCode == 200) {
      subjectModel = SubjectModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getCoinHistoryData() async {
    Response response = await DashboardServices().getCoinHistory();

    if(response.statusCode == 200) {
      coinsHistoryModel = CoinsHistoryModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> subscribe(BuildContext context, String type) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await DashboardServices().subscribeCode(code: subscribeCode!, type: type);

    Loader.hide();

    if(response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Subscribed");
      Navigator.pop(context);
      getDashboardData();
      checkSubscription();
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

  Future<void> checkSubscription() async {
    Response response = await DashboardServices().checkSubscription();

    if(response.statusCode == 200) {
      StorageUtil.putBool(StringHelper.isJigyasa, response.data["data"]["JIGYASA"] == 1 ? true : false);
      StorageUtil.putBool(StringHelper.isPragya, response.data["data"]["PRAGYA"] == 1 ? true : false);
      StorageUtil.putBool(StringHelper.isTeacherLifeLabDemo, response.data["data"]["LIFE_LAB_DEMO_MODELS"] == 1 ? true : false);
      StorageUtil.putBool(StringHelper.isTeacherJigyasa, response.data["data"]["JIGYASA_SELF_DIY_ACTVITES"] == 1 ? true : false);
      StorageUtil.putBool(StringHelper.isTeacherPragya, response.data["data"]["PRAGYA_DIY_ACTIVITES_WITH_LIFE_LAB_KITS"] == 1 ? true : false);
      StorageUtil.putBool(StringHelper.isTeacherLesson, response.data["data"]["LIFE_LAB_ACTIVITIES_LESSION_PLANS"] == 1 ? true : false);
    }
  }

}