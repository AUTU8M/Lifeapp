import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifelab3/src/mentor/mentor_home/model/mentor_upcoming_session_model.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/service/mentor_my_session_service.dart';

class MentorMySessionListProvider extends ChangeNotifier {

  MentorUpcomingSessionModel? mySessionModel;

  void getMySession() async {
    Response response = await MentorMySessionService().getMySession();

    if(response.statusCode == 200) {
      mySessionModel = MentorUpcomingSessionModel.fromJson(response.data);
    } else {
      mySessionModel = null;
    }
    notifyListeners();
  }


}