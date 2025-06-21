import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/mentor/mentor_home/provider/mentor_home_provider.dart';
import 'package:lifelab3/src/mentor/mentor_profile/services/mentor_profile_services.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';

class MentorProfileProvider extends ChangeNotifier {

  TextEditingController mentorNameController = TextEditingController();

  void update(BuildContext context) async {

    if(mentorNameController.text.trim().isNotEmpty) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      Map<String, dynamic> body = {
        "mobile_no": Provider.of<MentorHomeProvider>(context, listen: false).dashboardModel!.data!.user!.mobileNo!,
        "name": mentorNameController.text.trim(),
      };

      Response response = await MentorProfileService().updateProfileData(body);

      Loader.hide();

      if(response.statusCode == 200) {
        if(!context.mounted) return;
        Fluttertoast.showToast(msg: "Updated");
        Provider.of<MentorHomeProvider>(context, listen: false).getDashboardData();
      }
    } else {
      Fluttertoast.showToast(msg: StringHelper.invalidData);
    }
  }

}