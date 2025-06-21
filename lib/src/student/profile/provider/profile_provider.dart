import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:lifelab3/src/student/profile/services/profile_services.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/string_helper.dart';
import '../../sign_up/model/grade_model.dart';
import '../../sign_up/model/school_list_model.dart';
import '../../sign_up/model/section_model.dart';
import '../../sign_up/model/state_city_model.dart';
import '../../sign_up/model/verify_school_model.dart';
import '../../sign_up/services/sign_up_services.dart';

class ProfileProvider extends ChangeNotifier {

  SchoolListModel? schoolListModel;
  VerifySchoolModel? verifySchoolModel;
  SectionModel? sectionModel;
  GradeModel? gradeModel;

  List<StateCityListModel> listOfLocation = [];
  List<StateCityListModel> searchListOfLocation = [];
  List<City> cityList = [];
  List<City> searchCityList = [];
  List<String> relationList = ["Father", "Mother", "Other"];

  TextEditingController chileNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateSearchCont = TextEditingController();
  TextEditingController citySearchCont = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController schoolCodeController = TextEditingController();

  DateTime date = DateTime.now();

  int gender = 0;
  int? sectionId;


  bool isSchoolCodeValid = false;

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

  void getCityData(int index) {
    cityList = listOfLocation[index].cities!;
    searchCityList = listOfLocation[index].cities!;
    notifyListeners();
  }

  void update(BuildContext context) async {

    // print("Child Name: ${chileNameController.text.trim()}");
    // print("School Name: ${schoolNameController.text.trim()}");
    // print("Grade: ${gradeController.text}");
    // print("Sex: ${sexController.text}");
    // print("State: ${stateController.text}");
    // print("City: ${cityController.text}");
    // print("Dob: ${dobController.text}");
    // print("Address: ${addressController.text}");
    // print("Section: ${sectionController.text}");

    if(chileNameController.text.trim().isNotEmpty && schoolNameController.text.trim().isNotEmpty
        && gradeController.text.isNotEmpty && sexController.text.trim().isNotEmpty
        && stateController.text.isNotEmpty && cityController.text.isNotEmpty
        && dobController.text.isNotEmpty) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
        overlayColor: Colors.black54,
      );

      Map<String, dynamic> body = {
        "mobile_no": mobileController.text,
        "name": chileNameController.text.trim(),
        "la_grade_id": int.parse(gradeController.text),
        "school": schoolNameController.text.trim(),
        "state": stateController.text,
        "city": cityController.text,
        "gender": gender,
        "guardian_name": parentNameController.text.trim(),
        "address": addressController.text,
        "dob": dobController.text,
        "school_code": schoolCodeController.text,
        "section": sectionController.text,
      };

      Response response = await ProfileService().updateProfileData(body, isStudent: true);

      Loader.hide();

      if(response.statusCode == 200) {
        if(!context.mounted) return;
        Fluttertoast.showToast(msg: "Updated");
        Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
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