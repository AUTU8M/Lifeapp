import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:lifelab3/src/teacher/teacher_profile/provider/teacher_profile_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/api_helper.dart';
import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/common_navigator.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../student/profile/services/profile_services.dart';
import '../../../../utils/storage_utils.dart';
import '../../../../welcome/presentation/page/welcome_page.dart';
import '../widgets/teacher_board_sheet.dart';
import '../widgets/teacher_grade_sheet.dart';
import '../widgets/teacher_section_sheet.dart';
import '../widgets/teacher_subject_sheet.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  bool isLoading = true;

  _loadPicker(ImageSource source) async {
    XFile? picked =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (picked != null) {
      _cropImage(picked);
    }
  }

  _cropImage(picked) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColorCode.buttonColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square, // 1:1 ratio
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (cropped != null) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(
          color: ColorCode.buttonColor,
        ),
        overlayColor: Colors.black54,
      );

      Response response =
          await ProfileService().uploadProfile(File(cropped.path));

      Loader.hide();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Profile photo updated");
        await Provider.of<TeacherDashboardProvider>(context, listen: false)
            .getDashboardData();
      } else {
        Fluttertoast.showToast(msg: "Try again later");
      }

      setState(() {});
    }
  }

  assetsToLogoFileImg(String imgPath) async {
    var randomNum = Random();
    final byteData = await rootBundle.load(imgPath);
    Directory tempDir = await getTemporaryDirectory();

    final file = File("${tempDir.path}${randomNum.nextInt(1000000)}.png");
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    Response response = await ProfileService().uploadProfile(file);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Profile photo updated");
      await Provider.of<TeacherDashboardProvider>(context, listen: false)
          .getDashboardData();
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Something went to wrong");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<TeacherProfileProvider>(context, listen: false);
      final user = Provider.of<TeacherDashboardProvider>(context, listen: false)
          .dashboardModel!
          .data!
          .user!;

      debugPrint("Raw user data: ${user.toJson()}"); // Add this
      debugPrint(
          "Board data - ID: ${user.la_board_id}, Name: ${user.board_name}");
      debugPrint("la_board_id: ${user.la_board_id}");
      debugPrint("board_name: ${user.board_name}");
      debugPrint("la_board_id type: ${user.la_board_id?.runtimeType}");
      debugPrint("board_name type: ${user.board_name?.runtimeType}");

      // Load initial data
      provider.getSchoolList();
      provider.getStateCityList();
      provider.getSectionList();
      provider.getBoardList().then((_) {
        if (user.la_board_id?.isNotEmpty == true &&
            user.board_name?.isNotEmpty == true) {
          debugPrint(
              "Setting board from user data: ${user.la_board_id} - ${user.board_name}");
          provider.setInitialBoard(user.la_board_id, user.board_name);
        } else {
          debugPrint("No valid board data in user object");
        }
      });
      provider.getSubjectList();

      // Set user data
      provider.schoolNameController.text =
          user.school != null ? user.school!.name! : "";
      provider.teacherNameController.text = user.name != null ? user.name! : "";
      provider.sectionController.text =
          user.section != null ? user.section!.name! : "";
      provider.sectionId = user.section?.id;
      provider.dobController.text = user.dob ?? "";
      provider.gradeController.text =
          user.grade != null ? user.grade!.name.toString() : "";
      provider.stateController.text = user.state ?? "";
      provider.cityController.text = user.city ?? "";
      provider.schoolCodeController.text =
          user.school != null ? user.school!.code.toString() ?? "" : "";

      provider.setInitialDOB(user.dob);

      debugPrint(
          "Setting initial board - ID: ${user.la_board_id}, Name: ${user.board_name}");
      debugPrint("Initial DOB from user: ${user.dob}");
      // Clear existing grade list
      provider.gradeMapList.clear();

      // Format DOB if it exists
      if (user.dob != null && user.dob!.isNotEmpty) {
        try {
          final DateTime dobDate = DateTime.parse(user.dob!);
          provider.dobController.text =
              "${dobDate.year}-${dobDate.month.toString().padLeft(2, '0')}-${dobDate.day.toString().padLeft(2, '0')}";
          provider.date = dobDate;
        } catch (e) {
          provider.dobController.text = "";
          provider.date = DateTime.now();
        }
      } else {
        provider.dobController.text = "";
        provider.date = DateTime.now();
      }

      // Add existing grades if available
      if (user.laTeacherGrades != null && user.laTeacherGrades!.isNotEmpty) {
        for (var element in user.laTeacherGrades!) {
          provider.gradeMapList.add({
            "la_grade_id": element.grade!.id!.toString(),
            "la_section_id": element.section!.id!.toString(),
            "la_section_name": element.section!.name!,
            "subjects": element.subject!.id!.toString(),
            "subject_name": element.subject!.title!
          });
        }
      } else {
        // Only add empty grade entry if no existing grades
        provider.initializeGradeMapList();
      }

      provider.gradeList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherProfileProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profile(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  // Teacher Name
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Teacher Name",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: false,
                        color: Colors.white,
                        fieldController: provider.teacherNameController,
                        hintName: "Teacher Name",
                      ),
                    ],
                  ),

                  // School Name
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "School Code",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          // School Name
                          const SizedBox(height: 20),
                          Expanded(
                            child: CustomTextField(
                              readOnly: false,
                              color: Colors.white,
                              fieldController: provider.schoolCodeController,
                              hintName: "Enter school code",
                              onChange: (val) {
                                provider.isSchoolCodeValid = false;
                                provider.addNewGradeEntry();
                              },
                            ),
                          ),

                          if (!provider.isSchoolCodeValid)
                            TextButton(
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
                    ],
                  ),

                  const SizedBox(height: 20),
                  if (provider.isSchoolCodeValid)
                    Padding(
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
                                  text:
                                      " ,${provider.stateController.text}, ${provider.cityController.text}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  )),
                            ]),
                      ),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      InkWell(
                        onTap: () {
                          provider.gradeMapList.add({
                            "la_grade_id": "",
                            "la_section_id": "",
                            "subjects": "",
                            "la_section_name": "",
                            "subject_name": ""
                          });
                          provider.addNewGradeEntry();
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              "Add +",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ...provider.gradeMapList
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                // Grade
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      StringHelper.grade,
                                      style: TextStyle(
                                        color: ColorCode.textBlackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      readOnly: true,
                                      width: 50,
                                      color: Colors.white,
                                      fieldController: TextEditingController(
                                          text: e["la_grade_id"]),
                                      hintName: StringHelper.grade,
                                      onTap: () {
                                        teacherProfileGradeListBottomSheet(
                                            context, provider, e);
                                      },
                                    ),
                                  ],
                                ),

                                // Section
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      StringHelper.section,
                                      style: TextStyle(
                                        color: ColorCode.textBlackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      readOnly: true,
                                      width: 50,
                                      color: Colors.white,
                                      fieldController: TextEditingController(
                                          text: e["la_section_name"]),
                                      hintName: StringHelper.section,
                                      onTap: () {
                                        teacherProfileSectionListBottomSheet(
                                            context, provider, e);
                                      },
                                    ),
                                  ],
                                ),

                                // Subject
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Subject",
                                        style: TextStyle(
                                          color: ColorCode.textBlackColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        readOnly: true,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                180,
                                        color: Colors.white,
                                        fieldController: TextEditingController(
                                            text: e["subject_name"]),
                                        hintName: "Subject",
                                        onTap: () {
                                          teacherSubjectListBottomSheet(
                                              context, provider, e);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                  /* // Grade
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringHelper.grade,
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.gradeController,
                        hintName: StringHelper.grade,
                        onTap: () {
                          teacherProfileGradeListBottomSheet(context, provider);
                        },
                      ),
                    ],
                  ),

                  // Section
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringHelper.section,
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.sectionController,
                        hintName: StringHelper.section,
                        onTap: () {
                          teacherProfileSectionListBottomSheet(context, provider);
                        },
                      ),
                    ],
                  ),

                  // Subject
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Subject",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.subjectController,
                        hintName: "Subject",
                        onTap: () {
                          teacherSubjectListBottomSheet(context, provider);
                        },
                        suffix: provider.subjectController.text.isNotEmpty ? IconButton(
                          icon: const Icon(Icons.clear),
                          color: Colors.black54,
                          onPressed: () {
                            provider.subjectIdList.clear();
                            provider.subjectController.clear();
                            provider.notifyListeners();
                          },
                        ) : null,
                      ),
                    ],
                  ),*/

                  // Board
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Board",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.boardNameController,
                        hintName: "Board",
                        onTap: () {
                          teacherBoardListBottomSheet(context, provider);
                        },
                      ),
                    ],
                  ),

                  // DOB
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DOB",
                        style: TextStyle(
                          color: ColorCode.textBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        readOnly: true,
                        color: Colors.white,
                        fieldController: provider.dobController,
                        hintName: "DOB",
                        suffix: const Icon(Icons.calendar_month_rounded),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: provider
                                      .dobController.text.isNotEmpty
                                  ? DateTime.parse(provider.dobController.text)
                                  : provider.date,
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now());
                          if (picked != null) {
                            provider.updateDOB(picked);
                          }
                        },
                      ),
                    ],
                  ),

                  // Submit
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: CustomButton(
                      name: StringHelper.submit,
                      height: 50,
                      onTap: () {
                        provider.updateTeacher(
                            context,
                            Provider.of<TeacherDashboardProvider>(context,
                                    listen: false)
                                .dashboardModel!
                                .data!
                                .user!
                                .mobileNo!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Image.asset(
            "assets/images/back.png",
            height: 30,
            width: 30,
          ),
          color: Colors.white,
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () async {
                Loader.show(
                  context,
                  progressIndicator: const CircularProgressIndicator(
                    color: ColorCode.buttonColor,
                  ),
                  overlayColor: Colors.black54,
                );

                Response response = await ProfileService().logout();

                Loader.hide();

                if (response.statusCode == 200) {
                  StorageUtil.clearData();
                  Fluttertoast.showToast(msg: "Logout Successfully");
                  push(
                    context: context,
                    page: const WelComePage(),
                  );
                } else {
                  Fluttertoast.showToast(msg: "Something went to wrong");
                }
              },
              child: Image.asset(
                "assets/images/logout.png",
                height: 25,
                width: 25,
              ),
            ),
          ),
        ],
        elevation: 0,
      );

  Widget _profile() => Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          color: ColorCode.buttonColor,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            Stack(
              children: [
                Provider.of<TeacherDashboardProvider>(context)
                            .dashboardModel!
                            .data!
                            .user!
                            .imagePath !=
                        null
                    ? CircleAvatar(
                        radius: 80,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(ApiHelper.imgBaseUrl +
                              Provider.of<TeacherDashboardProvider>(context)
                                  .dashboardModel!
                                  .data!
                                  .user!
                                  .imagePath!),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 78,
                          backgroundImage: AssetImage(ImageHelper.profileImg),
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      chooseImageBottomSheet();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      "assets/images/cam.png",
                      height: 45,
                      width: 45,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Teacher Code: ${Provider.of<TeacherDashboardProvider>(context, listen: false).dashboardModel!.data!.user!.school?.id!}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Mobile No: ${Provider.of<TeacherDashboardProvider>(context, listen: false).dashboardModel!.data!.user!.mobileNo}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );

  chooseImageBottomSheet() => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 70),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload a photo",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              // Camera
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _loadPicker(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/Camera.png",
                      height: 35,
                      width: 35,
                      color: ColorCode.buttonColor,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Take a photo",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),

              // Gallery
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _loadPicker(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/gallery.png",
                      height: 35,
                      width: 35,
                      color: ColorCode.buttonColor,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Choose from Gallery",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),

              // or choose an avatar
              const SizedBox(height: 20),
              const Text(
                "or choose an avatar",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Avatar Screen
              const SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white70,
                ),
                child: ListView.builder(
                  itemCount: StringHelper.AVTAR_LIST.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      assetsToLogoFileImg(StringHelper.AVTAR_LIST[index]);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white70,
                      ),
                      child: Image.asset(
                        StringHelper.AVTAR_LIST[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    Provider.of<TeacherProfileProvider>(context, listen: false).resetState();
    super.dispose();
  }
}
