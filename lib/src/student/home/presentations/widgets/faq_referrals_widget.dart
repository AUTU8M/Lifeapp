import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

class FaqReferralsWidget extends StatelessWidget {
  const FaqReferralsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "XIII. ${StringHelper.referrals}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

// available challenges on app
        Padding(
          padding: EdgeInsets.only(left: 18 , top : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "a.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.howIcanInviteFriendOnTheApp,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only( left: 30,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("-",  style: TextStyle(
                color: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w800,

              ),),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.howIcanInviteFriendOnTheAppDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24,),



      ],
    );
  }
}
