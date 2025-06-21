import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/mission/provider/mission_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../nav_bar/presentations/pages/nav_bar_page.dart';

class MissionSuccessPage extends StatefulWidget {

  final int? id;

  const MissionSuccessPage({Key? key, this.id}) : super(key: key);


  @override
  State<MissionSuccessPage> createState() => _MissionSuccessPageState();
}

class _MissionSuccessPageState extends State<MissionSuccessPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MissionProvider>(context, listen: false).getMissionDetails(context, widget.id!.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<MissionProvider>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Stack(
              children: [
                Lottie.asset(
                  "assets/lottie/comic_new.json",
                  repeat: true,
                  height: height,
                  fit: BoxFit.fill,
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 15, right: 15,
                  ),
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Padding(padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            SizedBox(height: height*0.02,),
                            const Text("Submitted!",style: TextStyle(color: ColorCode.buttonColor,fontSize: 35,fontWeight: FontWeight.bold),),
                            SizedBox(height: height*0.02,),
                            SizedBox(
                              height: 180,
                              width: 180,
                              child: Image.asset("assets/images/box.png"),
                            ),
                            SizedBox(height: height*0.02,),
                            const Text("Your activity is under review\n"
                                "You will be awarded soon!",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                            SizedBox(height: height*0.02,),
                            const Text("Your next mission will be\n"
                                "unlocked after the review",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                            SizedBox(height: height*0.02,),

                            widget.id!=null?CachedNetworkImage(
                              imageUrl: "${ApiHelper.imgBaseUrl}${provider.missionDetailsModel?.data?.submission?.media?.url}",
                              progressIndicatorBuilder: (context, url, progress) {
                                return const Center(child: CircularProgressIndicator());
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height: width * 0.5,
                                  width: width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(image: imageProvider)
                                  ),
                                );
                              },
                            ):
                            Container(
                              height: width * 0.5,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(image: AssetImage("assets/images/balloon.png"),fit: BoxFit.cover)
                              ),
                              // child: Image.asset("assets/images/balloon.png",
                              //     fit: BoxFit.fill),
                            ),
                            SizedBox(height: height*0.05,),
                            InkWell(
                              onTap: (){
                                push(
                                  context: context,
                                  page: const NavBarPage(currentIndex: 0,),
                                  withNavbar: true,
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height*0.06,
                                decoration: BoxDecoration(
                                  color: ColorCode.buttonColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "home",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 100),


                          ],
                        ),
                      )
                  ),
                ),
              ],
            ),
        ),
    );
  }
}