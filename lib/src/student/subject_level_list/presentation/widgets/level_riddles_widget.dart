import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/subject_level_list/provider/subject_level_provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../riddles/presentations/pages/riddles_page.dart';

class LevelRiddleWidget extends StatelessWidget {

  final SubjectLevelProvider provider;
  final String levelId;
  final String subjectId;

  const LevelRiddleWidget({super.key, required this.provider, required this.levelId, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Row(
          children: [
            Text(
              StringHelper.riddles,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 10),
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorCode.buttonColor,
              child: Text(
                "i",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 170,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF8B8),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const Positioned(
                top: 25,
                left: 20,
                child: Text(
                  StringHelper.riddlesDes,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                bottom: 22,
                left: 20,
                child: InkWell(
                  onTap: () {
                    push(
                      context: context,
                      page: RiddlesPage(
                        provider: provider,
                        levelId: levelId,
                        subjectId: subjectId,
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: const Color(0xffE08800),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child:  const Text(
                      StringHelper.getStarted,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 10,
                child: Container(
                  alignment: Alignment.topRight,
                  height: 160,
                  child: Image.asset(
                    ImageHelper.cupIcon,
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
