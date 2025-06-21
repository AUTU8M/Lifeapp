import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';
import 'package:lifelab3/src/welcome/presentation/page/welcome_page.dart';

import '../../../student_progress/presentations/pages/students_progress_page.dart';
import '../../../teacher_tool/presentations/pages/teacher_class_page.dart';
import '../pages/cartoon_header_page.dart';
import '../pages/teacher_subject_page.dart';


class TeacherDrawerView extends StatelessWidget {
  const TeacherDrawerView({super.key});

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
            SizedBox(
              width: 250,
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
                        StringHelper.teacherResources,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    // Missions
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 8),
                      child: InkWell(
                        onTap: () {
                          push(
                            context: context,
                            page: const TeacherSubjectListPage(
                              name: StringHelper.competencies,
                            ),
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
                              StringHelper.competencies,
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

                    // Concept Cartton
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 8),
                      child: InkWell(
                        onTap: () {
                          push(
                            context: context,
                            page: const CartoonHeaderPage(),
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
                              StringHelper.conceptCartoons,
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
                          push(
                            context: context,
                            page: const TeacherSubjectListPage(
                              name: StringHelper.assesments,
                            ),
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
                              StringHelper.assesments,
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
                          push(
                            context: context,
                            page: const TeacherSubjectListPage(
                              name: StringHelper.worksheet,
                            ),
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
                              StringHelper.worksheet,
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
            ),

            SizedBox(
              width: 250,
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
                      Image.asset(ImageHelper.drawerRewardIcon, height: 23),

                      const SizedBox(width: 10),
                      const Text(
                        StringHelper.teacherTool,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
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
                            page: const TeacherClassPage(),
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
                              StringHelper.projectBasedLearning,
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
                            page: const StudentProgressPage(),
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
                              StringHelper.studentTracker,
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
            ),

            // const SizedBox(height: 30),
            // const _DownloadWidget(),
            //
            // const SizedBox(height: 10),
            // const _ShopWidget(),
            //
            // const SizedBox(height: 10),
            // const _NotificationWidget(),


            // Version
            const SizedBox(height: 20),
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
            // Reset Pin
            const SizedBox(height: 50),
            InkWell(
              onTap: () {
                StorageUtil.clearData();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelComePage()), (route) => false);
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


class _DownloadWidget extends StatelessWidget {
  const _DownloadWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
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
              StringHelper.download,
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

class _ShopWidget extends StatelessWidget {
  const _ShopWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
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
              StringHelper.shop,
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

class _NotificationWidget extends StatelessWidget {
  const _NotificationWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
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
              StringHelper.notification,
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


