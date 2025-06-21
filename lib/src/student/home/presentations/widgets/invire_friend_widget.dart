import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendWidget extends StatelessWidget {

  final String name;

  const InviteFriendWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children:  [
            Text(
              "Invite a ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 03),
            Text(
              "friend!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(
          height: 160,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff4FC754),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const Positioned(
                top: 30,
                left: 20,
                child: Text(
                  StringHelper.inviteFriendTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 20,
                child: InkWell(
                  onTap: () {
                    String text = "Hello"
                        "\nThis is $name"
                        "\n\nI invite you to use this amazing learning platform which i am using called LIFEAPP"
                        "\nPlease download the app from here and signup"
                        "\n will look to connect you on the app!"
                        "\n https://onelink.to/kf253d";
                    Share.share(text);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xff249029),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: const Text(
                      StringHelper.invite,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -15,
                bottom: 15,
                child: Container(
                  alignment: Alignment.topRight,
                  height: 160,
                  child: Image.asset(
                    ImageHelper.girlIcon,
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
