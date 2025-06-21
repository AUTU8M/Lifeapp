import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/teacher/teacher_login/services/teacher_login_services.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/presentations/pages/teacher_sign_up_page.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';
import '../../../common/widgets/common_navigator.dart';
import '../../../student/student_login/model/verify_otp_model.dart';
import '../../../student/student_login/services/student_services.dart';
import '../../../utils/storage_utils.dart';
import '../../teacher_dashboard/presentations/pages/teacher_dashboard_page.dart';

class TeacherLoginProvider extends ChangeNotifier {

  TextEditingController codeController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController contactController = TextEditingController();

  Future<void> sendOtp() async {

    Map<String, dynamic> map = {
      "type": 5,
      "mobile_no": contactController.text,
    };

    Response response = await SignUpApiService().sendOtp(map: map);

    if(response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data["message"]);
    }
  }

  Future<void> sendOtpLogin() async {

    Map<String, dynamic> map = {
      "type": 5,
      "mobile_no": contactController.text,
    };

    Response response = await TeacherLoginServices().sendOtp(map);

    if(response.statusCode == 200) {
      contactController.text = response.data["data"]["mobile_no"];
      Fluttertoast.showToast(msg: response.data["message"]);
      notifyListeners();
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Map<String, dynamic> map = {
      "type": 5,
      "mobile_no": contactController.text,
      "otp": otpController2.text,
    };

    Response? response = await SignUpApiService().verifyOtp(map: map);

    Loader.hide();

    if(response?.statusCode == 200) {
      VerifyOtpModel model = VerifyOtpModel.fromJson(response!.data);
      if(context.mounted) {
        push(
          context: context,
          page: TeacherSignUpPage(contact: contactController.text,),
        );
      }
      Fluttertoast.showToast(msg: response.data["message"]);
    }
  }

  Future<void> verifyOtpLogin(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Map<String, dynamic> map = {
      "type": 5,
      "mobile_no": contactController.text,
      "otp": otpController.text,
    };

    Response? response = await SignUpApiService().verifyOtp(map: map);

    Loader.hide();

    if(response?.statusCode == 200) {
      VerifyOtpModel model = VerifyOtpModel.fromJson(response!.data);
      if(context.mounted) {
        if(model.data!.token!.isNotEmpty) {
          StorageUtil.putBool(StringHelper.isTeacher, true);
          StorageUtil.putString(StringHelper.token, model.data!.token!);
          pushRemoveUntil(context: context, page: const TeacherDashboardPage());
        } else {
          pushRemoveUntil(context: context, page: TeacherSignUpPage(contact: contactController.text));
        }
      }
      Fluttertoast.showToast(msg: response.data["message"]);
    }
  }



}