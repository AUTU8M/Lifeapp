import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/teacher_mission_submission_page.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

class StudentSubmissionPage extends StatefulWidget {
  final String missionId;

  const StudentSubmissionPage({super.key, required this.missionId});

  @override
  State<StudentSubmissionPage> createState() => _StudentSubmissionPageState();
}

class _StudentSubmissionPageState extends State<StudentSubmissionPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getTeacherMissionParticipant(widget.missionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProgressProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.submission,
        action: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            "Total ${(provider.teacherMissionParticipantModel?.data?.data ?? []).length}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<StudentProgressProvider>(context, listen: false).getTeacherMissionParticipant(widget.missionId);
        },
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
          itemCount: (provider.teacherMissionParticipantModel?.data?.data ?? []).length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              if (provider.teacherMissionParticipantModel!.data!.data![index].submission != null) {
                push(
                  context: context,
                  page: TeacherMissionSubmissionPage(
                    missionIndex: index,
                    missionStatus: provider.teacherMissionParticipantModel!.data!.data![index].submission != null && provider.teacherMissionParticipantModel!.data!.data![index].submission!.approvedAt == null && provider.teacherMissionParticipantModel!.data!.data![index].submission!.rejectedAt == null,
                    missionId: widget.missionId,
                  ),
                );
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1, 1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: [
                  provider.teacherMissionParticipantModel!.data!.data![index].submission == null ?
                  provider.teacherMissionParticipantModel!.data!.data![index].user!.profileImage != null
                      ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + provider.teacherMissionParticipantModel!.data!.data![index].user!.profileImage!),
                  )
                      : const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(ImageHelper.profileIcon),
                  ):
                  provider.teacherMissionParticipantModel!.data!.data![index].submission!.media != null
                      ? CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + provider.teacherMissionParticipantModel!.data!.data![index].submission!.media!.url!),
                        )
                      : const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(ImageHelper.profileIcon),
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      provider.teacherMissionParticipantModel!.data!.data![index].user?.name ?? "",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        provider.teacherMissionParticipantModel!.data!.data![index].submission==null?
                            "Assigned" :
                        provider.teacherMissionParticipantModel!.data!.data![index].submission!.approvedAt != null
                            ? "Completed"
                            : provider.teacherMissionParticipantModel!.data!.data![index].submission!.approvedAt == null && provider.teacherMissionParticipantModel!.data!.data![index].submission!.rejectedAt == null
                                ? "Review"
                                : provider.teacherMissionParticipantModel!.data!.data![index].submission!.rejectedAt != null
                                    ? "Rejected"
                                    : "Not submitted",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        provider.teacherMissionParticipantModel!.data!.data![index].submission==null
                        ? ImageHelper.assesments
                            :provider.teacherMissionParticipantModel!.data!.data![index].submission!.approvedAt == null && provider.teacherMissionParticipantModel!.data!.data![index].submission!.rejectedAt == null
                            ? ImageHelper.reviewIcon
                            : provider.teacherMissionParticipantModel!.data!.data![index].submission!.rejectedAt != null
                                ? ImageHelper.rejectedIcon
                                : ImageHelper.completedIcon2,
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
