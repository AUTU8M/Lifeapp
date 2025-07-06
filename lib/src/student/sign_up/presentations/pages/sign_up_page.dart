import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_text_field.dart';
import 'package:lifelab3/src/student/profile/presentations/widget/gender_sheet.dart';
import 'package:lifelab3/src/student/sign_up/presentations/widgets/section_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



import '../../../../common/utils/mixpanel_service.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../provider/sign_up_provider.dart';
import '../widgets/grade_list_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignUpProvider>(context, listen: false).getSchoolList();
      Provider.of<SignUpProvider>(context, listen: false).getStateCityList();
      Provider.of<SignUpProvider>(context, listen: false).getSectionList();
      Provider.of<SignUpProvider>(context, listen: false).getGradeList();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(ImageHelper.gappuBoboImg1),

              const SizedBox(height: 20),
              const Text(
                "Student Registration",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Child Name
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: false,

                color: Colors.white,
                fieldController: provider.chileNameController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.chileName,
              ),

             /* // Parent Name
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: false,
                color: Colors.white,
                fieldController: provider.parentNameController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.parentName,
              ),

              // Relation with student
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.relationController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.relationWithStudent,
                onTap: () {
                  relationListBottomSheet(context, provider);
                },
              ),*/

              // Grade
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.gradeController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.grade,
                onTap: () {
                  gradeListBottomSheet(context, provider);
                },
              ),

              // Section
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.sectionController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.section,
                onTap: () {
                  sectionListBottomSheet(context, provider);
                },
              ),

              // Sex
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.sexController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.gender,
                onTap: () {
                  genderBottomSheet(context: context, provider: provider);
                },
              ),

              // DOB
              

              
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  CustomTextField(
                    readOnly: true,
                    color: Colors.white,
                    fieldController: provider.dobController,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    hintName: "DOB",
                    suffix: const Icon(Icons.calendar_month_rounded),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: provider.date,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        provider.date = picked;
                        provider.dobController.text =
                          "${picked.year}-${picked.month}-${picked.day}";
                        provider.notifyListeners();
                      } else {
                        Fluttertoast.showToast(msg: "Please select a Date of Birth");
                      }
                    },
                  ),
                ],
              ),


              

              // Code
              const SizedBox(height: 20),
              Row(
                children: [
                  // School Name
                  const SizedBox(height: 20),
                  Expanded(
                    child: CustomTextField(
                      readOnly: false,
                      color: Colors.white,
                      fieldController: provider.schoolCodeController,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      hintName: "Enter school code",
                      onChange: (val) {
                        provider.isSchoolCodeValid = false;
                        provider.notifyListeners();
                      },
                    ),
                  ),

                  if(!provider.isSchoolCodeValid) TextButton(
                    onPressed: () {
                      provider.verifySchoolCode(context);
                    },
                    child: const Text(
                      "verify",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              if(provider.isSchoolCodeValid) Padding(
               padding: const EdgeInsets.only(left: 15, right: 15),
               child: RichText(
                 text: TextSpan(
                   text: provider.schoolNameController.text,
                   style: const TextStyle(
                     color: Colors.black54,
                     fontSize: 15,
                   ),
                   children: [
                     TextSpan(
                       text: " ,${provider.stateController.text}, ${provider.cityController.text}",
                       style: const TextStyle(
                         color: Colors.black54,
                         fontSize: 15,
                       )
                     ),
                   ]
                 ),
               ),
             ),

             /* // School Name
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: false,
                color: Colors.white,
                fieldController: provider.schoolNameController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.schoolName,
                onTap: () {
                  schoolsBottomSheet(
                    context: context,
                    schoolName: provider.schoolNameController.text,
                    provider: provider,
                  );
                },
              ),

              // State
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.stateController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.state,
                onTap: () {
                  stateBottomSheet(context: context, provider: provider);
                },
              ),

              // City
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                color: Colors.white,
                fieldController: provider.cityController,
                margin: const EdgeInsets.only(left: 15, right: 15),
                hintName: StringHelper.city,
                onTap: () {
                  if (provider.stateController.text.isNotEmpty) {
                    cityBottomSheet(context: context, provider: provider);
                  } else {
                    Fluttertoast.showToast(msg: "Please select state");
                  }
                },
              ),*/

              // Submit
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child:CustomButton(
                  name: StringHelper.submit,
                  height: 50,
                  onTap: () {
                    MixpanelService.track("Signup Button Clicked", properties: {
                      "child_name": provider.chileNameController.text,
                      "gender": provider.sexController.text,
                      "dob": provider.dobController.text,
                      "grade": provider.gradeController.text,
                      "section": provider.sectionController.text,
                      "school_code": provider.schoolCodeController.text,
                      "school_name": provider.schoolNameController.text,
                      "state": provider.stateController.text,
                      "city": provider.cityController.text,
                      "timestamp": DateTime.now().toIso8601String(),
                    });

                    provider.registerStudent(context);
                  },
                ),

              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("https://wa.me/918793626696text=Hello there,\nI have a question.\n\n"));
                  },
                  child: const Text(
                    "Facing a challenge? Message us!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 18,
                  ),

                  SizedBox(width: 10),
                  Text(
                    StringHelper.aLifeLabProduct,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
