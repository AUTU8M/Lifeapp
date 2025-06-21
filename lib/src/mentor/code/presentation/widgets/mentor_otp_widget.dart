import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelab3/src/mentor/code/provider/mentor_code_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class MentorOtpWidget1 extends StatelessWidget {

  final MentorOtpProvider provider;

  const MentorOtpWidget1({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
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
        provider.codeController.text = val;
        provider.notifyListeners();
      },
    );
  }
}

class MentorOtpWidget2 extends StatelessWidget {

  final MentorOtpProvider provider;

  const MentorOtpWidget2({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
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
        provider.otpController.text = val;
        provider.notifyListeners();
      },
    );
  }
}
