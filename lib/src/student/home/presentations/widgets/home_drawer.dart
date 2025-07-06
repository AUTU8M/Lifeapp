import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/friend/presentations/pages/friend_page.dart';
import 'package:lifelab3/src/student/hall_of_fame/presentations/pages/hall_of_fame_page.dart';
import 'package:lifelab3/src/student/home/presentations/pages/coin_history_page.dart';
import 'package:lifelab3/src/student/home/presentations/pages/faq_page.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';
import 'package:lifelab3/src/welcome/presentation/page/welcome_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/mixpanel_service.dart';
import '../../../profile/services/profile_services.dart';
import '../../../subject_list/presentation/page/subject_list_page.dart';

class DrawerView extends StatelessWidget {
  final String coin;
  final String name;

  const DrawerView({super.key, required this.coin, required this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorCode.buttonColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const _ChallengeWidget(),

            _RewardWidget(coins: coin),

            const SizedBox(height: 5),
            const _AskQueWidget(),

            const SizedBox(height: 20),
            const _MoodMeterWidget(),

            const SizedBox(height: 20),
            _InviteFriendWidget(name: name),

            const SizedBox(height: 20),
            const _TermCondWidget(),

            const SizedBox(height: 20),
            const _FaQWidget(),

            const SizedBox(height: 20),
            const _FeedbackWidget(),

            // Version
            const SizedBox(height: 30),
            const Text(
              "${StringHelper.version} 3.0.0",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),

            // Reset Pin
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                // TODO
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Text(
                StringHelper.resetPin,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Logout
            // Reset Pin
            const SizedBox(height: 50),
            InkWell(
              onTap: () async {
                Loader.show(
                  context,
                  progressIndicator: const CircularProgressIndicator(
                    color: ColorCode.buttonColor,
                  ),
                  overlayColor: Colors.black54,
                );

                Response response = await ProfileService().logout();

                Loader.hide();

                if (response.statusCode == 200) {
                  MixpanelService.track("User Logged Out", properties: {
                    "timestamp": DateTime.now().toIso8601String(),
                  });
                  StorageUtil.clearData();
                  Fluttertoast.showToast(msg: "Logout Successfully");
                  push(
                    context: context,
                    page: const WelComePage(),
                  );
                } else {
                  Fluttertoast.showToast(msg: "Something went to wrong");
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  // Image
                  Image.asset(ImageHelper.drawerLogoutIcon, height: 25),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      StringHelper.logout,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _ChallengeWidget extends StatelessWidget {
  const _ChallengeWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: ListTileTheme(
        dense: true,
        tileColor: Colors.transparent,
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          trailing: const SizedBox(),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          title: Row(
            children: [
              Image.asset(ImageHelper.drawerChallengeIcon, height: 23),

              const SizedBox(width: 10),
              const Text(
                StringHelper.challenges,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          children: [
            //vision
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.vision,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.vision,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Missions
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.mission,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.mission,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quiz
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.quiz,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.quiz,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Puzzle
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.puzzles,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.puzzles,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Riddle
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.riddles,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.riddles,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Jigyasa
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.jigyasa,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.jigyasa,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pragya
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(context: context, page: const SubjectListPage(
                    navName: StringHelper.pragya,
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.pragya,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardWidget extends StatelessWidget {
  final String coins;

  const _RewardWidget({required this.coins});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      width: 190,
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          trailing: const SizedBox(),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Image.asset(ImageHelper.drawerRewardIcon, height: 20),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  StringHelper.rewards,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          children: [
            // Coins
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(
                    context: context,
                    page: CoinsHistoryPage(totalCoin: coins),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.coins,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Friends
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(
                    context: context,
                    page: const FriendPage(),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.friends,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ranking
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: InkWell(
                onTap: () {
                  push(
                    context: context,
                    page: const HallOfFamePage(),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  children: [
                    // Image
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      StringHelper.ranking,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AskQueWidget extends StatelessWidget {
  const _AskQueWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
        Fluttertoast.showToast(msg: "Coming soon");
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerAskQueIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.askQuestion,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodMeterWidget extends StatelessWidget {
  const _MoodMeterWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
        Fluttertoast.showToast(msg: "Coming soon");
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerMoodMeterIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.moodMeter,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteFriendWidget extends StatelessWidget {
  final String name;

  const _InviteFriendWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String text = "Hello"
            "\nThis is $name"
            "\n\nI invite you to use this amazing learning platform which i am using called LIFEAPP"
            "\nPlease download the app from here and signup"
            "\n will look to connect you on the app!"
            "\n https://onelink.to/kf253d";
        Share.share(text);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerInviteIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.inviteAFriend,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermCondWidget extends StatelessWidget {
  const _TermCondWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse("https://life-lab.org/privacy-policy/"));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerTermPolicyIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.termNCondition,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaQWidget extends StatelessWidget {
  const _FaQWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        push(
          context: context,
          page: const FaqPage(),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerFaqIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.faq,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackWidget extends StatelessWidget {
  const _FeedbackWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse("feedback@lifelab.com"));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.asset(ImageHelper.drawerFeedbackIcon, height: 23),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              StringHelper.feedback,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
