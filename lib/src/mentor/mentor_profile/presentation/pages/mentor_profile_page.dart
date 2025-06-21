import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelab3/src/mentor/mentor_home/provider/mentor_home_provider.dart';
import 'package:lifelab3/src/mentor/mentor_profile/provider/mentor_profile_provider.dart';
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

class MentorMyProfilePage extends StatefulWidget {
  const MentorMyProfilePage({super.key});

  @override
  State<MentorMyProfilePage> createState() => _MentorMyProfilePageState();
}

class _MentorMyProfilePageState extends State<MentorMyProfilePage> {

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
          toolbarColor: ColorCode.buttonColor, // Use your app's color theme
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square, // 1:1 ratio
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
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

      
      await ProfileService().uploadProfile(File(cropped.path));
      // Rest of your code...
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
      await Provider.of<MentorHomeProvider>(context, listen: false).getDashboardData();
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Something went to wrong");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MentorProfileProvider>(context, listen: false).mentorNameController.text = Provider.of<MentorHomeProvider>(context, listen: false).dashboardModel!.data!.user!.name ?? "";

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MentorProfileProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profile(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mentor Name",
                    style: TextStyle(
                      color: ColorCode.textBlackColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    readOnly: false,
                    color: Colors.white,
                    fieldController: provider.mentorNameController,
                    hintName: "Mentor Name",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
              child: CustomButton(
                name: "Update",
                height: 50,
                onTap: () {
                  provider.update(context);
                },
              ),
            ),
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
                Provider.of<MentorHomeProvider>(context)
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
                              Provider.of<MentorHomeProvider>(context)
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
              "Mentor Code: ${Provider.of<MentorHomeProvider>(context, listen: false).dashboardModel!.data!.user!.mentorCode!}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Mobile No: ${Provider.of<MentorHomeProvider>(context, listen: false).dashboardModel!.data!.user!.mobileNo}",
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
}
