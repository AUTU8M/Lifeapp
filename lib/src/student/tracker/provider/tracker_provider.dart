import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifelab3/src/student/tracker/models/tracker_model.dart';
import 'package:lifelab3/src/student/tracker/services/tracker_services.dart';

class TrackerProvider extends ChangeNotifier {

  TrackerModel? trackerModel;

  void trackerData() async {
    Response response = await TrackerServices().getTracker();

    if(response.statusCode == 200) {
      trackerModel = TrackerModel.fromJson(response.data);
    } else {
      trackerModel = null;
    }
    notifyListeners();
  }

}