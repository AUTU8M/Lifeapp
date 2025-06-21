import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';

import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/common_navigator.dart';
import '../../../nav_bar/presentations/pages/nav_bar_page.dart';

class MentorConnectWidget extends StatelessWidget {
  MentorConnectWidget({super.key});

  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              StringHelper.mentorConnect,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 10),
            Tooltip(
              message: "Meet industry pros to discuss\ntheir journey, career paths,\nand ask questions.Book \nsessions in the app!",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorCode.defaultBgColor,
              ),
              showDuration: const Duration(seconds: 1),
              triggerMode: TooltipTriggerMode.manual,
              key: tooltipKey,
              margin: const EdgeInsets.only(left: 30),
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  tooltipKey.currentState?.ensureTooltipVisible();
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: ColorCode.buttonColor,
                  child: Text(
                    "i",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorCode.buttonColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringHelper.mentorConnectTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    ImageHelper.teacherIcon,
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ],
              ),

              // Book my slot
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  // Fluttertoast.showToast(msg: "Coming soon");
                  push(
                    context: context,
                    page: const NavBarPage(currentIndex: 2),
                    withNavbar: false,
                  );
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      StringHelper.bookMySlot,
                      style: TextStyle(
                        color: ColorCode.buttonColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
