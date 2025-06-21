
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/pdf_view_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';


class DownloadSubjectLevel extends StatefulWidget {

  final String subjectId;
  final String levelId;
  final String gradeId;
  final String name;

  const DownloadSubjectLevel(
      {super.key, required this.subjectId, required this.levelId, required this.name, required this.gradeId});

  @override
  State<DownloadSubjectLevel> createState() => _DownloadSubjectLevelState();
}

class _DownloadSubjectLevelState extends State<DownloadSubjectLevel> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Map<String, dynamic> body = {
        "la_subject_id": widget.subjectId,
        "la_level_id": widget.levelId,
      };

      Map<String, dynamic> body1 = {
        "la_subject_id": widget.subjectId,
        "la_grade_id": widget.gradeId,
      };

      if(widget.name == StringHelper.competencies) {
        Provider.of<TeacherDashboardProvider>(context, listen: false)
            .getCompetency(body: body);
      } else if(widget.name == StringHelper.conceptCartoons) {
        Provider.of<TeacherDashboardProvider>(context, listen: false)
            .getConceptCartoon(body: body);
      } else if(widget.name == StringHelper.assesments) {
        Provider.of<TeacherDashboardProvider>(context, listen: false)
            .getAssessment(body: body1);
      } else if(widget.name == StringHelper.worksheet) {
        Provider.of<TeacherDashboardProvider>(context, listen: false)
            .getWorkSheet(body: body1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: widget.name),
      body: widget.name == StringHelper.competencies && provider.competenciesModel != null ? _list1(provider)
          : widget.name == StringHelper.conceptCartoons && provider.cartoonModel != null ? _list2(provider)
          : widget.name == StringHelper.assesments && provider.assessmentModel != null ? _list3(provider)
          : widget.name == StringHelper.worksheet && provider.workSheetModel != null ? _list4(provider)
          : const LoadingWidget(),
    );
  }

  Widget _list1(TeacherDashboardProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount: provider.competenciesModel!.data!.laCompetenies!.data!.length,
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
          Text(
            provider.competenciesModel!.data!.laCompetenies!.data![index].title!,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),

          // View
          const Spacer(),
          InkWell(
            onTap: () {
              push(
                context: context,
                page: PdfPage(
                  url: ApiHelper.imgBaseUrl + provider.competenciesModel!.data!.laCompetenies!.data![index].document!.url!,
                  name: provider.competenciesModel!.data!.laCompetenies!.data![index].title!,
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
  );

  Widget _list2(TeacherDashboardProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount: provider.cartoonModel!.data!.laConceptCartoons!.data!.length,
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
              provider.cartoonModel!.data!.laConceptCartoons!.data![index].title!,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              push(
                context: context,
                page: PdfPage(
                  url: ApiHelper.imgBaseUrl + provider.cartoonModel!.data!.laConceptCartoons!.data![index].document!.url!,
                  name: provider.cartoonModel!.data!.laConceptCartoons!.data![index].title!,
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
  );

  Widget _list3(TeacherDashboardProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount: provider.assessmentModel!.data!.laAssessments!.data!.length,
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
          Text(
            provider.assessmentModel!.data!.laAssessments!.data![index].title!,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),

          // View
          const Spacer(),
          InkWell(
            onTap: () {
              push(
                context: context,
                page: PdfPage(
                  url: ApiHelper.imgBaseUrl + provider.assessmentModel!.data!.laAssessments!.data![index].document!.url!,
                  name: provider.assessmentModel!.data!.laAssessments!.data![index].title!,
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
  );

  Widget _list4(TeacherDashboardProvider provider) => ListView.builder(
    shrinkWrap: true,
    itemCount: provider.workSheetModel!.data!.laWorkSheets!.data!.length,
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
          Text(
            provider.workSheetModel!.data!.laWorkSheets!.data![index].title!,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),

          // View
          const Spacer(),
          InkWell(
            onTap: () {
              push(
                context: context,
                page: PdfPage(
                  url: ApiHelper.imgBaseUrl + provider.workSheetModel!.data!.laWorkSheets!.data![index].document!.url!,
                  name: provider.workSheetModel!.data!.laWorkSheets!.data![index].title!,
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
  );

}
