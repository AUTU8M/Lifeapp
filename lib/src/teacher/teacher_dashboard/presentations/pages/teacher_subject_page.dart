import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_subject_grade_list_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_subject_level_list_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/api_helper.dart';
import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/widgets/common_navigator.dart';


class TeacherSubjectListPage extends StatelessWidget {

  final String name;

  const TeacherSubjectListPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: StringHelper.subjects),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.subjectModel!.data!.subject!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            if(!provider.subjectModel!.data!.subject![index].couponCodeUnlock!) {
              if(name == StringHelper.competencies || name == StringHelper.conceptCartoons) {
                push(
                  context: context,
                  page: TeacherSubjectLevelListPage(
                    subjectName: provider.subjectModel!.data!.subject![index].title!,
                    subjectId: provider.subjectModel!.data!.subject![index].id!.toString(),
                    name: name,
                  ),
                );
              } else {
                push(
                  context: context,
                  page: TeacherSubjectGradeListPage(
                    subjectName: provider.subjectModel!.data!.subject![index].title!,
                    subjectId: provider.subjectModel!.data!.subject![index].id!.toString(),
                    name: name,
                  ),
                );
              }

            } else {
              Fluttertoast.showToast(msg: StringHelper.locked);
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                // height: 140,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorCode.subjectListColor1,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            provider.subjectModel!.data!.subject![index].title!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            provider.subjectModel!.data!.subject![index].heading ?? "",
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    provider.subjectModel!.data!.subject![index].image != null
                        ? Image.network(
                      ApiHelper.imgBaseUrl + provider.subjectModel!.data!.subject![index].image!.url!,
                      width: MediaQuery.of(context).size.width * .3,
                    )
                        : Image.asset(
                      ImageHelper.subjectListIcon,
                      width: MediaQuery.of(context).size.width * .3,
                    ),
                  ],
                ),
              ),
              if(provider.subjectModel!.data!.subject![index].couponCodeUnlock!) Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xffA7A7A7).withOpacity(.5),
                ),
                child: Center(
                  child: Image.asset(
                    ImageHelper.lockIcon,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
