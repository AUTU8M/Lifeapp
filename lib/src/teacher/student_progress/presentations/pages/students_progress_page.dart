import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/classroom_list_page.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/project_list_page.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/student_list_page.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/widget/common_track_widget.dart';

class StudentProgressPage extends StatelessWidget {
  const StudentProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.trackStudentProgress,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            // Individual student
            CommonTrackWidget(
              name: StringHelper.individualStudent,
              onTap: () {
                push(
                  context: context,
                  page: const StudentListPage(),
                );
              },
            ),

            // classroom
            const SizedBox(height: 20),
            CommonTrackWidget(
              name: StringHelper.classroom,
              onTap: () {
                push(
                  context: context,
                  page: const ClassroomListPage(),
                );
              },
            ),

            // project
            const SizedBox(height: 20),
            CommonTrackWidget(
              name: StringHelper.project,
              onTap: () {
                push(
                  context: context,
                  page: const ProjectListPage(),
                );
              },
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
