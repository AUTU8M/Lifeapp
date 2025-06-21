import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/presentation/page/mentor_my_session_list_page.dart';

import '../../../../student/profile/services/profile_services.dart';
import '../../../../utils/storage_utils.dart';
import '../../../../welcome/presentation/page/welcome_page.dart';

class MentorDrawerView extends StatelessWidget {
  const MentorDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorCode.buttonColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            // About
            InkWell(
              onTap: () {
                // TODO
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  // Image
                  Image.asset(ImageHelper.drawerChallengeIcon, height: 25),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      StringHelper.about,
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

            // My Session
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                push(
                  context: context,
                  page: const MentorMySessionListPage(),
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  // Image
                  Image.asset(ImageHelper.drawerRewardIcon, height: 20),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      StringHelper.mySession,
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

            // Upcoming Session
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                // TODO
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  // Image
                  Image.asset(ImageHelper.drawerAskQueIcon, height: 20),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      StringHelper.upcomingSession,
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

            // Version
            const Spacer(),
            const Text(
              "${StringHelper.version} 3.0.0",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
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

