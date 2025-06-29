import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/home/presentations/pages/subscribe_page.dart';

import '../../../../common/helper/string_helper.dart';
import '../../../../utils/storage_utils.dart';
import '../../../subject_list/presentation/page/subject_list_page.dart';

class ExploreChallengesWidget extends StatelessWidget {
  const ExploreChallengesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringHelper.exploreByChallenges,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ChallengeWidget(
              name: StringHelper.vision,
              img: ImageHelper.visionIcon,
              isSubscribe: true,
            ),

            const ChallengeWidget(
              name: StringHelper.mission,
              img: ImageHelper.missionIcon,
              isSubscribe: true,
            ),

            ChallengeWidget(
              name: StringHelper.jigyasaSelf,
              img: ImageHelper.jigyasaIcon,
              isSubscribe: StorageUtil.getBool(StringHelper.isJigyasa),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChallengeWidget(
              name: StringHelper.pragyaSelf,
              img: ImageHelper.pragyaIcon,
              isSubscribe: StorageUtil.getBool(StringHelper.isPragya),
            ),
            const ChallengeWidget(
              name: StringHelper.puzzles,
              img: ImageHelper.puzzleIcon,
              isSubscribe: true,
            ),
            const ChallengeWidget(
              name: StringHelper.quizSelf,
              img: ImageHelper.quizIcon,
              isSubscribe: true,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChallengeWidget(
              name: StringHelper.quizWithFriends,
              img: ImageHelper.quizIcon,
              isSubscribe: true,
            ),
          ],
        ),
      ],
    );
  }
}

class ChallengeWidget extends StatelessWidget {
  final String name;
  final String img;
  final bool isSubscribe;

  const ChallengeWidget({
    required this.name,
    required this.img,
    required this.isSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (name) {
          case StringHelper.mission:
            return push(
              context: context,
              page: const SubjectListPage(
                navName: StringHelper.mission,
              ),
            );

          case StringHelper.vision:
            return push(
              context: context,
              page: const SubjectListPage(
                navName: StringHelper.vision,
              ),
            );

          case StringHelper.quizSelf:
            return push(
              context: context,
              page: const SubjectListPage(
                navName: StringHelper.quizSelf,
              ),
            );

          case StringHelper.jigyasaSelf:
            if (StorageUtil.getBool(StringHelper.isJigyasa)) {
              return push(
                context: context,
                page: const SubjectListPage(
                  navName: StringHelper.jigyasaSelf,
                ),
              );
            } else {
              return push(
                context: context,
                page: const SubScribePage(type: "5"),
              );
            }

          case StringHelper.pragyaSelf:
            if (StorageUtil.getBool(StringHelper.isPragya)) {
              return push(
                context: context,
                page: const SubjectListPage(
                  navName: StringHelper.pragyaSelf,
                ),
              );
            } else {
              return push(
                context: context,
                page: const SubScribePage(type: "6"),
              );
            }

          case StringHelper.puzzles:
            return push(
              context: context,
              page: const SubjectListPage(
                navName: StringHelper.puzzles,
              ),
            );

          case StringHelper.quizWithFriends:
            Fluttertoast.showToast(msg: "Coming Soon");
            // return push(
            //   context: context,
            //   page: const MyQuizPage(),
            // );
            break;
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * .27,
                width: MediaQuery.of(context).size.width * .27,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(img),
                ),
              ),
              !isSubscribe
                  ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * .2,
                  decoration: const BoxDecoration(
                    color: ColorCode.buttonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      StringHelper.subscribe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              )
                  : (isSubscribe &&
                  (name == StringHelper.pragyaSelf ||
                      name == StringHelper.jigyasaSelf))
                  ? Positioned(
                top: 8,
                right: 13,
                child: Image.asset(
                  ImageHelper.crownIcon2,
                  height: 20,
                ),
              )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
