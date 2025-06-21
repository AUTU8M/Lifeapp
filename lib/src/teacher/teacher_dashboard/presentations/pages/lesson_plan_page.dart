import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

class LessonPlanPage extends StatefulWidget {

  final String type;

  const LessonPlanPage({super.key, required this.type});

  @override
  State<LessonPlanPage> createState() => _LessonPlanPageState();
}

class _LessonPlanPageState extends State<LessonPlanPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TeacherDashboardProvider>(context, listen: false).clearLessonPlan();
      Provider.of<TeacherDashboardProvider>(context, listen: false).getBoard();
      Provider.of<TeacherDashboardProvider>(context, listen: false).getLanguage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: "Lesson Plan"),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Board
            // const Text(
            //   "Board",
            //   style: TextStyle(
            //     color: ColorCode.textBlackColor,
            //     fontWeight: FontWeight.w600,
            //     fontSize: 18,
            //   ),
            // ),
            // PopupMenuButton(
            //   offset: const Offset(0, 50),
            //   splashRadius: 0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15),
            //     side: const BorderSide(color: Colors.black12),
            //   ),
            //   surfaceTintColor: Colors.white,
            //   itemBuilder: (context) => provider.boardModel!.data!.boards!
            //       .map((e) => PopupMenuItem(
            //             padding: const EdgeInsets.only(left: 20, right: 20),
            //             onTap: () {
            //               provider.board = e.name!;
            //               provider.boardId = e.id!;
            //               provider.notifyListeners();
            //             },
            //             child: Text(
            //               e.name!,
            //               style: const TextStyle(
            //                 fontSize: 15,
            //                 color: Colors.black,
            //               ),
            //             ),
            //           ))
            //       .toList(),
            //   child: Container(
            //     height: 45,
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(left: 15, right: 15),
            //     alignment: Alignment.centerLeft,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         color: Colors.white,
            //         boxShadow: const [
            //           BoxShadow(
            //               color: Colors.black12,
            //               offset: Offset(1, 1),
            //               spreadRadius: 1,
            //               blurRadius: 1),
            //         ]),
            //     child: Text(
            //       provider.board,
            //       style: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),

            // Language
            const SizedBox(height: 20),
            const Text(
              "Language",
              style: TextStyle(
                color: ColorCode.textBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            PopupMenuButton(
              offset: const Offset(0, 50),
              splashRadius: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.black12),
              ),
              surfaceTintColor: Colors.white,
              itemBuilder: (context) => provider.languageModel!.data!.laLessionPlanLanguages!
                  .map((e) => PopupMenuItem(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        onTap: () {
                          provider.language = e.name!;
                          provider.languageId = e.id!;
                          provider.notifyListeners();
                        },
                        child: Text(
                          e.name!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ))
                  .toList(),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 1),
                    ]),
                child: Text(
                  provider.language,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Submit
            const Spacer(),
            CustomButton(
              height: 45,
              width: MediaQuery.of(context).size.width,
              name: StringHelper.submit,
              onTap: () {
                provider.submitPlan(context: context, type: widget.type);
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
