import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/color_code.dart';
import '../../../student/home/models/subject_model.dart';
import '../../../student/home/services/dashboard_services.dart';
import '../../../student/profile/services/profile_services.dart';
import '../../../student/sign_up/model/school_list_model.dart';
import '../../../student/sign_up/model/section_model.dart';
import '../../../student/sign_up/model/state_city_model.dart';
import '../../../student/sign_up/model/verify_school_model.dart';
import '../../../student/sign_up/services/sign_up_services.dart';
import '../../teacher_sign_up/model/board_model.dart';
import '../../teacher_sign_up/services/teacher_sign_up_services.dart';
import '../../teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';

class TeacherProfileProvider extends ChangeNotifier {
  SchoolListModel? schoolListModel;
  SectionModel? sectionModel;
  BoardModel? boardModel;
  SubjectModel? subjectModel;
  VerifySchoolModel? verifySchoolModel;

  List<StateCityListModel> listOfLocation = [];
  List<StateCityListModel> searchListOfLocation = [];
  List<City> cityList = [];
  List<City> searchCityList = [];
  List<Map<String, dynamic>> gradeMapList = [];

  TextEditingController teacherNameController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController boardNameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateSearchCont = TextEditingController();
  TextEditingController citySearchCont = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController schoolCodeController = TextEditingController();

  List<int> gradeList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> subjectIdList = [];

  int? boardId;
  String? boardName;

  int gender = 0;

  int? sectionId;

  bool isSchoolCodeValid = true;

  DateTime date = DateTime.now();

  Future<void> getSchoolList() async {
    Response? response = await TeacherSignUpServices().getSchoolList();

    if (response?.statusCode == 200) {
      schoolListModel = SchoolListModel.fromJson(response!.data);
      notifyListeners();
    }
  }

  Future<void> getSectionList() async {
    Response response = await SignUpServices().getSectionList();

    if (response.statusCode == 200) {
      sectionModel = SectionModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getBoardList() async {
    Response response = await TeacherSignUpServices().getBoard();
    if (response.statusCode == 200) {
      boardModel = BoardModel.fromJson(response.data);

      // Only set initial board if NO board is currently set
      if ((boardId == null || boardName == null) &&
          boardModel?.data?.boards != null &&
          boardModel!.data!.boards!.isNotEmpty) {
        final firstBoard = boardModel!.data!.boards!.first;
        setInitialBoard(firstBoard.id.toString(), firstBoard.name);
      }

      notifyListeners();
    }
  }

  Future<void> getSubjectList() async {
    Response response = await DashboardServices().getSubjectData();

    if (response.statusCode == 200) {
      subjectModel = SubjectModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getStateCityList() async {
    Response? response = await TeacherSignUpServices().getStateList();

    if (response?.statusCode == 200) {
      for (var i in response!.data) {
        StateCityListModel data = StateCityListModel.fromJson(i);
        if (data.active! == 1) {
          listOfLocation.add(data);
          searchListOfLocation.add(data);
        }
      }

      int index = listOfLocation.indexWhere((element) =>
          element.stateName!.toLowerCase() ==
          stateController.text.toLowerCase());
      if (index > 0) getCityData(index);
      notifyListeners();
    }
  }

  void getCityData(int index) {
    cityList = listOfLocation[index].cities!;
    searchCityList = listOfLocation[index].cities!;
    notifyListeners();
  }

  bool _isInitialized = false;

  void resetState() {
    _isInitialized = false;
    gradeMapList.clear();
    notifyListeners();
  }

  void initializeGradeMapList() {
    // Only initialize if not already initialized
    if (!_isInitialized) {
      gradeMapList.clear(); // Clear any existing data
      gradeMapList.add({
        "la_grade_id": "",
        "la_section_id": "",
        "subjects": "",
        "la_section_name": "",
        "subject_name": ""
      });
      _isInitialized = true;
      notifyListeners();
    }
  }

  bool isGradeEntryValid(Map<String, dynamic> grade) {
    return grade["la_grade_id"].toString().isNotEmpty &&
        grade["la_section_id"].toString().isNotEmpty &&
        grade["subjects"].toString().isNotEmpty;
  }

  void syncBoardWithDashboard(BuildContext context) {
    if (boardId != null && boardName != null) {
      final dashboardProvider =
          Provider.of<TeacherDashboardProvider>(context, listen: false);
      dashboardProvider.setSelectedBoard(boardId!, boardName!);
    }
  }

  void updateTeacher(BuildContext context, String contact) async {
    try {
      // Validate gradeMapList data
      bool hasValidData = gradeMapList.any((grade) =>
          grade["la_grade_id"].toString().isNotEmpty &&
          grade["la_section_id"].toString().isNotEmpty &&
          grade["subjects"].toString().isNotEmpty);

      if (!hasValidData) {
        Fluttertoast.showToast(
            msg: "Please add at least one grade with section and subject",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        return;
      }

      // Validate DOB
      String formattedDob = dobController.text.trim();
      if (formattedDob.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please select date of birth",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      // Validate board data
      if (boardId == null || boardName == null || boardName!.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please select a board",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }

      // Show loader
      if (context.mounted) {
        Loader.show(
          context,
          progressIndicator: const CircularProgressIndicator(
            color: ColorCode.buttonColor,
          ),
          overlayColor: Colors.black54,
        );
      }

      // Clean up gradeMapList
      final cleanGradeMapList = gradeMapList
          .where((grade) => grade["subjects"].toString().isNotEmpty)
          .map((grade) => {
                "la_grade_id": grade["la_grade_id"],
                "la_section_id": grade["la_section_id"],
                "subjects": grade["subjects"],
              })
          .toList();

      final currentBoardId = boardId;
      final currentBoardName = boardName;

      // Prepare request body with properly formatted DOB
      Map<String, dynamic> body = {
        "mobile_no": contact,
        "type": 5,
        "name": teacherNameController.text.trim(),
        "school": schoolNameController.text.trim(),
        "state": stateController.text,
        "city": cityController.text,
        "la_board_id": currentBoardId,
        "board_name": currentBoardName,
        "dob": dobController.text.trim(),
        "grades": cleanGradeMapList,
      };

      debugPrint("Update request body: $body");

      // Make API call
      Response response = await ProfileService().updateProfileData(body);
      debugPrint("Update Profile Response: ${response.data}");

      Loader.hide();

      if (response.statusCode == 200) {
        // Store the DOB value before refreshing dashboard
        final updatedDob = formattedDob;

        // Refresh dashboard data
        // if (boardId != null && boardName != null) {
        //   setInitialBoard(boardId.toString(), boardName);
        // }

        if (context.mounted) {
          await Provider.of<TeacherDashboardProvider>(context, listen: false)
              .getDashboardData();

          // Sync board with dashboard provider
          Provider.of<TeacherDashboardProvider>(context, listen: false)
              .setSelectedBoard(currentBoardId!, currentBoardName!);
        }

        // Restore board values if they were cleared
        if (currentBoardId != null && currentBoardName != null) {
          setInitialBoard(currentBoardId.toString(), currentBoardName);
        }

        debugPrint("Profile updated. New DOB: $updatedDob");
        debugPrint(
            "Current Board ID: $boardId, Current Board Name: $boardName");

        // Show success message
        if (context.mounted) {
          Fluttertoast.showToast(
              msg: "Profile updated successfully",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);

          // Navigate after successful update
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update profile. Please try again.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      Loader.hide();
      debugPrint("Error updating teacher profile: $e");

      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "An error occurred while updating profile",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  void addNewGradeEntry() {
    gradeMapList.add({
      "la_grade_id": "",
      "la_section_id": "",
      "subjects": "",
      "la_section_name": "",
      "subject_name": ""
    });
    notifyListeners();
  }

// notifylisteners issue fixed
  void updateGradeMapList(String gradeId, String sectionId, String subjectId,
      String sectionName, String subjectName, int index) {
    if (index < gradeMapList.length) {
      gradeMapList[index] = {
        "la_grade_id": gradeId,
        "la_section_id": sectionId,
        "subjects": subjectId,
        "la_section_name": sectionName,
        "subject_name": subjectName
      };
    }
    notifyListeners();
  }

  void updateDOB(DateTime picked) {
    date = picked;
    dobController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    notifyListeners();
  }

  // void updateBoard(int id, String name) {
  //   boardId = id;
  //   boardName = name;
  //   boardNameController.text = name;
  //   debugPrint("Board updated - ID: $id, Name: $name"); // Add logging
  //   notifyListeners();
  // }

  void setInitialDOB(String? dob) {
    if (dob != null && dob.isNotEmpty) {
      try {
        final DateTime dobDate = DateTime.parse(dob);
        date = dobDate;
        dobController.text =
            "${dobDate.year}-${dobDate.month.toString().padLeft(2, '0')}-${dobDate.day.toString().padLeft(2, '0')}";
      } catch (e) {
        debugPrint("Error parsing DOB: $e");
        date = DateTime.now();
        dobController.text = "";
      }
    } else {
      date = DateTime.now();
      dobController.text = "";
    }
    notifyListeners();
  }

  void setInitialBoard(String? id, String? name) {
    if (id != null && id.isNotEmpty && name != null && name.isNotEmpty) {
      try {
        boardId = int.parse(id);
        boardName = name;
        boardNameController.text = name;
        debugPrint("Board set - ID: $boardId, Name: $boardName");
        notifyListeners();
      } catch (e) {
        debugPrint("Error setting board: $e");
        // Don't reset board data on error
      }
    } else {
      debugPrint("Invalid board data provided - ID: $id, Name: $name");
    }
  }

  void updateBoard(int id, String name) {
    try {
      if (id > 0 && name.isNotEmpty) {
        boardId = id;
        boardName = name;
        boardNameController.text = name;
        debugPrint("Board updated - ID: $id, Name: $name");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating board: $e");
      // Don't reset the board data on update error
    }
  }

  void verifySchoolCode(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(
        color: ColorCode.buttonColor,
      ),
      overlayColor: Colors.black54,
    );

    Response response =
        await SignUpServices().verifyCode(schoolCodeController.text);

    Loader.hide();

    if (response.statusCode == 200) {
      isSchoolCodeValid = true;
      verifySchoolModel = VerifySchoolModel.fromJson(response.data);
      schoolNameController.text = verifySchoolModel!.data!.school!.name!;
      stateController.text = verifySchoolModel!.data!.school!.state!;
      cityController.text = verifySchoolModel!.data!.school!.city!;
    } else {
      isSchoolCodeValid = false;
      schoolCodeController.text = "";
      stateController.text = "";
      cityController.text = "";
    }
    notifyListeners();
  }
}
