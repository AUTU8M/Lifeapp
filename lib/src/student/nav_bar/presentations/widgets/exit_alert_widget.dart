import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

exitAlert(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    useRootNavigator: true,
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(StringHelper.helloThere),
      content: const Text(StringHelper.doYouWantToExit),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          child: const Text("No"),
        ),
      ],
    ),
  );
}