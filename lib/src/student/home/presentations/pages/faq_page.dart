import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_accessibility_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_challanges_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_coins_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_jigyasa_pragya_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_mentor_connect_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_mission_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_profile_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_quizz_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_ranking_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_referrals_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_shop_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_subjects_widget.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/faq_tracker_widget.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: SingleChildScrollView(
        padding:  EdgeInsets.only(left: 15, right: 15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. ${StringHelper.faq}s",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10,),
              FaqCoinsWidget(),
              FaqAccessibilityWidget(),
              FaqProfileWidget(),
              FaqMissionWidget(),
              FaqMentorConnectWidget(),
              FaqJigyasaPragyaWidget(),
              FaqQuizWidget(),
              FaqShopWidget(),
              FaqTracerWidget(),
              FaqRankingWidget(),
              FaqSubjectsWidget(),
              FaqChallengesWidget(),
              FaqReferralsWidget(),

              SizedBox(height: 40,)
          
          
          
            ],
          ),
        ),
      ),
    );
  }
}
