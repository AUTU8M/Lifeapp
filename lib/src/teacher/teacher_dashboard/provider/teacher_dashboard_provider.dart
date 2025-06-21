import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/home/models/dashboard_model.dart';
import 'package:lifelab3/src/student/home/models/subject_model.dart';
import 'package:lifelab3/src/student/subject_level_list/models/level_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/assessment_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/competencies_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/concept_cartoon_header_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/concept_cartoon_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/language_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/lesson_plan_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/model/work_sheet_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/lesson_download_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/service/teacher_dashboard_service.dart';

import '../../../common/helper/color_code.dart';
import '../../../student/home/services/dashboard_services.dart';
import '../../../student/subject_level_list/service/level_list_service.dart';
import '../../teacher_sign_up/model/board_model.dart';
import '../../teacher_sign_up/services/teacher_sign_up_services.dart';

class TeacherDashboardProvider extends ChangeNotifier {
  DashboardModel? dashboardModel;
  SubjectModel? subjectModel;
  LevelModel? levels;
  CompetenciesModel? competenciesModel;
  ConceptCartoonModel? cartoonModel;
  AssessmentModel? assessmentModel;
  WorkSheetModel? workSheetModel;
  ConceptCartoonHeaderModel? headerModel;
  BoardModel? boardModel;
  LanguageModel? languageModel;
  LessonPlanModel? lessonPlanModel;

  String board = "";
  String language = "";
  int boardId = 0;
  int languageId = 0;

  Future<void> getDashboardData() async {
    Response response = await DashboardServices().getDashboardData();
    if (response.statusCode == 200) {
      dashboardModel = DashboardModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getSubjectsData() async {
    Response response = await DashboardServices().getSubjectData();

    if (response.statusCode == 200) {
      subjectModel = SubjectModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getLevel() async {
    Response response = await LevelListService().getLevelData();

    if (response.statusCode == 200) {
      levels = LevelModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getCompetency({required Map<String, dynamic> body}) async {
    Response response = await TeacherDashboardService().getCompetencies(body);

    if (response.statusCode == 200) {
      competenciesModel = CompetenciesModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getConceptCartoon({required Map<String, dynamic> body}) async {
    Response response = await TeacherDashboardService().getConceptCartoon(body);

    if (response.statusCode == 200) {
      cartoonModel = ConceptCartoonModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getConceptCartoonHeader() async {
    Response response =
        await TeacherDashboardService().getConceptCartoonHeader();

    if (response.statusCode == 200) {
      headerModel = ConceptCartoonHeaderModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getAssessment({required Map<String, dynamic> body}) async {
    Response response = await TeacherDashboardService().getAssessment(body);

    if (response.statusCode == 200) {
      assessmentModel = AssessmentModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void getWorkSheet({required Map<String, dynamic> body}) async {
    Response response = await TeacherDashboardService().getWorkSheet(body);

    if (response.statusCode == 200) {
      workSheetModel = WorkSheetModel.fromJson(response.data);
      notifyListeners();
    }
  }

  void setSelectedBoard(int id, String boardName) {
    boardId = id;
    board = boardName;
    notifyListeners();
  }

  Future<void> getBoard() async {
    try {
      Response response = await TeacherSignUpServices().getBoard();

      if (response.statusCode == 200) {
        boardModel = BoardModel.fromJson(response.data);

        // Only set default board if no board is currently selected
        if (boardId == 0 &&
            boardModel?.data?.boards != null &&
            boardModel!.data!.boards!.isNotEmpty) {
          boardId = boardModel!.data!.boards![0].id!;
          board = boardModel!.data!.boards![0].name ?? "";
        }

        // Validate if current boardId exists in the new board list
        bool boardExists =
            boardModel?.data?.boards?.any((b) => b.id == boardId) ?? false;

        if (!boardExists &&
            boardModel?.data?.boards != null &&
            boardModel!.data!.boards!.isNotEmpty) {
          // Reset to first board if current selection is invalid
          boardId = boardModel!.data!.boards![0].id!;
          board = boardModel!.data!.boards![0].name ?? "";
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error fetching board data: $e');
    }
  }

  Future<void> getLanguage() async {
    Response response = await TeacherDashboardService().getLessonLanguage();

    if (response.statusCode == 200) {
      languageModel = LanguageModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> submitPlan(
      {required BuildContext context, required String type}) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(
        color: ColorCode.buttonColor,
      ),
      overlayColor: Colors.black54,
    );

    Map<String, dynamic> body = {
      "type": type,
      "la_board_id": boardId,
      "la_lession_plan_language_id": languageId,
    };

    Response response = await TeacherDashboardService().submitPlan(body);

    Loader.hide();

    if (response.statusCode == 200) {
      lessonPlanModel = LessonPlanModel.fromJson(response.data);
      if (context.mounted &&
          lessonPlanModel!.data!.laLessionPlans!.isNotEmpty) {
        push(
          context: context,
          page: LessonDownloadPage(model: lessonPlanModel!),
        );
      } else {
        Fluttertoast.showToast(msg: "No data available");
      }
    } else {
      lessonPlanModel = null;
    }
    notifyListeners();
  }

  void clearLessonPlan() {
    
    language = "";
    languageId = 0;
    lessonPlanModel = null;
    notifyListeners();
  }
}
