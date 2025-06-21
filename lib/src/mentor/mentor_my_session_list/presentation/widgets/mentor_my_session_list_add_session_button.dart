import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/presentations/pages/mentor_create_session_page.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/provider/mentor_my_session_list_provider_page.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/custom_button.dart';

class MentorMySessionListAddSessionButton extends StatelessWidget {

  final MentorMySessionListProvider provider;

  const MentorMySessionListAddSessionButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      child: CustomButton(
        name: StringHelper.addNew,
        color: ColorCode.buttonColor,
        height: 35,
        width: 110,
        onTap: () {
          push(
            context: context,
            page: const MentorCreateSessionPage(),
          );
        },
      ),
    );
  }
}
