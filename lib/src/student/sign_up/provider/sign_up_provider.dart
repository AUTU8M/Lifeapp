import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/nav_bar/presentations/pages/nav_bar_page.dart';
import 'package:lifelab3/src/student/sign_up/model/grade_model.dart';
import 'package:lifelab3/src/student/sign_up/model/register_student_model.dart';
import 'package:lifelab3/src/student/sign_up/model/school_list_model.dart';
import 'package:lifelab3/src/student/sign_up/model/section_model.dart';
import 'package:lifelab3/src/student/sign_up/model/verify_school_model.dart';
import 'package:lifelab3/src/student/sign_up/services/sign_up_services.dart';
import 'package:lifelab3/src/student/student_login/provider/student_login_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/color_code.dart';
import '../../../utils/storage_utils.dart';
import '../model/state_city_model.dart';

class SignUpProvider extends ChangeNotifier {


  DateTime date = DateTime.now();

  SchoolListModel? schoolListModel;
  SectionModel? sectionModel;
  GradeModel? gradeModel;
  VerifySchoolModel? verifySchoolModel;

  List<StateCityListModel> listOfLocation = [];
  List<StateCityListModel> searchListOfLocation = [];
  List<City> cityList = [];
  List<City> searchCityList = [];

  TextEditingController chileNameController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateSearchCont = TextEditingController();
  TextEditingController citySearchCont = TextEditingController();
  TextEditingController dobController = TextEditingController(); // Added dobController

  List<int> gradeList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> relationList = ["Father", "Mother", "Other"];

  int? sectionId;
  int gender = 0;

  bool isSchoolCodeValid = false;

  Future<void> getSchoolList() async {

    Response? response = await SignUpServices().getSchoolList();

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

  Future<void> getGradeList() async {

    Response response = await SignUpServices().getGradeList();

    if(response.statusCode == 200) {
      gradeModel = GradeModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> getStateCityList() async {

    Response? response = await SignUpServices().getStateList();

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
    cityList = listOfLocation[index].cities!;
    searchCityList = listOfLocation[index].cities!;
    notifyListeners();
  }

  void registerStudent(BuildContext context) async {

    if(chileNameController.text.trim().isNotEmpty && gradeController.text.isNotEmpty
        && sectionController.text.trim().isNotEmpty && sexController.text.trim().isNotEmpty
        && schoolNameController.text.trim().isNotEmpty && stateController.text.isNotEmpty
        && cityController.text.isNotEmpty) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      Map<String, dynamic> body = {
        "mobile_no": Provider.of<StudentLoginProvider>(context, listen: false).contactController.text,
        "type": 3,
        "name": chileNameController.text.trim(),
        "la_grade_id": int.parse(gradeController.text),
        "school": schoolNameController.text.trim(),
        "state": stateController.text,
        "city": cityController.text,
        "gender": gender,
        "section": sectionController.text,
        "guardian_name": parentNameController.text.trim(),
        "device_token": StorageUtil.getString(StringHelper.fcmToken),
        "school_code": schoolCodeController.text,
      };

      debugPrint("Data: $body");

      Response response = await SignUpServices().registerStudent(body);

      Loader.hide();

      if(response.statusCode == 200) {
        if(!context.mounted) return;
        RegisterStudentModel model = RegisterStudentModel.fromJson(response.data);
        var data = response.data;
        debugPrint('dataaa $data');

        StorageUtil.putBool(StringHelper.isLoggedIn, true);
        StorageUtil.putString(StringHelper.token, model.data!.user!.token!);
        // StorageUtil.putString('student_id',  json.encode(response.data));
        pushRemoveUntil(context: context, page: const NavBarPage(currentIndex: 0));
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

  @override
  void dispose() {
    chileNameController.dispose();
    parentNameController.dispose();
    relationController.dispose();
    gradeController.dispose();
    sectionController.dispose();
    sexController.dispose();
    schoolNameController.dispose();
    schoolCodeController.dispose();
    stateController.dispose();
    cityController.dispose();
    stateSearchCont.dispose();
    citySearchCont.dispose();
    dobController.dispose(); // Dispose dobController
    super.dispose();
  }

}
