import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/home/presentations/pages/subscribe_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/cartoon_header_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/lesson_plan_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_subject_page.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/string_helper.dart';

class TeacherResourceWidget extends StatelessWidget {

  final String name;
  final String img;
  final bool isSubscribe;

  const TeacherResourceWidget({super.key,
    required this.name,
    required this.img,
    required this.isSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(name == StringHelper.conceptCartoons) {
          push(
            context: context,
            page: const CartoonHeaderPage(),
          );
        } else if(name == StringHelper.competencies || name == StringHelper.assesments || name == StringHelper.worksheet) {
          push(
            context: context,
            page: TeacherSubjectListPage(
              name: name,
            ),
          );
        } else {
          if(name == StringHelper.lifeLabDemoModelLesson && isSubscribe) {
            push(
              context: context,
              page: const LessonPlanPage(type: "1"),
            );
          } else if(name == StringHelper.jigyasaSelfDiy && isSubscribe) {
            push(
              context: context,
              page: const LessonPlanPage(type: "2"),
            );
          } else if(name == StringHelper.pragyaDIYActivity && isSubscribe) {
            push(
              context: context,
              page: const LessonPlanPage(type: "3"),
            );
          } else if(name == StringHelper.lifeLabActivitiesPlan && isSubscribe) {
            push(
              context: context,
              page: const LessonPlanPage(type: "4"),
            );
          } else {
            push(
              context: context,
              page: SubScribePage(type:  name == StringHelper.lifeLabDemoModelLesson ? "1"
                  : name == StringHelper.jigyasaSelfDiy ? "2"
                  : name == StringHelper.pragyaDIYActivity ? "3" : "4"),
            );
          }
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * .2,
                width: MediaQuery.of(context).size.width * .2,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black54)
                ),
                child: Center(
                  child: Image.asset(img),
                ),
              ),
              if(!isSubscribe) Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * .13,
                  decoration: const BoxDecoration(
                    color: ColorCode.buttonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      StringHelper.subscribe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
