import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';

AppBar commonAppBar({required BuildContext context, required String name, Widget? action, List? sendData, Function()? onBack}) => AppBar(
  leading: IconButton(
    onPressed: onBack ?? () {
      if(sendData != null) {
        Navigator.pop(context, sendData);
      } else {
        Navigator.pop(context);
      }
    },
    icon: const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.black,
    ),
  ),
  title: Text(
    name,
    style: const TextStyle(
      color: ColorCode.textBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
  ),
  actions: [action ?? const SizedBox()],
);