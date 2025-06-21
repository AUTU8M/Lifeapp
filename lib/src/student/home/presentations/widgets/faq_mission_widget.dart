import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

class FaqMissionWidget extends StatelessWidget {
  const FaqMissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        "IV. ${StringHelper.mission}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),


        // participent in mission
        Padding(
          padding: EdgeInsets.only(left: 18,top: 16),
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
                  StringHelper.participateInMission,
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
                  StringHelper.participateInMissionDetails,
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

        // what kind of reward i will earn by completing mission
        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "b.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.whatKindOfRewardIEarn,
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
                  StringHelper.whatKindOfRewardIEarnDetails,
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

        // mission i submited is still in review

        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "c.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.missionISubmitedIsStillInReview,
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
                  StringHelper.missionISubmitedIsStillInReviewDetails,
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

        // why mission is rejected

        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "d.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.whyMyMissionRejected,
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
                  StringHelper.whyMyMissionRejectedDetails,
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

        // why mission is Not Opening

        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "e.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Text(
                  StringHelper.whyMissionIsNotOpening,
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
                  StringHelper.whyMissionIsNotOpeningDetails,
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
