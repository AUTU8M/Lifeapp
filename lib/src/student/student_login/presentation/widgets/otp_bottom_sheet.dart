import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';

import '../../provider/student_login_provider.dart';
import 'otp_widget.dart';


void enterPinSheet(BuildContext context, StudentLoginProvider provider) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: true,
  builder: (context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 330,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              StringHelper.enterTheOtp,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 20),
            OtpWidget(provider: provider),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  StringHelper.termNCondition,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    provider.sendOtp(context);
                  },
                  child: const Text(
                    StringHelper.resendOtp,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            CustomButton(
              name: StringHelper.submit,
              height: 45,
              width: MediaQuery.of(context).size.width,
              onTap: () {
                if(provider.otpController.text.length == 4) {
                  provider.verifyOtp(context);
                } else {
                  Fluttertoast.showToast(msg: StringHelper.invalidData);
                }
              },
            ),

            const SizedBox(height: 40),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  },
);