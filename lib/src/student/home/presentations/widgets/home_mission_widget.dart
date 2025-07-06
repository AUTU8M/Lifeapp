import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/home/models/dashboard_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';
import '../../../../common/widgets/common_navigator.dart';
import '../../../mission/presentations/pages/submit_mission_page.dart';

class HomeMissionWidget extends StatelessWidget {
  final DashboardModel dashboardModel;
  const HomeMissionWidget({super.key, required this.dashboardModel});
  String getButtonText() {
    final submission = dashboardModel.data!.user!.baloonCarMission!.submission;
    if (submission != null && submission.approvedAt != null) {
      return "Completed";
    } else if (submission != null &&
        submission.approvedAt == null &&
        submission.rejectedAt == null) {
      return "In Review";
    } else if (submission != null && submission.rejectedAt != null) {
      return "Rejected";
    } else {
      return "Start";
    }
  }
  @override
  Widget build(BuildContext context) {
    final submission = dashboardModel.data!.user!.baloonCarMission!.submission;

    void _handleTap() {
      if (submission != null && submission.approvedAt != null) {
        Fluttertoast.showToast(msg: "Already Completed");
      } else if (submission != null &&
          submission.approvedAt == null &&
          submission.rejectedAt == null) {
        Fluttertoast.showToast(msg: "In review");
      } else {
        final model = MissionDatum.fromJson(
            dashboardModel.data!.user!.baloonCarMission!.toJson());
        push(context: context, page: SubmitMissionPage(mission: model));
      }
    }
    return InkWell(
      onTap: _handleTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          // --- Background image -------------------------------------------------
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/images/gappu_bobo_1.png",
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),

          // --- Left-to-right dark overlay ---------------------------------------
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6), // bottom
                  Colors.transparent,            // top
                ],
              ),

            ),
          ),

          // --- Bottom row with text + button ------------------------------------
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text block (all white)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Daily Challenges Await",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Compete & climb the leaderboard today",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action button with border
                // 2️⃣  Then swap only the child of the ElevatedButton:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                  onPressed: _handleTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getButtonText()),
                      if (getButtonText() == "Start") ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}