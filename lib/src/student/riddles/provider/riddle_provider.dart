import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/questions/models/question_model.dart';
import 'package:lifelab3/src/student/questions/presentations/question_page.dart';
import 'package:lifelab3/src/student/riddles/model/add_quiz_model.dart';
import 'package:lifelab3/src/student/riddles/services/riddle_services.dart';

import '../../../common/helper/color_code.dart';


class RiddleProvider extends ChangeNotifier {

  QuestionModel? questionModel;

  void addRiddleQuiz(BuildContext context,Map<String, dynamic> data) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await RiddleServices().addRiddleQuiz(data);


    if(response.statusCode == 200) {
      AddQuizModel model = AddQuizModel.fromJson(response.data);
      getRiddleQue(
        context: context,
        id: model.data!.id!.toString(),
        time: data["type"].toString() == "2" ? model.data!.time! : null,
        quizId: model.data!.id!,
        name: data["type"].toString() == "2" ? "Quiz" : data["type"].toString() == "3" ? "Riddle" : "Puzzle"
      );
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
      Loader.hide();
    }
    notifyListeners();
  }

  void getRiddleQue(
      {required BuildContext context,
      required String id,
      int? time,
      required int quizId,
      required String name}) async {

    Response response = await RiddleServices().getRiddleQue(id);

    Loader.hide();
    if(response.statusCode == 200) {
      questionModel = QuestionModel.fromJson(response.data);
      push(
        context: context,
        page: QuestionPage(
          questionsModel: questionModel!,
          time: time,
          quizId: quizId.toString(),
          name: name,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data["message"]);
    }
    notifyListeners();
  }

}