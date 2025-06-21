import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/class_students_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/custom_text_field.dart';

class AssignMissionPage extends StatelessWidget {

  final String img;
  final String missionId;
  final String sectionId;
  final String gradeId;
  final String subjectId;
  final String type;

  const AssignMissionPage({
    super.key,
    required this.img,
    required this.missionId,
    required this.sectionId,
    required this.gradeId,
    required this.subjectId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: "Assign Mission"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(imageUrl: ApiHelper.imgBaseUrl + img),
            ),

            // Date
            const SizedBox(height: 30),
            const Text(
              "Select the due date",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 5),
            CustomTextField(
              height: 45,
              readOnly: true,
              maxLines: 1,
              color: Colors.white,
              hintName: StringHelper.date,
              fieldController: provider.dateController,
              suffix: const Icon(
                Icons.date_range_outlined,
                color: Colors.black54,
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: provider.currentDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  provider.currentDate = picked;
                  provider.dateController.text =
                      "${picked.day}-${picked.month}-${picked.year}";
                  provider.notifyListeners();
                }
              },
            ),

            const SizedBox(height: 50),
            CustomButton(
              name: "Assign students",
              color: Colors.blue,
              height: 45,
              onTap: () {
                if (provider.dateController.text.isNotEmpty) {
                  push(
                    context: context,
                    page: ClassStudentPage(
                      subjectId: subjectId,
                      sectionId: sectionId,
                      missionId: missionId,
                      gradeId: gradeId,
                      type: type,
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: "Please select date");
                }
              },
            ),

            // const SizedBox(height: 20),
            // CustomButton(
            //   name: "Send the link on whatsapp",
            //   color: Colors.blue,
            //   height: 45,
            //   onTap: () {
            //     // TODO
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
