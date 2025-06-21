import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/download_subject_level_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/common_navigator.dart';


class TeacherSubjectLevelListPage extends StatefulWidget {

  final String subjectName;
  final String subjectId;
  final String name;

  const TeacherSubjectLevelListPage({super.key, required this.subjectName, required this.subjectId, required this.name});

  @override
  State<TeacherSubjectLevelListPage> createState() => _TeacherSubjectLevelListPage();
}

class _TeacherSubjectLevelListPage extends State<TeacherSubjectLevelListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TeacherDashboardProvider>(context, listen: false).getLevel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: "${widget.subjectName} ${StringHelper.levels}",
      ),
      body: provider.levels != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.levels!.data!.laLevels!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
           push(
             context: context,
             page: DownloadSubjectLevel(
               subjectId: widget.subjectId,
               levelId: provider.levels!.data!.laLevels![index].id!.toString(),
               name: widget.name,
               gradeId: "",
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
                  provider.levels!.data!.laLevels![index].title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  provider.levels!.data!.laLevels![index].description ?? "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
