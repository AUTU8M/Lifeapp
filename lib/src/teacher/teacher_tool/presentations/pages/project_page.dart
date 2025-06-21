import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/tool_subject_page.dart';
import 'package:lifelab3/src/teacher/vision/presentations/vision_list.dart';
import 'package:lifelab3/src/teacher/vision/providers/vision_provider.dart';
import 'package:provider/provider.dart';

class TeacherProjectPage extends StatelessWidget {
  final String name;
  final String sectionId;
  final String gradeId;
  final String classId;

  const TeacherProjectPage({
    super.key,
    required this.name,
    required this.classId,
    required this.gradeId,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, name: name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            // Vision Button with increased font size
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => VisionProvider(),
                        child: VisionPage(
                          navName: 'Vision',
                          subjectName: 'Subject Name',
                          sectionId: sectionId,
                          gradeId: gradeId,
                          classId: classId,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  "Vision",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Mission Button with increased font size
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                onPressed: () {
                  push(
                    context: context,
                    page: ToolSubjectListPage(
                      projectName: "Mission",
                      sectionId: sectionId,
                      gradeId: gradeId,
                      classId: classId,
                    ),
                  );
                },
                child: Text(
                  "Mission",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
  /*// Quiz
            const SizedBox(height: 20),
            CustomButton(
              name: "Quiz",
              height: 50,
              color: Colors.white,
              textColor: Colors.black,
              isShadow: true,
              onTap: () {
                push(
                  context: context,
                  page: ToolSubjectListPage(
                    projectName: "Quiz",
                    classId: classId,
                  ),
                );
              },
            ),

            // Riddle
            const SizedBox(height: 20),
            CustomButton(
              name: "Riddle",
              height: 50,
              color: Colors.white,
              textColor: Colors.black,
              isShadow: true,
              onTap: () {
                push(
                  context: context,
                  page: ToolSubjectListPage(
                    projectName: "Riddle",
                    classId: classId,
                  ),
                );
              },
            ),

            // Puzzle
            const SizedBox(height: 20),
            CustomButton(
              name: "Puzzle",
              height: 50,
              color: Colors.white,
              textColor: Colors.black,
              isShadow: true,
              onTap: () {
                push(
                  context: context,
                  page: ToolSubjectListPage(
                    projectName: "Puzzle",
                    classId: classId,
                  ),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}