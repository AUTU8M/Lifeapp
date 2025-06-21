import 'package:flutter/material.dart';

import '../../../../common/helper/color_code.dart';
import '../../../nav_bar/presentations/pages/nav_bar_page.dart';

class FriendReqSendPage extends StatefulWidget {

  final String name;

  const FriendReqSendPage({Key? key, required this.name}) : super(key: key);

  @override
  State<FriendReqSendPage> createState() => _FriendReqSendPageState();
}

class _FriendReqSendPageState extends State<FriendReqSendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .15),
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                child: Image.asset("assets/images/tick.png"),
              ),

              const SizedBox(height: 30),
              const Text(
                "Friend request sent!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: Text(
                  "Once ${widget.name} \naccepts your friend request you\nwill be "
                      "friends\nthen you can share or\nexchange coins! and support each other",
                  style: const TextStyle(
                    color: Colors.black26,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Button
              const SizedBox(height: 50),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  const NavBarPage(
                            currentIndex: 0,
                          )));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                    color: ColorCode.buttonColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Got it!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
