import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/mission/models/mission_details_model.dart';
import 'package:lifelab3/src/student/mission/presentations/pages/mission_success_page.dart';
import 'package:lifelab3/src/student/mission/services/complete_mission_services.dart';

import '../../../common/helper/color_code.dart';

class MissionProvider extends ChangeNotifier {

  TextEditingController descController = TextEditingController();

  MissionDetailsModel? missionDetailsModel;


  void submitMission(BuildContext context, Map<String, dynamic> data) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await CompleteMissionServices().submitMission(data);

    Loader.hide();

    if(response.statusCode == 200) {
      push(
        context: context,
        page: MissionSuccessPage(id: data["la_mission_id"]),
      );
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
    }

  }

  void getMissionDetails(BuildContext context, String id) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await CompleteMissionServices().getMissionDetails(id);

    Loader.hide();

    if(response.statusCode == 200) {
      missionDetailsModel = MissionDetailsModel.fromJson(response.data);
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
    }

    notifyListeners();

  }

}