import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/student_submission_page.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/widget/common_track_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getTeacherMission();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProgressProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.project,
      ),
      body: provider.teacherMissionListModel != null ? ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
        itemCount: provider.teacherMissionListModel!.data!.missions!.data!.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CommonTrackWidget(
            name: provider.teacherMissionListModel!.data!.missions!.data![index].title ?? "",
            onTap: () {
              push(
                context: context,
                page: StudentSubmissionPage(
                  missionId: provider.teacherMissionListModel!.data!.missions!.data![index].id!.toString(),
                ),
              );
            },
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
