import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/provider/teacher_sign_up_provider.dart';

void subjectListBottomSheet(BuildContext context, TeacherSignUpProvider provider, Map<String, dynamic> map) => showModalBottomSheet(
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
            StringHelper.subjects,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: provider.subjectModel!.data!.subject!
                .map((e) => Column(
              children: [
                InkWell(
                  onTap: () {
                    if(!provider.subjectIdList.contains(e.id)) {
                      provider.subjectController.text = e.title!;
                    }
                    map["subjects"] = e.id!.toString();
                    map["subject_name"] = e.title!.toString();
                    provider.notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        e.title!,
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