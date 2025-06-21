import 'package:flutter/material.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/presentations/widget/board_sheet.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/presentations/widget/grade_sheet.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/presentations/widget/section_sheet.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/presentations/widget/subject_sheet.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/provider/teacher_sign_up_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';

class TeacherSignUpPage extends StatefulWidget {
  final String contact;

  const TeacherSignUpPage({super.key, required this.contact});

  @override
  State<TeacherSignUpPage> createState() => _TeacherSignUpPageState();
}

class _TeacherSignUpPageState extends State<TeacherSignUpPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TeacherSignUpProvider>(context, listen: false)
          .getSchoolList();
      Provider.of<TeacherSignUpProvider>(context, listen: false)
          .getStateCityList();
      Provider.of<TeacherSignUpProvider>(context, listen: false)
          .getSectionList();
      Provider.of<TeacherSignUpProvider>(context, listen: false).getBoard();
      Provider.of<TeacherSignUpProvider>(context, listen: false).subjects();
      Provider.of<TeacherSignUpProvider>(context, listen: false)
          .gradeMapList
          .clear();
      Provider.of<TeacherSignUpProvider>(context, listen: false)
          .gradeMapList
          .add({
        "la_grade_id": "",
        "la_section_id": "",
        "subjects": "",
        "la_section_name": "",
        "subject_name": ""
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherSignUpProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(ImageHelper.gappuBoboImg1),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  // Teacher Name
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Teacher Name",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: false,
                        color: Colors.white,
                        fieldController: provider.teacherNameController,
                        hintName: "Teacher Name",
                      ),
                    ],
                  ),

                  // School Name
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "School Code",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          // School Name
                          const SizedBox(height: 20),
                          Expanded(
                            child: CustomTextField(
                              readOnly: false,
                              color: Colors.white,
                              fieldController: provider.schoolCodeController,
                              hintName: "Enter school code",
                              onChange: (val) {
                                setState(() {
                                  provider.isSchoolCodeValid = false;
                                });
                              },
                            ),
                          ),

                          if (!provider.isSchoolCodeValid)
                            TextButton(
                              onPressed: () {
                                provider.verifySchoolCode(context);
                              },
                              child: const Text(
                                "verify",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  if (provider.isSchoolCodeValid)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: RichText(
                        text: TextSpan(
                          text: provider.schoolNameController.text,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  " ,${provider.stateController.text}, ${provider.cityController.text}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ...provider.gradeMapList
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                // Grade
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      StringHelper.grade,
                                      style: TextStyle(
                                        color: ColorCode.textBlackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      readOnly: true,
                                      width: 50,
                                      color: Colors.white,
                                      fieldController: TextEditingController(
                                          text: e["la_grade_id"]),
                                      hintName: StringHelper.grade,
                                      onTap: () {
                                        teacherGradeListBottomSheet(
                                            context, provider, e);
                                      },
                                    ),
                                  ],
                                ),

                                // Section
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        StringHelper.section,
                                        style: TextStyle(
                                          color: ColorCode.textBlackColor,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        readOnly: true,
                                        // width: 50,
                                        color: Colors.white,
                                        fieldController: TextEditingController(
                                            text: e["la_section_name"]),
                                        hintName: StringHelper.section,
                                        maxLines: 1,
                                        onTap: () {
                                          teacherSectionListBottomSheet(
                                              context, provider, e);
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Subject
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Subject",
                                      style: TextStyle(
                                        color: ColorCode.textBlackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      readOnly: true,
                                      width: MediaQuery.of(context).size.width -
                                          180,
                                      color: Colors.white,
                                      fieldController: TextEditingController(
                                          text: e["subject_name"]),
                                      hintName: "Subject",
                                      onTap: () {
                                        subjectListBottomSheet(
                                            context, provider, e);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      InkWell(
                        onTap: () {
                          provider.gradeMapList.add({
                            "la_grade_id": "",
                            "la_section_id": "",
                            "subjects": "",
                            "la_section_name": "",
                            "subject_name": ""
                          });
                          provider.notifyListeners();
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              "Add +",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Board
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Board",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.boardNameController,
                        hintName: "Board",
                        onTap: () {
                          boardListBottomSheet(context, provider);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Submit
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: CustomButton(
                name: StringHelper.submit,
                height: 50,
                onTap: () {
                  provider.registerStudent(context, widget.contact);
                },
              ),
            ),

            const SizedBox(height: 70),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(
                  StringHelper.aLifeLabProduct,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
