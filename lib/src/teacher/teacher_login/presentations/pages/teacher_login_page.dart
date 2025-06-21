import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/teacher/teacher_login/provider/teacher_login_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../widgets/teacher_otp_bottom_sheet.dart';

class TeacherLoginPage extends StatelessWidget {
  const TeacherLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherLoginProvider>(context);
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
                    StringHelper.teacher,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const Text(
                    StringHelper.teacherMsg,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),


                  CustomTextField(
                    readOnly: false,
                    color: Colors.white,
                    hintName: StringHelper.enterMobileNumber,
                    fieldController: provider.contactController,
                    margin: const EdgeInsets.only(top: 30),
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    maxLength: 10,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    onChange: (val) {
                      if(val.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),

                  const SizedBox(height: 30),
                  CustomButton(
                    name: StringHelper.submit,
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    onTap: () {
                      if(provider.contactController.text.length == 10) {
                        provider.sendOtpLogin();
                        teacherEnterPinSheet(context, provider);

                      } else {
                        Fluttertoast.showToast(msg: StringHelper.invalidData);
                      }
                    },
                  ),

                  const SizedBox(height: 40),
                  // const Text(
                  //   StringHelper.dontHaveCode,
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.black54,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 10),
                  // CustomButton(
                  //   name: StringHelper.signUp,
                  //   height: 45,
                  //   width: MediaQuery.of(context).size.width,
                  //   onTap: () {
                  //     push(
                  //       context: context,
                  //       page: const TeacherEnterMobilePage(),
                  //     );
                  //   },
                  // ),

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
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
