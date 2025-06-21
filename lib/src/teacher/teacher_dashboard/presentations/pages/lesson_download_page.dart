import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/lesson_plan_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/pdf_view_page.dart';

import '../../../../common/helper/api_helper.dart';
import '../../../../common/widgets/common_navigator.dart';


class LessonDownloadPage extends StatelessWidget {

  final LessonPlanModel model;

  const LessonDownloadPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, name: "Lesson Plan"),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: model.data!.laLessionPlans!.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1,1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  model.data!.laLessionPlans![index].title!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),

              // View
              InkWell(
                onTap: () {
                  push(
                    context: context,
                    page: PdfPage(
                      url: ApiHelper.imgBaseUrl + model.data!.laLessionPlans![index].document!.url!,
                      name: model.data!.laLessionPlans![index].title!,
                    ),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.visibility_rounded,
                  color: Colors.black54,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
