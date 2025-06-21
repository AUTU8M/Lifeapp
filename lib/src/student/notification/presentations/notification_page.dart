import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/notification/services/notification_services.dart';
import 'package:lifelab3/src/student/questions/services/que_services.dart';
import 'package:provider/provider.dart';
import '../../../student/vision/providers/vision_provider.dart';
import '../../vision/models/vision_video.dart';
import '../../vision/presentations/video_player.dart';
import '../../vision/presentations/vision_page.dart';
import '../../../common/helper/color_code.dart';
import '../../../common/widgets/common_navigator.dart';
import '../../home/provider/dashboard_provider.dart';
import '../../mission/presentations/pages/mission_page.dart';
import '../../nav_bar/presentations/pages/nav_bar_page.dart';
import '../../questions/models/quiz_review_model.dart';
import '../../subject_level_list/provider/subject_level_provider.dart';
import '../model/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  NotificationModel? notificationModel;

  bool isLoading = true;
// Add these methods to your _NotificationPageState class

  Widget _buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _handleMissionRejected() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mission has been rejected"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleMissionAssigned(NotificationData notification) {
    if (notification.data!.data!.laLevelId != null &&
        notification.data!.data!.laSubjectId != null) {
      Map<String, dynamic> missionData = {
        "type": 1,
        "la_subject_id": notification.data!.data!.laSubjectId.toString(),
        "la_level_id": notification.data!.data!.laLevelId.toString(),
      };

      Provider.of<SubjectLevelProvider>(context, listen: false)
          .getMission(missionData)
          .whenComplete(() {
        push(
          context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context,
                listen: false).missionListModel!,
            subjectId: notification.data!.data!.laSubjectId.toString(),
            levelId: notification.data!.data!.laLevelId.toString(),
          ),
        );
      });
    }
  }

  void _handleVisionStatus(String message) {
    if (message.contains('approved')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "🎉 Vision Approved!\nYou have been credited 25 coins",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "❌ Vision Rejected!\nTry again later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
  void getNotificationData() async {
    await NotificationServices().getNotification().then((value) async {
      debugPrint('nottt $value');
      notificationModel = NotificationModel.fromJson(value.data);
      await NotificationServices().clearNotification();
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      setState(() {});
    });
    debugPrint(jsonEncode(notificationModel));

    setState(() {
      isLoading = false;
    });
  }

  void getQuizAnswer(String quizId, int index) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    debugPrint("Quiz ID: $quizId");

    Response response = await QueServices().quizReviewData(id: quizId);

    Loader.hide();

    if(response.statusCode == 200) {
      QuizReviewModel model = QuizReviewModel.fromJson(response.data);

      if(model.quizGame!.status == 3) {
        Fluttertoast.showToast(msg: "Quiz already completed");

      } else if(model.quizGame!.status == 4) {
        Fluttertoast.showToast(msg: "Quiz has been expired");

      } else if(model.quizGame!.gameParticipantStatus == 3) {
        Fluttertoast.showToast(msg: "You have rejected Quiz");

      } else if(model.quizGame!.status == 1 ) {
        // TODO
        // pushNewScreen(
        //     context,
        //     screen: WaitingQuiz(
        //       time: notificationModel!.data![index].data!.data!.time!.toString(),
        //       quizId: notificationModel!.data![index].data!.data!.actionId!.toString(),
        //       isOwner: false,
        //     ),
        //     withNavBar: false
        // );

      } else if(model.quizGame!.status == 2) {
        Fluttertoast.showToast(msg: "You have left the quiz");

      } else {
        Fluttertoast.showToast(msg: "Quiz has been expired");
      }
    }

  }
  @override
  void initState() {
    super.initState();
    getNotificationData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: "Notification",
        onBack: () {
          push(
            context: context,
            page: const NavBarPage(currentIndex: 0,),
          );
        }
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: notificationModel != null && notificationModel!.data!.isNotEmpty ? _notificationWidget()
            : notificationModel != null && notificationModel!.data!.isNotEmpty ? _emptyData()
            : const SizedBox(),
      ),
    );
  }
  Widget _getActionButton(NotificationData notification, int index) {
    final message = notification.data!.message ?? '';
    final action = notification.data!.data!.action?.toString() ?? '';

    if (message.contains('vision has been approved') ||
        message.contains('vision has been rejected')) {
      return _buildButton('Know more', () => _handleVisionStatus(message));
    }
    else if (message.contains('mission have been rejected')) {
      return _buildButton('View', () => _handleMissionRejected());
    }
    else if (message.contains('teacher have assigned you a mission') ||
        message.contains('A new vision has been assigned to you')) {
      return _buildButton('View', () => _handleVisionVideo(notification));
    }
    else if (action == '6') {
      return _buildButton('View', () => push(
        context: context,
        page: const NavBarPage(currentIndex: 2),
      ));
    }
    else if (action == '3' &&
        notification.data!.data!.actionId != null &&
        notification.data!.data!.time != null) {
      return _buildButton('View', () => getQuizAnswer(
          notification.data!.data!.actionId!.toString(),
          index
      ));
    }
    else {
      return _buildButton('View', () {});
    }
  }

  void _handleVisionVideo(NotificationData notification) async {
    try {
      final visionId = notification.data!.data!.visionId?.toString();
      final subjectId = notification.data!.data!.laSubjectId;

      if (visionId == null || subjectId == null) {
        Fluttertoast.showToast(msg: "Invalid vision data");
        return;
      }

      final subjectMap = {1: "Science", 2: "Maths", 3: "Finance"};
      final subjectName = subjectMap[subjectId] ?? "Unknown";

      final visionProvider = Provider.of<VisionProvider>(context, listen: false);
      await visionProvider.initWithSubject(subjectId.toString() , '1');

      final VisionVideo? video = visionProvider.getVideoById(visionId);
      debugPrint('Video loaded: ${video?.toJson()}');

      if (video == null) {
        Fluttertoast.showToast(msg: "Video not found for vision");
        return;
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: visionProvider,
            child: VideoPlayerPage(
              video: video,
              navName: "Notification",
              subjectName: subjectName,
              onVideoCompleted: () {},
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error opening vision video: $e');
      Fluttertoast.showToast(msg: "Error opening video");
    }
  }

  Widget _notificationWidget() => ListView.separated(
    shrinkWrap: true,
    padding: const EdgeInsets.only(bottom: 50),
    itemCount: notificationModel!.data!.length,
    itemBuilder: (context, index) {
      final notification = notificationModel!.data![index];
      final message = notification.data!.message ?? '';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.data!.data!.mediaUrl != null)
                  CachedNetworkImage(
                    imageUrl: ApiHelper.imgBaseUrl + notification.data!.data!.mediaUrl!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                else
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/pro.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _getActionButton(notification, index),
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => const SizedBox(height: 8),
  );

  Widget _emptyData() => SizedBox(
    height: MediaQuery.of(context).size.height,
    child: const Center(
      child: Text(
        "No data available",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
