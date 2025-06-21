import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/tool_mission_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';


class TeacherLevelListPage extends StatefulWidget {

  final String projectName;
  final String classId;
  final String sectionId;
  final String gradeId;
  final String subjectId;

  const TeacherLevelListPage({super.key, required this.projectName, required this.classId, required this.subjectId, required this.sectionId, required this.gradeId});

  @override
  State<TeacherLevelListPage> createState() => _TeacherLevelListPageState();
}

class _TeacherLevelListPageState extends State<TeacherLevelListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ToolProvider>(context, listen: false).getLevel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: widget.projectName,
      ),
      body: provider.level != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.level!.data!.laLevels!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            push(
              context: context,
              page: ToolMissionPage(
                projectName: widget.projectName,
                classId: widget.classId,
                subjectId: widget.subjectId,
                gradeId: widget.gradeId,
                sectionId: widget.sectionId,
                levelId: provider.level!.data!.laLevels![index].id!.toString(),
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
                  provider.level!.data!.laLevels![index].title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  provider.level!.data!.laLevels![index].description ?? "",
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
