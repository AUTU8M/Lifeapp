import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../provider/student_login_provider.dart';
import '../widgets/otp_bottom_sheet.dart';
import 'package:lifelab3/src/common/utils/mixpanel_service.dart';

class StudentLoginPage extends StatelessWidget {
  const StudentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentLoginProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => StudentLoginProvider(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(ImageHelper.welcomeImg2),

              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  StringHelper.welcome,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  StringHelper.welcomeMsg2,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),

              // Mobile Number
              CustomTextField(
                readOnly: false,
                height: 50,
                color: Colors.white,
                hintName: StringHelper.enterMobileNumber,
                fieldController: provider.contactController,
                margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
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

              // Submit
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomButton(
                  name: StringHelper.submit,
                  height: 45,
                  onTap: () {
                    if (provider.contactController.text.length == 10) {
                      FocusScope.of(context).unfocus();

                      // 🔹 Mixpanel: Track Login Attempt
                      MixpanelService.track("Login Attempt", properties: {
                        "phone": provider.contactController.text,
                        "timestamp": DateTime.now().toIso8601String(),
                      });

                      enterPinSheet(context, provider);
                      provider.sendOtp(context);
                    } else {
                      Fluttertoast.showToast(msg: StringHelper.invalidData);
                    }
                  },

                ),
              ),

              const SizedBox(height: 70),
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
      ),
    );
  }
}
