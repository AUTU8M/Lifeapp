import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/quiz/model/quiz_history_model.dart';
import 'package:lifelab3/src/student/quiz/services/quiz_services.dart';

import '../../../common/helper/color_code.dart';

class QuizProvider extends ChangeNotifier {

  QuizHistoryModel? quizHistoryModel;

  void getQuizHistory({required BuildContext context}) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await QuizServices().getQuizHistory();

    if(response.statusCode == 200) {
      quizHistoryModel = QuizHistoryModel.fromJson(response.data);
      Loader.hide();
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
      Loader.hide();
    }

    notifyListeners();
  }
}