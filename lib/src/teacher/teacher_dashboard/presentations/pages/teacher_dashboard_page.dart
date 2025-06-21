import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/widgets/teacher_resource_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/widgets/teacher_tool_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../../utils/storage_utils.dart';
import '../widgets/teacher_drawer.dart';
import '../widgets/teacher_home_app_bar.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TeacherDashboardProvider>(context,listen: false).getDashboardData();
      Provider.of<TeacherDashboardProvider>(context,listen: false).getSubjectsData();
      Provider.of<DashboardProvider>(context,listen: false).checkSubscription();
      Provider.of<DashboardProvider>(context,listen: false).storeToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      drawer: const TeacherDrawerView(),
      body: provider.dashboardModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            TeacherHomeAppBar(
              name: provider.dashboardModel!.data!.user!.name!,
              img: provider.dashboardModel!.data!.user!.profileImage != null ? ApiHelper.imgBaseUrl + provider.dashboardModel!.data!.user!.profileImage! : null,
            ),

            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  StringHelper.teacherResources,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TeacherResourceWidget(
                    //   name: StringHelper.competencies,
                    //   img: ImageHelper.competencies,
                    //   isSubscribe: true,
                    // ),
                    TeacherResourceWidget(
                      name: StringHelper.lifeLabDemoModelLesson,
                      img: ImageHelper.demoModelIcon,
                      isSubscribe: StorageUtil.getBool(StringHelper.isTeacherLifeLabDemo),
                    ),
                    const TeacherResourceWidget(
                      name: StringHelper.conceptCartoons,
                      img: ImageHelper.conceptCartoon,
                      isSubscribe: true,
                    ),
                    TeacherResourceWidget(
                      name: StringHelper.jigyasaSelfDiy,
                      img: ImageHelper.jigyasaLessonIcon,
                      isSubscribe: StorageUtil.getBool(StringHelper.isTeacherJigyasa),
                    ),
                    TeacherResourceWidget(
                      name: StringHelper.pragyaDIYActivity,
                      img: ImageHelper.pragyaLessonIcon,
                      isSubscribe: StorageUtil.getBool(StringHelper.isTeacherPragya),
                    ),

                    // TeacherResourceWidget(
                    //   name: StringHelper.assesments,
                    //   img: ImageHelper.assesments,
                    //   isSubscribe: true,
                    // ),
                    // TeacherResourceWidget(
                    //   name: StringHelper.worksheet,
                    //   img: ImageHelper.worksheet,
                    //   isSubscribe: true,
                    // ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TeacherResourceWidget(
                    //   name: StringHelper.lifeLabDemoModelLesson,
                    //   img: ImageHelper.book,
                    //   isSubscribe: StorageUtil.getBool(StringHelper.isTeacherLifeLabDemo),
                    // ),
                    // TeacherResourceWidget(
                    //   name: StringHelper.jigyasaSelfDiy,
                    //   img: ImageHelper.book,
                    //   isSubscribe: StorageUtil.getBool(StringHelper.isTeacherJigyasa),
                    // ),
                    // TeacherResourceWidget(
                    //   name: StringHelper.pragyaDIYActivity,
                    //   img: ImageHelper.book,
                    //   isSubscribe: StorageUtil.getBool(StringHelper.isTeacherPragya),
                    // ),
                    TeacherResourceWidget(
                      name: StringHelper.lifeLabActivitiesPlan,
                      img: ImageHelper.lessonPlanIcon,
                      isSubscribe: StorageUtil.getBool(StringHelper.isTeacherLesson),
                    ),
                  ],
                ),
              ],
            ),

            // Teacher Tool
            const SizedBox(height: 20),
            const TeacherToolWidget(),

            // Explore Student
            // SizedBox(height: 20),
            // ExploreStudentWidget(),

            const SizedBox(height: 50),
          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}
