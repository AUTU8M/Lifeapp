import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/student/hall_of_fame/provider/hall_of_fame_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class HallOfFameMissionWidget extends StatelessWidget {
  const HallOfFameMissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HallOfFameProvider>(context);
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          elevation: 10,
          child: RepaintBoundary(
            key: provider.activityKey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70,left: 65),
                  child: Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundColor: const Color(0xffFFDAA4),
                              child: provider.hall!.data!.missionChampion!.user!.profileImage != null ? CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  "https://media.gappubobo.com/${provider.hall!.data!.missionChampion!.user!.profileImage}",
                                ),
                              ) : const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  ImageHelper.profileImg,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Text(
                                    provider.hall!.data!.missionChampion!.user!.name!,
                                    style: const TextStyle(
                                      color: Color(0xff4E4E4E),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Text(
                                    provider.hall!.data!.missionChampion!.user!.state!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    softWrap: true,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorCode.buttonColor,
                    ),
                    child: const Center(
                      child: Text(
                        "Mission Champion",
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  // left: 40,
                  child: Image.asset(
                    "assets/images/3_star.png",
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            provider.shareActivityPoint(context);
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorCode.buttonColor,
            ),
            child: const Center(
              child: Text(
                "Share",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
