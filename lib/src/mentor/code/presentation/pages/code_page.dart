import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/mentor/code/presentation/widgets/mentor_otp_bottom_sheet.dart';
import 'package:lifelab3/src/mentor/code/presentation/widgets/mentor_otp_widget.dart';
import 'package:lifelab3/src/mentor/code/provider/mentor_code_provider.dart';
import 'package:lifelab3/src/mentor/code/services/mentor_login_service.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/custom_button.dart';

class CodePage extends StatelessWidget {
  const CodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MentorOtpProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ImageHelper.welcomeImg2),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  const Text(
                    StringHelper.mentor,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const Text(
                    StringHelper.mentorCode,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),
                  MentorOtpWidget1(provider: provider),

                  const SizedBox(height: 80),
                  CustomButton(
                    name: StringHelper.submit,
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    onTap: () {
                      if(provider.codeController.text.length == 4) {
                        MentorLoginService().sendOtp(provider.codeController.text).then((value) {
                          mentorEnterPinSheet(context, provider, value.data["data"]["mobile_no"]);
                        });
                      } else {
                        Fluttertoast.showToast(msg: StringHelper.invalidData);
                      }
                    },
                  ),

                  const SizedBox(height: 50),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),

                      SizedBox(width: 10),
                      Text(
                        StringHelper.aLifeLabProduct,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
