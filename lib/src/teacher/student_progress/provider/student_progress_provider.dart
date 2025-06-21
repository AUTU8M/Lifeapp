import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as d;
import 'dart:typed_data';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lifelab3/src/teacher/student_progress/model/teacher_grade_section_model.dart';
import 'package:lifelab3/src/teacher/student_progress/model/teacher_mission_list_model.dart';
import 'package:lifelab3/src/teacher/student_progress/model/teacher_mission_participant_model.dart';
import 'package:lifelab3/src/teacher/teacher_tool/model/all_student_report_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../teacher_tool/services/tool_services.dart';
import '../model/student_missions_model.dart';

class StudentProgressProvider extends ChangeNotifier {

  TextEditingController searchController = TextEditingController();

  AllStudentReportModel? allStudentReportModel;
  StudentMissionsModel? studentMissionsModel;
  TeacherGradeSectionModel? teacherGradeSectionModel;
  TeacherMissionListModel? teacherMissionListModel;
  TeacherMissionParticipantModel? teacherMissionParticipantModel;
  bool isImageProcessing = false;
  GlobalKey studentDetailsGlobalKey = GlobalKey();

  void getAllStudent() async {
    Response response = await ToolServices().getAllStudentReport();

    if(response.statusCode == 200) {
      allStudentReportModel = AllStudentReportModel.fromJson(response.data);
      notifyListeners();
    } else {
      allStudentReportModel = null;
    }
  }

  void getAllStudentMissionList({required String userId}) async {
    Response response = await ToolServices().getAllStudentMissionList(userId: userId);

    if(response.statusCode == 200) {
      studentMissionsModel = StudentMissionsModel.fromJson(response.data);
      notifyListeners();
    } else {
      studentMissionsModel = null;
    }
  }

  void getTeacherGrade() async {
    Response response = await ToolServices().getTeacherGrade();

    if(response.statusCode == 200) {
      teacherGradeSectionModel = TeacherGradeSectionModel.fromJson(response.data);
      notifyListeners();
    } else {
      teacherGradeSectionModel = null;
    }
  }

  void getClassStudent(String gradeId) async {
    Response response = await ToolServices().getClassStudentReport(gradeId);

    if(response.statusCode == 200) {
      allStudentReportModel = AllStudentReportModel.fromJson(response.data);
      notifyListeners();
    } else {
      allStudentReportModel = null;
    }
  }

  void getTeacherMission() async {
    Response response = await ToolServices().getTeacherMission();

    if(response.statusCode == 200) {
      teacherMissionListModel = TeacherMissionListModel.fromJson(response.data);
      notifyListeners();
    } else {
      teacherMissionListModel = null;
    }
  }

  void getTeacherMissionParticipant(String missionId) async {
    Response response = await ToolServices().getTeacherMissionParticipant(missionId: missionId);

    if(response.statusCode == 200) {
      d.log("Data ${jsonEncode(response.data)}");
      teacherMissionParticipantModel = TeacherMissionParticipantModel.fromJson(response.data);
      notifyListeners();
    } else {
      teacherMissionParticipantModel = null;
    }
  }

  void submitApproveReject({required int status, required String comment, required String studentId, required BuildContext context, required String missionId}) async {

    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(),
      overlayColor: Colors.black54,
    );

    Response response = await ToolServices().submitTeacherMissionApproveReject(
      status: status,
      comment: comment,
      studentId: studentId,
    );

    Loader.hide();

    if(response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.data["message"]);
      Navigator.pop(context);
      getTeacherMissionParticipant(missionId);
    } else {
      Fluttertoast.showToast(msg: "Try again later");
    }
  }

  void downloadImage(BuildContext context) async {
    int androidVersion = 0;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      androidVersion = int.tryParse(release.split(".").first) ?? 0;
    }
    var randomNum = Random();
    Directory? directory;
    var statusPermission = androidVersion<12?(await Permission.storage.request()):PermissionStatus.granted;
    if (statusPermission.isDenied) return;
    if (statusPermission.isGranted) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(),
        overlayColor: Colors.black54,
      );
      try {
        isImageProcessing = true;
        notifyListeners();
        await Future.delayed(const Duration(seconds: 1));
        RenderRepaintBoundary? boundary = studentDetailsGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(
          pixelRatio: 10,
        );
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List? uInt8list = byteData!.buffer.asUint8List(byteData.offsetInBytes);

        if (Platform.isIOS) {
          directory = await getTemporaryDirectory();
          debugPrint("path IOS:${directory.path}");
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            final file = await File('${directory.path}/Lifelab_${randomNum.nextInt(1000000)}.png').create();
            await file.writeAsBytes(uInt8list);
            await directory.create(recursive: true);
            // await ImageGallerySaver.saveImage(uInt8list);
          }
          Fluttertoast.showToast(msg: 'Downloaded');
        } else {
          directory = await getExternalStorageDirectory();
          File file = await File("/storage/emulated/0/Download/Lifelab_${randomNum.nextInt(1000000)}.png").create(recursive: true);
          await file.writeAsBytes(uInt8list);
          // await ImageGallerySaver.saveImage(uInt8list);
          Fluttertoast.showToast(msg: 'Downloaded');
        }
        Loader.hide();
      } catch (e) {
        Loader.hide();
        Fluttertoast.showToast(msg: "Please try again later!");
      }
      isImageProcessing = false;
      notifyListeners();
    }
  }
}