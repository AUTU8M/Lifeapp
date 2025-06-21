import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/provider/teacher_sign_up_provider.dart';

void teacherGradeListBottomSheet(BuildContext context, TeacherSignUpProvider provider, Map<String, dynamic> map) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      color: Colors.white,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringHelper.grade,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: provider.gradeList
                .map((e) => Column(
              children: [
                InkWell(
                  onTap: () {
                    provider.gradeController.text = e.toString();
                    map["la_grade_id"] = e.toString();
                    provider.notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Grade $e",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.black54, height: 0.2),
                const SizedBox(height: 10),
              ],
            ))
                .toList(),
          ),
          const SizedBox(height: 50),
        ],
      ),
    ),
  ),
);