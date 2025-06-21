import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/common_appbar.dart';

class TeacherMissionSubmissionPage extends StatelessWidget {

  final int missionIndex;
  final bool missionStatus;
  final String missionId;

  const TeacherMissionSubmissionPage({super.key, required this.missionIndex, required this.missionStatus, required this.missionId});

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
            "Total ${provider.teacherMissionParticipantModel!.data!.data!.length}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            const SizedBox(height: 30),
            Row(
              children: [
                provider.teacherMissionParticipantModel!.data!.data![missionIndex].user!.profileImage != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + provider.teacherMissionParticipantModel!.data!.data![missionIndex].user!.profileImage!),
                      )
                    : const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(ImageHelper.profileIcon),
                      ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        provider.teacherMissionParticipantModel!.data!.data![missionIndex].user!.name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      "+91 ${provider.teacherMissionParticipantModel!.data!.data![missionIndex].user!.mobileNo!}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        provider.teacherMissionParticipantModel!.data!.data![missionIndex].user!.school!.name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Description
            const SizedBox(height: 30),
            if(provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission !=null)Text("Description : ${provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission!.description ?? ""}"),

            // Image
            if(provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission !=null) const SizedBox(height: 20),
            if(provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission !=null)Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(ApiHelper.imgBaseUrl + provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission!.media!.url!),
              ),
            ),

            // Approve
            if(missionStatus) const SizedBox(height: 40),
            if(missionStatus) CustomButton(
              name: "Approve",
              color: Colors.blue,
              height: 45,
              onTap: () {
                provider.submitApproveReject(
                  status: 1,
                  comment: "Approve",
                  studentId: provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission!.id!.toString(),
                  context: context,
                  missionId: missionId,
                );
              },
            ),

            // Reject
            if(missionStatus) const SizedBox(height: 20),
            if(missionStatus) CustomButton(
              name: "Reject",
              color: Colors.black26,
              height: 45,
              textColor: Colors.black,
              onTap: () {
                provider.submitApproveReject(
                  status: 0,
                  comment: "Reject",
                  studentId: provider.teacherMissionParticipantModel!.data!.data![missionIndex].submission!.id!.toString(),
                  context: context,
                  missionId: missionId,
                );
              },
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
