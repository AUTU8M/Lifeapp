import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/project_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:provider/provider.dart';

class TeacherClassPage extends StatefulWidget {
  const TeacherClassPage({super.key});

  @override
  State<TeacherClassPage> createState() => _TeacherClassPageState();
}

class _TeacherClassPageState extends State<TeacherClassPage> {

  @override
  void initState() {
    Provider.of<ToolProvider>(context, listen: false).getTeacherGrade();
    Provider.of<ToolProvider>(context, listen: false).getLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: "Your classroom"),
      body: provider.teacherGradeSectionModel != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.teacherGradeSectionModel!.data!.teacherGrades!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            push(
              context: context,
              page: TeacherProjectPage(
                name: "Class ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].grade!.name!} ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].section!.name!}",
                gradeId: provider.teacherGradeSectionModel!.data!.teacherGrades![index].grade!.id!.toString(),
                classId: provider.teacherGradeSectionModel!.data!.teacherGrades![index].id!.toString(),
                sectionId: provider.teacherGradeSectionModel!.data!.teacherGrades![index].section!.id.toString(),
              ),
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 1,
                )
              ]
            ),
            child: Text(
              "Class ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].grade!.name!} ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].section!.name!}",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
