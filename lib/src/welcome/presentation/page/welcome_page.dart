import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/welcome/presentation/page/select_user_page.dart';

class WelComePage extends StatelessWidget {
  const WelComePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(ImageHelper.welcomeImg1),

              const SizedBox(height: 80),
              const Text(
                StringHelper.welcomeToLifeApp,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                StringHelper.welcomeMsg,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 80),
              CustomButton(
                name: StringHelper.getStarted,
                height: 45,
                width: MediaQuery.of(context).size.width * .7,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectUserPage()));
                },
              ),

              const SizedBox(height: 70),
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
            ],
          ),
        ),
      ),
    );
  }
}
