import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/assign_mission_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/loading_widget.dart';

class ToolMissionPage extends StatefulWidget {
  final String projectName;
  final String classId;
  final String subjectId;
  final String gradeId;
  final String sectionId;
  final String levelId;

  const ToolMissionPage(
      {super.key,
      required this.projectName,
      required this.classId,
      required this.subjectId,
      required this.gradeId,
      required this.sectionId,
      required this.levelId});

  @override
  State<ToolMissionPage> createState() => _ToolMissionPageState();
}

class _ToolMissionPageState extends State<ToolMissionPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.projectName == "Mission") {
        Map<String, dynamic> data = {
          "type": 1,
          "la_subject_id": widget.subjectId,
          "la_level_id": widget.levelId,
        };
        Provider.of<ToolProvider>(context, listen: false).getMission(data);
      } else if (widget.projectName == "Quiz") {
        Provider.of<ToolProvider>(context, listen: false).getTopic("2");
      } else if (widget.projectName == "Riddle") {
        Provider.of<ToolProvider>(context, listen: false).getTopic("3");
      } else if (widget.projectName == "Puzzle") {
        Provider.of<ToolProvider>(context, listen: false).getTopic("4");
      }
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
      body: widget.projectName == "Mission" && provider.missionListModel != null ? _mission(provider)
          : provider.topicModel != null ? _topic(provider)
          : const LoadingWidget(),
    );
  }

  Widget _mission(ToolProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount:
    provider.missionListModel!.data!.missions!.data!.length,
    itemBuilder: (context, index) => InkWell(
      onTap: () {
        push(
          context: context,
          page: AssignMissionPage(
            img: provider.missionListModel!.data!.missions!
                .data![index].image!.url!,
            missionId: provider
                .missionListModel!.data!.missions!.data![index].id!
                .toString(),
            subjectId: widget.subjectId,
            gradeId: widget.gradeId,
            sectionId: widget.sectionId,
            type: widget.projectName == "Mission"
                ? "1"
                : widget.projectName == "Quiz"
                ? "2"
                : widget.projectName == "Riddle"
                ? "3"
                : "4",
          ),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin:
        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorCode.levelListColor1,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.missionListModel!.data!.missions!.data![index]
                  .title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              provider.missionListModel!.data!.missions!.data![index]
                  .description!,
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
  );

  Widget _topic(ToolProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount: provider.topicModel!.data!.laTopics!.length,
    itemBuilder: (context, index) => InkWell(
      onTap: () {
        push(
          context: context,
          page: AssignMissionPage(
            img: provider.topicModel!.data!.laTopics![index].image!.url!,
            missionId: provider.topicModel!.data!.laTopics![index].id!.toString(),
            subjectId: widget.subjectId,
            gradeId: widget.gradeId,
            sectionId: widget.sectionId,
            type: widget.projectName == "Mission"
                ? "1"
                : widget.projectName == "Quiz"
                ? "2"
                : widget.projectName == "Riddle"
                ? "3"
                : "4",
          ),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin:
        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorCode.levelListColor1,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.missionListModel!.data!.missions!.data![index]
                  .title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              provider.missionListModel!.data!.missions!.data![index]
                  .description!,
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
  );
}
