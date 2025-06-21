import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

import '../widget/common_student_widget.dart';

class ClassroomDetailsPage extends StatefulWidget {
  final String gradeName;
  final String sectionName;
  final String gradeId;
  final String subjectName;

  const ClassroomDetailsPage({super.key, required this.gradeId,required this.gradeName,required this.sectionName, required this.subjectName});

  @override
  State<ClassroomDetailsPage> createState() => _ClassroomDetailsPageState();
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getClassStudent(widget.gradeId);
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
        // action: Padding(
        //   padding: const EdgeInsets.only(right: 15),
        //   child: CustomButton(
        //     height: 30,
        //     width: 100,
        //     name: StringHelper.download,
        //     onTap: () {
        //       // TODO
        //     },
        //   ),
        // ),
      ),
      body: provider.allStudentReportModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Text(
              "Class ${widget.gradeName} ${widget.sectionName}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),

            Text(
              "Subject : ${widget.subjectName}",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 5),
            if(provider.allStudentReportModel!.data != null) Text(
              "${provider.allStudentReportModel!.data!.student!.length} Student",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),
            if(provider.allStudentReportModel!.data != null) Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "${provider.allStudentReportModel!.data!.totalMission ?? ""}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Mission",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 35,
                  width: 1,
                  color: Colors.black54,
                ),
                Column(
                  children: [
                    Text(
                      "${provider.allStudentReportModel!.data!.totalQuiz ?? ""}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Quiz",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 35,
                  width: 1,
                  color: Colors.black54,
                ),
                Column(
                  children: [
                    Text(
                      "${provider.allStudentReportModel!.data!.totalPuzzle ?? ""}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Puzzles",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 35,
                  width: 1,
                  color: Colors.black54,
                ),
                Column(
                  children: [
                    Text(
                      "${provider.allStudentReportModel!.data!.totalCoins ?? ""}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Coins",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Classroom students",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 20),
            if(provider.allStudentReportModel!.data != null) ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: provider.allStudentReportModel!.data!.student!.length,
              itemBuilder: (context, index) => CommonStudentWidget(
                index: index,
                provider: provider,
                sectionName: widget.sectionName,
              ),
            ),
          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}
