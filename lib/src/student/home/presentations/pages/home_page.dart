import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/home_mission_widget.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/helper/color_code.dart';
import '../widgets/explore_challenges_widget.dart';
import '../widgets/explore_subjects_widget.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/invire_friend_widget.dart';
import '../widgets/mentor_connect_widget.dart';
import '../widgets/reward_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String appUrl = "";

  bool isAppUpdate = false;

  void checkStoreAppVersion() async {
    final status = await NewVersionPlus(
      androidId: "com.life.lab",
      iOSId: "com.hejtech.lifelab",
    ).getVersionStatus();
    isAppUpdate = status?.canUpdate ?? false;
    appUrl = status?.appStoreLink ?? "";
    debugPrint("Version: ${status?.canUpdate ?? false}");
    setState(() {

    });
    if(isAppUpdate) {
      showMsgDialog();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkStoreAppVersion();
      Provider.of<DashboardProvider>(context, listen: false).storeToken();
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Provider.of<DashboardProvider>(context, listen: false).getSubjectsData();
      Provider.of<DashboardProvider>(context, listen: false).checkSubscription();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      drawer: provider.dashboardModel != null ? DrawerView(
        coin: provider.dashboardModel!.data!.user!.earnCoins!.toString(),
        name: provider.dashboardModel!.data!.user!.name ?? "",
      ) : null,
      body: provider.dashboardModel != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  HomeAppBar(
                    name: provider.dashboardModel!.data!.user!.name ?? "",
                    img: provider.dashboardModel!.data!.user!.imagePath,
                  ),

                  // if(isAppUpdate) AppUpdateWidget(appUrl: appUrl),

                  const SizedBox(height: 30),
                  RewardsWidget(
                    coin: provider.dashboardModel!.data!.user!.earnCoins!.toString(),
                    friends: provider.dashboardModel!.data!.user!.friends!.toString(),
                    ranking: provider.dashboardModel!.data!.user!.userRank!.toString(),
                  ),

                  const SizedBox(height: 30),
                  if(provider.dashboardModel != null) HomeMissionWidget(dashboardModel: provider.dashboardModel!),

                  const SizedBox(height: 20),
                  if(provider.subjectModel != null) ExploreSubjectsWidget(
                    subjects: provider.subjectModel!.data!.subject!,
                  ),

                  const SizedBox(height: 20),
                  const ExploreChallengesWidget(),
                  const SizedBox(height: 30),
                  MentorConnectWidget(),
                  // const SizedBox(height: 30),
                  // const AskQuestionWidget(),
                  // const SizedBox(height: 30),
                  // const MoodMeterWidget(),
                  const SizedBox(height: 30),
                  InviteFriendWidget(name: provider.dashboardModel!.data!.user!.name!),
                  const SizedBox(height: 80),
                ],
              ),
            )
          : const LoadingWidget(),
    );
  }

  void showMsgDialog() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 200,
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "App Update Available",
                    style: TextStyle(
                      color: ColorCode.textBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "A new version of the app is available",
                    style: TextStyle(
                      color: ColorCode.grey,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      if(Platform.isAndroid) {
                        launch(appUrl);
                      } else {
                        launchUrl(Uri.parse(appUrl));
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: ColorCode.buttonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
