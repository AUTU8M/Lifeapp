import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/download_subject_level_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/common_navigator.dart';


class TeacherSubjectGradeListPage extends StatelessWidget {

  final String subjectName;
  final String subjectId;
  final String name;

  const TeacherSubjectGradeListPage({super.key, required this.subjectName, required this.subjectId, required this.name});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: "$subjectName ${StringHelper.levels}",
      ),
      body: provider.levels != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
           push(
             context: context,
             page: DownloadSubjectLevel(
               subjectId: subjectId,
               levelId: "",
               name: name,
               gradeId: "${index+1}",
             ),
           );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorCode.levelListColor1,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grade ${index+1}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
