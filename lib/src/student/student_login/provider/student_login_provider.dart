import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/nav_bar/presentations/pages/nav_bar_page.dart';
import 'package:lifelab3/src/student/student_login/model/verify_otp_model.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';
import '../../sign_up/presentations/pages/sign_up_page.dart';
import '../services/student_services.dart';

class StudentLoginProvider extends ChangeNotifier {

  TextEditingController contactController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future<void> sendOtp(BuildContext context) async {
    // Loader.show(
    //   context,
    //   progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
    //   overlayColor: Colors.black54,
    // );

    Map<String, dynamic> map = {
      "type": 3,
      "mobile_no": contactController.text,
    };

    Response response = await SignUpApiService().sendOtp(map: map);

    Loader.hide();

    if(response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data["message"]);
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Map<String, dynamic> map = {
      "type": 3,
      "mobile_no": contactController.text,
      "otp": otpController.text,
    };

    Response? response = await SignUpApiService().verifyOtp(map: map);

    Loader.hide();

    if(response?.statusCode == 200) {
      VerifyOtpModel model = VerifyOtpModel.fromJson(response!.data);
      if(context.mounted) {
        var mo = model.data!.token!;
        debugPrint('storagestringmo $mo');
        if(model.data!.token!.isNotEmpty) {
          StorageUtil.putBool(StringHelper.isLoggedIn, true);
          StorageUtil.putString(StringHelper.token, model.data!.token!);
          const ST= StringHelper.token;
          debugPrint('storagestring $ST $mo');
          pushRemoveUntil(context: context, page: const NavBarPage(currentIndex: 0));
        } else {
          push(
            context: context,
            page: const SignUpPage(),
          );
        }
      }
      Fluttertoast.showToast(msg: response.data["message"]);
    }
  }

  @override
  void dispose() {
    contactController.dispose();
    super.dispose();
  }

}