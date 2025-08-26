import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SubScribePage extends StatelessWidget {

  final String type;

  const SubScribePage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: "Subscribe",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                ImageHelper.cupIcon,
                width: MediaQuery.of(context).size.width * .4,
              ),

              const SizedBox(height: 50),
              const Text(
                "Jigyasa and Pragya are accessible only to the Life Lab students whose schools are a part of the Life Lab program",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 50),
              const Text(
                "Enter the student code you have received",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                appContext: context,
                length: 4,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                textStyle: const TextStyle(fontSize: 30, color: Colors.black54, fontWeight: FontWeight.w600),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                boxShadows: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0 ,5),
                    blurRadius: 5,
                  ),
                ],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  selectedColor: Colors.black38,
                  activeColor: Colors.black38,
                  inactiveColor: Colors.black38,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  borderWidth: 1,
                ),
                enableActiveFill: true,
                cursorColor: Colors.black54,
                onChanged: (val) {
                  provider.subscribeCode = val;
                  provider.notifyListeners();
                },
              ),

              const SizedBox(height: 30),
              CustomButton(
                name: StringHelper.submit,
                height: 45,
                width: 300,
                onTap: () {
                  provider.subscribe(context,type);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
