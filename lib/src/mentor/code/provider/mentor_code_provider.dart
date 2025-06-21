import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/mentor/code/services/mentor_login_service.dart';
import 'package:lifelab3/src/mentor/mentor_home/presentations/pages/mentor_home_page.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';

class MentorOtpProvider extends ChangeNotifier {

  TextEditingController codeController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future verifyOtp(BuildContext context, String number) async {
    if(codeController.text.isNotEmpty) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      Map<String, dynamic> data = {
        "type": 4,
        "mobile_no": number,
        "otp": otpController.text,
      };

      Response response = await MentorLoginService().confirmOtp(data);

      Loader.hide();

      if(response.statusCode == 200) {
        StorageUtil.putBool(StringHelper.isMentor, true);
        StorageUtil.putString(StringHelper.token, response.data["data"]["token"]);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MentorHomePage()), (route) => false);
      } else {
        Fluttertoast.showToast(msg: "Try again later");
      }
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: StringHelper.invalidData);
    }
  }

}