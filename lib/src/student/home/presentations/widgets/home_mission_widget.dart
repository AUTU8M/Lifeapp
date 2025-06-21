import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/home/models/dashboard_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';
import '../../../../common/widgets/common_navigator.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../mission/presentations/pages/submit_mission_page.dart';

class HomeMissionWidget extends StatelessWidget {
  final DashboardModel dashboardModel;

  const HomeMissionWidget({super.key, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dashboardModel.data!.user!.baloonCarMission!.submission != null &&
            dashboardModel
                    .data!.user!.baloonCarMission!.submission!.approvedAt !=
                null) {
          Fluttertoast.showToast(msg: "Already Completed");
        } else if (dashboardModel.data!.user!.baloonCarMission!.submission !=
                null &&
            dashboardModel
                    .data!.user!.baloonCarMission!.submission!.approvedAt ==
                null &&
            dashboardModel
                    .data!.user!.baloonCarMission!.submission!.rejectedAt ==
                null) {
          Fluttertoast.showToast(msg: "In review");
        } else if (dashboardModel.data!.user!.baloonCarMission!.submission !=
                null &&
            dashboardModel
                    .data!.user!.baloonCarMission!.submission!.rejectedAt !=
                null) {
          MissionDatum model = MissionDatum.fromJson(
              dashboardModel.data!.user!.baloonCarMission!.toJson());
          push(
            context: context,
            page: SubmitMissionPage(mission: model),
          );
        } else {
          MissionDatum model = MissionDatum.fromJson(
              dashboardModel.data!.user!.baloonCarMission!.toJson());
          push(
            context: context,
            page: SubmitMissionPage(mission: model),
          );
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/bce.png"),
          Positioned(
            bottom: 10,
            child: CustomButton(
              name: dashboardModel.data!.user!.baloonCarMission!.submission !=
                          null &&
                      dashboardModel.data!.user!.baloonCarMission!.submission!
                              .approvedAt !=
                          null
                  ? "Completed"
                  : dashboardModel.data!.user!.baloonCarMission!.submission !=
                              null &&
                          dashboardModel.data!.user!.baloonCarMission!
                                  .submission!.approvedAt ==
                              null &&
                          dashboardModel.data!.user!.baloonCarMission!
                                  .submission!.rejectedAt ==
                              null
                      ? "In review"
                      : dashboardModel.data!.user!.baloonCarMission!
                                      .submission !=
                                  null &&
                              dashboardModel.data!.user!.baloonCarMission!
                                      .submission!.rejectedAt !=
                                  null
                          ? "Rejected"
                          : "Start",
              height: 40,
              width: MediaQuery.of(context).size.width - 60,
              color: Colors.white,
              textColor: Colors.blue,
              onTap: () {
                if (dashboardModel.data!.user!.baloonCarMission!.submission !=
                        null &&
                    dashboardModel.data!.user!.baloonCarMission!.submission!
                            .approvedAt !=
                        null) {
                  Fluttertoast.showToast(msg: "Already Completed");
                } else if (dashboardModel
                            .data!.user!.baloonCarMission!.submission !=
                        null &&
                    dashboardModel.data!.user!.baloonCarMission!.submission!
                            .approvedAt ==
                        null &&
                    dashboardModel.data!.user!.baloonCarMission!.submission!
                            .rejectedAt ==
                        null) {
                  Fluttertoast.showToast(msg: "In review");
                } else if (dashboardModel
                            .data!.user!.baloonCarMission!.submission !=
                        null &&
                    dashboardModel.data!.user!.baloonCarMission!.submission!
                            .rejectedAt !=
                        null) {
                  MissionDatum model = MissionDatum.fromJson(
                      dashboardModel.data!.user!.baloonCarMission!.toJson());
                  push(
                    context: context,
                    page: SubmitMissionPage(mission: model),
                  );
                } else {
                  MissionDatum model = MissionDatum.fromJson(
                      dashboardModel.data!.user!.baloonCarMission!.toJson());
                  push(
                    context: context,
                    page: SubmitMissionPage(mission: model),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

// Widget _car() => Container(
//   width: MediaQuery.of(context).size.width,
//   padding: const EdgeInsets.all(15),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(15),
//     color: const Color(0xffFEE598),
//   ),
//   child: Column(
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.network(
//             ApiHelper.imgBaseUrl + dashboardModel.data!.user!.baloonCarMission!.image!.url!,
//             width: MediaQuery.of(context).size.width * .3,
//           ),
//           RichText(
//             text: TextSpan(
//               text: dashboardModel.data!.user!.baloonCarMission!.title ?? '',
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//         ],
//       ),
//       CustomButton(
//         name: dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.approvedAt != null
//             ? "Completed"
//             : dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.approvedAt == null && dashboardModel.data!.user!.baloonCarMission!.submission!.rejectedAt == null
//             ? "In review"
//             : dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.rejectedAt != null
//             ? "Rejected"
//             : "Start",
//         height: 40,
//         width: MediaQuery.of(context).size.width * .7,
//         color: Colors.blue,
//         onTap: () {
//           if(dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.approvedAt != null) {
//             Fluttertoast.showToast(msg: "Already Completed");
//           } else  if(dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.approvedAt == null && dashboardModel.data!.user!.baloonCarMission!.submission!.rejectedAt == null) {
//             Fluttertoast.showToast(msg: "In review");
//           } else if(dashboardModel.data!.user!.baloonCarMission!.submission != null && dashboardModel.data!.user!.baloonCarMission!.submission!.rejectedAt != null) {
//             MissionDatum model = MissionDatum.fromJson(dashboardModel.data!.user!.baloonCarMission!.toJson());
//             push(
//               context: context,
//               page: SubmitMissionPage(mission: model),
//             );
//           } else {
//             MissionDatum model = MissionDatum.fromJson(dashboardModel.data!.user!.baloonCarMission!.toJson());
//             push(
//               context: context,
//               page: SubmitMissionPage(mission: model),
//             );
//           }
//
//
//         },
//       ),
//     ],
//   ),
// );
}
