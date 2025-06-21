import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/questions/services/que_services.dart';

import '../../../common/helper/color_code.dart';
import '../models/result_model.dart';

class QuestionProvider extends ChangeNotifier {

  ResultModel? resultModel;

  void submitQuiz(
      {required BuildContext context, required Map<String, dynamic> data, required String id}) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await QueServices().submitQuiz(data: data, id: id);

    if(response.statusCode == 200) {
      Loader.hide();
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
      Loader.hide();
    }

    notifyListeners();
  }

  void quizResult({required String id}) async {

    Response response = await QueServices().quizResult(id: id);

    if(response.statusCode == 200) {
      resultModel = ResultModel.fromJson(response.data);
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
    }

    notifyListeners();
  }
}