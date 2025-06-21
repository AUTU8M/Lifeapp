import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/string_helper.dart';

class MoodMeterWidget extends StatelessWidget {
  const MoodMeterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              StringHelper.moodMeter,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 10),
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorCode.buttonColor,
              child: Text(
                "i",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffFFBC7F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    StringHelper.moodMeterTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // TODO
                      Fluttertoast.showToast(msg: "Coming soon");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xffCB1255),
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                      child:  const Text(
                        StringHelper.checkYourMood,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Image.asset(
                ImageHelper.moodMeterIcon,
                width: MediaQuery.of(context).size.width * .3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
