import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/home/models/subject_model.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_dashboard_page.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/model/board_model.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';
import '../../../common/widgets/common_navigator.dart';
import '../../../student/sign_up/model/register_student_model.dart';
import '../../../student/sign_up/model/school_list_model.dart';
import '../../../student/sign_up/model/section_model.dart';
import '../../../student/sign_up/model/state_city_model.dart';
import '../../../student/sign_up/model/verify_school_model.dart';
import '../../../student/sign_up/services/sign_up_services.dart';
import '../../../utils/storage_utils.dart';
import '../services/teacher_sign_up_services.dart';

class TeacherSignUpProvider extends ChangeNotifier {

  SchoolListModel? schoolListModel;
  SectionModel? sectionModel;
  BoardModel? boardModel;
  SubjectModel? subjectModel;
  VerifySchoolModel? verifySchoolModel;

  List<StateCityListModel> listOfLocation = [];
  List<StateCityListModel> searchListOfLocation = [];
  List<City> cityList = [];
  List<City> searchCityList = [];

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
  TextEditingController schoolCodeController = TextEditingController();

  List<int> gradeList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> subjectIdList = [];

  int gender = 0;
  int boardId = 0;
  int? sectionId;

  bool isSchoolCodeValid = false;

  List<Map<String, dynamic>> gradeMapList = [];

  Future<void> getSchoolList() async {

    Response? response = await TeacherSignUpServices().getSchoolList();

    if(response?.statusCode == 200) {
      schoolListModel = SchoolListModel.fromJson(response!.data);
      notifyListeners();
    }
  }

  Future<void> getSectionList() async {

    Response response = await SignUpServices().getSectionList();

    if(response.statusCode == 200) {
      sectionModel = SectionModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getBoard() async {

    Response response = await TeacherSignUpServices().getBoard();

    if(response.statusCode == 200) {
      boardModel = BoardModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getGradesList() async {

    Response response = await TeacherSignUpServices().getGradesList();

    if(response.statusCode == 200) {
      gradeMapList = response.data;
      notifyListeners();
    }
  }

  Future<void> subjects() async {

    Response response = await TeacherSignUpServices().subjects();

    if(response.statusCode == 200) {
      subjectModel = SubjectModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getStateCityList() async {

    Response? response = await TeacherSignUpServices().getStateList();

    if(response?.statusCode == 200) {
      for(var i in response!.data) {
        StateCityListModel data = StateCityListModel.fromJson(i);
        if(data.active! == 1) {
          listOfLocation.add(data);
          searchListOfLocation.add(data);
        }
      }

      int index = listOfLocation.indexWhere((element) => element.stateName!.toLowerCase() == stateController.text.toLowerCase());
      if(index > 0) getCityData(index);
      notifyListeners();
    }
  }

  void getCityData(int index) {
    int index1 = listOfLocation.indexWhere((element) => element.stateName!.toLowerCase() == stateController.text.toLowerCase());
    cityList = listOfLocation[index1].cities!;
    searchCityList = searchListOfLocation[index].cities!;
    notifyListeners();
  }

  void registerStudent(BuildContext context, String contact) async {

    bool isValid = false;

    for(var i in gradeMapList) {
      debugPrint("Data: $i");
      if(i["subjects"].isNotEmpty) {
        isValid = true;
      } else {
        isValid = false;
      }
    }

    if(teacherNameController.text.trim().isNotEmpty
        && schoolNameController.text.trim().isNotEmpty && stateController.text.isNotEmpty
        && cityController.text.isNotEmpty && isValid) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      for(var i in gradeMapList) {
        i.removeWhere((key, value) => key == "subject_name");
        i.removeWhere((key, value) => key == "la_section_name");
      }

      Map<String, dynamic> body = {
        "mobile_no": contact,
        "type": 5,
        "name": teacherNameController.text.trim(),
        // "la_grade_id": int.parse(gradeController.text),
        "school": schoolNameController.text.trim(),
        "state": stateController.text,
        "city": cityController.text,
        // "subjects": subjectIdList.toString().replaceAll("[", "").replaceAll("]", ""),
        "la_board_id": boardId == 0 ? null : boardId,
        // "section": sectionController.text,
        "device_token": StorageUtil.getString(StringHelper.fcmToken),
        "grades": gradeMapList,
      };

      debugPrint("Sign up data: $body");

      Response response = await TeacherSignUpServices().registerStudent(body);

      Loader.hide();

      if(response.statusCode == 200) {
        if(!context.mounted) return;
        RegisterStudentModel model = RegisterStudentModel.fromJson(response.data);
        StorageUtil.putBool(StringHelper.isTeacher, true);
        StorageUtil.putString(StringHelper.token, model.data!.user!.token!);
        pushRemoveUntil(context: context, page: const TeacherDashboardPage());
      }
    } else {
      Fluttertoast.showToast(msg: StringHelper.invalidData);
    }
  }

  void verifySchoolCode(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await SignUpServices().verifyCode(schoolCodeController.text);

    Loader.hide();

    if(response.statusCode == 200) {
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