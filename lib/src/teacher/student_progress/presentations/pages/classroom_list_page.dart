import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/classroom_details_page.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

class ClassroomListPage extends StatefulWidget {
  const ClassroomListPage({super.key});

  @override
  State<ClassroomListPage> createState() => _ClassroomListPageState();
}

class _ClassroomListPageState extends State<ClassroomListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getTeacherGrade();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProgressProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.classroom,
      ),
      body: provider.teacherGradeSectionModel != null ? ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 50),
        itemCount: provider.teacherGradeSectionModel!.data!.teacherGrades!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            push(
              context: context,
              page: ClassroomDetailsPage(
                gradeId: provider.teacherGradeSectionModel!.data!.teacherGrades![index].id!.toString(),
                subjectName: provider.teacherGradeSectionModel!.data!.teacherGrades![index].subject!.title!,
                sectionName: provider.teacherGradeSectionModel!.data!.teacherGrades![index].section!.name!,
                gradeName: provider.teacherGradeSectionModel!.data!.teacherGrades![index].grade!.name!,
              ),
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1, 1),
                  spreadRadius: 2,
                  blurRadius: 5,
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Class ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].grade!.name!} ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].section!.name!} | ${provider.teacherGradeSectionModel!.data!.teacherGrades![index].subject!.title!}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Container(
                  height: 25,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      "View",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
