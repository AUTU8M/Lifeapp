import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/string_helper.dart';


class AskQuestionWidget extends StatelessWidget {
  const AskQuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              StringHelper.askQuestion,
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

        SizedBox(
          height: 170,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFF7FAD),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const Positioned(
                top: 25,
                left: 20,
                child: Text(
                  StringHelper.askQuestionTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                bottom: 22,
                left: 20,
                child: InkWell(
                  onTap: () {
                    // TODO
                    Fluttertoast.showToast(msg: "Coming soon");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: const Color(0xffCB1255),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child:  const Text(
                      StringHelper.askQuestion,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Container(
                  alignment: Alignment.topRight,
                  height: 190,
                  child: Image.asset(
                    ImageHelper.boboIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
