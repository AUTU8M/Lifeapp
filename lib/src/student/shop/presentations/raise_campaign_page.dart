import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../common/helper/color_code.dart';

class RaisedCampaignPage extends StatefulWidget {
  const RaisedCampaignPage({Key? key}) : super(key: key);

  @override
  State<RaisedCampaignPage> createState() => _RaisedCampaignPageState();
}

class _RaisedCampaignPageState extends State<RaisedCampaignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() => Center(
    child: Stack(
      children: [
        Lottie.asset("assets/lottie/comic_new.json",repeat: true,height: double.infinity,fit: BoxFit.fill),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: Lottie.asset("assets/lottie/no_coins.json",repeat: true,fit: BoxFit.fill),
            ),

            const SizedBox(height: 30),
            const Text(
              "Sorry\nYou don't have\nenough coins!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorCode.buttonColor,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Text(
                "Perform vision or missions or play a new quiz and get a chance to earn coins ",
                style: TextStyle(
                  color: Colors.black.withOpacity(.8),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),


            // Under Review
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorCode.buttonColor,
                ),
                child: const Center(
                  child: Text(
                    "Got it!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
