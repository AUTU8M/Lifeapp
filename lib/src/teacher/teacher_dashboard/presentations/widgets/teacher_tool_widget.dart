import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/students_progress_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/teacher_class_page.dart';

import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';

class TeacherToolWidget extends StatelessWidget {
  const TeacherToolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringHelper.teacherTool,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff0092E4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .55,
                        child: const Text(
                          StringHelper.teacherToolMsg,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .55,
                        child: const Text(
                          "know more...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          push(
                            context: context,
                            page: const TeacherClassPage(),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .5,
                          decoration: BoxDecoration(
                            color: const Color(0xff00659D),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              StringHelper.startPBLClass,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    ImageHelper.teacherIcon,
                    width: MediaQuery.of(context).size.width * .23,
                  ),
                ],
              ),

            ],
          ),
        ),

        const SizedBox(height: 20),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFF7FAD),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Positioned(
                top: 25,
                left: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: const Text(
                    StringHelper.teacherToolMsg2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 22,
                left: 20,
                child: InkWell(
                  onTap: () {
                    push(
                      context: context,
                      page: const StudentProgressPage(),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: const Color(0xffCB1255),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child:  const Text(
                      StringHelper.trackStudentProgress,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Container(
                  alignment: Alignment.topRight,
                  height: 190,
                  child: Image.asset(
                    ImageHelper.boboIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
