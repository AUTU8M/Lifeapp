import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/widget/common_student_widget.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getAllStudent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProgressProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.yourStudent,
      ),
      body: provider.allStudentReportModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            provider.allStudentReportModel!.data != null ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: provider.allStudentReportModel!.data!.student!.length,
              itemBuilder: (context, index) => CommonStudentWidget(
                index: index,
                provider: provider,
                sectionName: provider.allStudentReportModel!.data!.student![index].user?.section?.name ?? "",
              ),
            ) : const Center(
              child: Text(
                "No Student Available",
                style: TextStyle(
                  color: ColorCode.textBlackColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}
