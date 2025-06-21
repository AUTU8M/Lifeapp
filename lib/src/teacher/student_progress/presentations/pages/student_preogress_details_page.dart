import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

class StudentProgressDetailsPage extends StatefulWidget {
  final String sectionName;
  final int index;
  final StudentProgressProvider provider;

  const StudentProgressDetailsPage({super.key, required this.sectionName, required this.index, required this.provider});

  @override
  State<StudentProgressDetailsPage> createState() => _StudentProgressDetailsPageState();
}

class _StudentProgressDetailsPageState extends State<StudentProgressDetailsPage> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProgressProvider>(context, listen: false).getAllStudentMissionList(userId: widget.provider.allStudentReportModel!.data!.student![widget.index].user!.id!.toString());
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProgressProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.yourStudent,
        action: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CustomButton(
            height: 30,
            width: 100,
            name: StringHelper.download,
            onTap: () {
              widget.provider.downloadImage(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: RepaintBoundary(
          key: widget.provider.studentDetailsGlobalKey,
          child: ColoredBox(
            color: provider.isImageProcessing?Colors.white:Colors.transparent,
            child: Column(
              children: [
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: widget.provider.allStudentReportModel!.data!.student![widget.index].user!.profileImage != null ? Image.network(ApiHelper.imgBaseUrl + widget.provider.allStudentReportModel!.data!.student![widget.index].user!.profileImage!) :Image.asset(
                    ImageHelper.profileIcon,
                    width: MediaQuery.of(context).size.width * .4,
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  widget.provider.allStudentReportModel!.data!.student![widget.index].user!.name ?? "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Text(
                  "Class: ${widget.sectionName}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                Text(
                  widget.provider.allStudentReportModel!.data!.student![widget.index].user!.school?.name ?? "",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${widget.provider.allStudentReportModel!.data!.student![widget.index].user!.school?.state ?? ""}, ${widget.provider.allStudentReportModel!.data!.student![widget.index].user!.school?.city ?? ""}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.provider.allStudentReportModel!.data!.student![widget.index].vision!.toString(),
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
                          widget.provider.allStudentReportModel!.data!.student![widget.index].mission!.toString(),
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
                          widget.provider.allStudentReportModel!.data!.student![widget.index].quiz!.toString(),
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
                          widget.provider.allStudentReportModel!.data!.student![widget.index].puzzle!.toString(),
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
                          widget.provider.allStudentReportModel!.data!.student![widget.index].coins!.toString(),
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

                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
                  itemCount: (provider.studentMissionsModel?.data ?? []).length,
                  itemBuilder: (context, index) => Container(
                    // height: 70,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5),
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
                        widget.provider.allStudentReportModel!.data!.student![widget.index].user!.profileImage != null
                            ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + widget.provider.allStudentReportModel!.data!.student![widget.index].user!.profileImage),
                        )
                            : const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(ImageHelper.profileIcon),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            provider.studentMissionsModel!.data![index].title ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Image.asset(
                          provider.studentMissionsModel!.data![index].approvedAt == null && provider.studentMissionsModel!.data![index].rejectedAt == null
                              ? ImageHelper.reviewIcon
                              : provider.studentMissionsModel!.data![index].rejectedAt != null
                              ? ImageHelper.rejectedIcon
                              : ImageHelper.completedIcon2,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
