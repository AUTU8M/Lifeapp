import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/student/hall_of_fame/provider/hall_of_fame_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class HallOfFameQuizWidget extends StatelessWidget {
  const HallOfFameQuizWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HallOfFameProvider>(context);
    return Column(
      children: [
        RepaintBoundary(
          key: provider.brainPointKey,
          child: Card(
            margin: const EdgeInsets.only(top: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            surfaceTintColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorCode.buttonColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Coins Champion",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        // left: 40,
                        child: Image.asset(
                          "assets/images/3_star.png",
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15,),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: const Color(0xffFFDAA4),
                                child: provider.hall!.data!.quizChampion!.user!.profileImage != null
                                    ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    "https://media.gappubobo.com/${provider.hall!.data!.quizChampion!.user!.profileImage!}",
                                  ),
                                )
                                    : const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    ImageHelper.pragyaIcon,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .3,
                                    child: Text(
                                      provider.hall!.data!.quizChampion!.user!.name!,
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
                                      provider.hall!.data!.quizChampion!.user!.state!,
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

                          Column(
                            children: [
                              const Text(
                                "Coins",
                                style:  TextStyle(
                                  color: Color(0xff4E4E4E),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                maxLines: 1,
                              ),

                              Row(
                                children: [
                                  Image.asset(
                                    ImageHelper.coinIcon,
                                    height: 30,
                                  ),
                                  Container(
                                    height: 30,
                                    width: 100,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color : const Color(0xffD76F1A),
                                    ),
                                    child: Center(
                                      child: Text(
                                        provider.hall!.data!.quizChampion!.totalCoins!.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            provider.shareBrainPoint(context);
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
