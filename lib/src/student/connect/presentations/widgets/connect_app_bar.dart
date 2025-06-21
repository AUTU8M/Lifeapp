import 'package:flutter/material.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/string_helper.dart';

class ConnectAppbarWidget extends StatelessWidget {
  const ConnectAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          StringHelper.chooseTheSession,
          style: TextStyle(
            color: ColorCode.textBlackColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
