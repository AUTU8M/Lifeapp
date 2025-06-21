import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/services/mentor_create_services.dart';

import '../../../common/helper/color_code.dart';

class MentorCreateSessionProvider extends ChangeNotifier {

  TextEditingController headingController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DateTime currentDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  Future createSession(BuildContext context) async {
    if(headingController.text.trim().isNotEmpty && descController.text.trim().isNotEmpty
        && dateController.text.trim().isNotEmpty && timeController.text.trim().isNotEmpty) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      Map<String, dynamic> data = {
        "heading": headingController.text,
        "description": descController.text,
        "date": dateController.text,
        "time": timeController.text,
      };

      Response response = await MentorCreateSessionService().createSession(data);

      Loader.hide();

      if(response.statusCode == 200) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Session Created, Please wait it's under review");
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Try again later");
      }
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: StringHelper.invalidData);
    }
  }

}