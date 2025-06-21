import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/teacher/student_progress/presentations/pages/student_preogress_details_page.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';

import '../../../../common/helper/image_helper.dart';

class CommonStudentWidget extends StatelessWidget {
  final String sectionName;
  final int index;
  final StudentProgressProvider provider;

  const CommonStudentWidget({super.key, required this.sectionName, required this.index, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ]
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              provider.allStudentReportModel!.data!.student![index].user!.profileImage != null ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + provider.allStudentReportModel!.data!.student![index].user!.profileImage!),
              ) : const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(ImageHelper.profileImg),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.allStudentReportModel!.data!.student![index].user!.name ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    Text(
                      "Class: $sectionName",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      provider.allStudentReportModel!.data!.student![index].user!.school?.name ?? "",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${provider.allStudentReportModel!.data!.student![index].user!.school?.state ?? ""}, ${provider.allStudentReportModel!.data!.student![index].user!.school?.city ?? ""}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Details
                  InkWell(
                    onTap: () {
                      push(
                        context: context,
                        page: StudentProgressDetailsPage(index: index, provider: provider, sectionName: sectionName,),
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 30,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text(
                          "View detailed report",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Download
                  // const SizedBox(height: 10),
                  // InkWell(
                  //   onTap: () {
                  //     // TODO
                  //   },
                  //   splashColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   child: const Icon(
                  //     Icons.file_download_outlined,
                  //     color: Colors.blue,
                  //     size: 30,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    provider.allStudentReportModel!.data!.student![index].vision!.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Vision",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                height: 35,
                width: 1,
                color: Colors.black54,
              ),
              Column(
                children: [
                  Text(
                    provider.allStudentReportModel!.data!.student![index].mission!.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Mission",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              Container(
                height: 35,
                width: 1,
                color: Colors.black54,
              ),
              Column(
                children: [
                  Text(
                    provider.allStudentReportModel!.data!.student![index].quiz!.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Quiz",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              Container(
                height: 35,
                width: 1,
                color: Colors.black54,
              ),
              Column(
                children: [
                  Text(
                    provider.allStudentReportModel!.data!.student![index].puzzle!.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Puzzles",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              Container(
                height: 35,
                width: 1,
                color: Colors.black54,
              ),
              Column(
                children: [
                  Text(
                    provider.allStudentReportModel!.data!.student![index].coins!.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Coins",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
