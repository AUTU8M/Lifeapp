import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/provider/mentor_create_session_provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/custom_button.dart';

class MentorCreateSessionSubmitButton extends StatelessWidget {

  final MentorCreateSessionProvider provider;

  const MentorCreateSessionSubmitButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
      child: CustomButton(
        name: StringHelper.submit,
        color: ColorCode.buttonColor,
        height: 45,
        onTap: () {
          provider.createSession(context);
        },
      ),
    );
  }
}
