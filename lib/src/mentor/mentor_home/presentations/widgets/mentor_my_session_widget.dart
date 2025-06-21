import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/presentations/pages/mentor_create_session_page.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/presentation/page/mentor_my_session_list_page.dart';

class MentorMySessionWidget extends StatelessWidget {
  const MentorMySessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              StringHelper.mySession,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // View all
            InkWell(
              onTap: () {
                push(
                  context: context,
                  page: const MentorMySessionListPage(),
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Text(
                StringHelper.viewAll,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // Button
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorCode.buttonColor,
          ),
          child: Column(
            children: [
              const Text(
                StringHelper.letsStartNewSession,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              CustomButton(
                name: "+ Add a new session",
                color: Colors.white,
                height: 45,
                textColor: ColorCode.buttonColor,
                onTap: () {
                  push(
                    context: context,
                    page: const MentorCreateSessionPage(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
