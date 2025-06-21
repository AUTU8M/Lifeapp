import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_tool/presentations/pages/teacher_level_page.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/api_helper.dart';
import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/widgets/common_navigator.dart';


class ToolSubjectListPage extends StatefulWidget {

  final String projectName;
  final String sectionId;
  final String gradeId;
  final String classId;

  const ToolSubjectListPage({super.key, required this.projectName, required this.classId, required this.gradeId, required this.sectionId});

  @override
  State<ToolSubjectListPage> createState() => _ToolSubjectListPageState();
}

class _ToolSubjectListPageState extends State<ToolSubjectListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ToolProvider>(context, listen: false).getSubjectsData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: StringHelper.subjects),
      body: provider.subjectModel != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.subjectModel!.data!.subject!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            push(
              context: context,
              page: TeacherLevelListPage(
                projectName: widget.projectName,
                classId: widget.classId,
                gradeId: widget.gradeId,
                sectionId: widget.sectionId,
                subjectId: provider.subjectModel!.data!.subject![index].id!.toString(),
              ),
            );
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
                            provider.subjectModel!.data!.subject![index].heading!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                            maxLines: 3,
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
      ) : const LoadingWidget(),
    );
  }
}
