
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/quiz/presentations/pages/quiz_subject_page.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../questions/presentations/quiz_review_page.dart';
import '../../model/quiz_history_model.dart';
import '../../provider/quiz_provider.dart';

class MyQuizPage extends StatefulWidget {
  const MyQuizPage({Key? key}) : super(key: key);

  @override
  State<MyQuizPage> createState() => _MyQuizPageState();
}

class _MyQuizPageState extends State<MyQuizPage> {

  QuizHistoryModel? quizHistoryModel;

  String getTime(int time) {
    String data = "";
    switch (time) {

      case 30:
        data = "30 Seconds";
        break;

      case 60:
        data = "60 Seconds";
        break;

      case 120:
        data = "2 Minutes";
        break;

      case 300:
        data = "5 Minutes";
        break;
    }

    return data;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<QuizProvider>(context, listen: false).getQuizHistory(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quizHistoryModel = Provider.of<QuizProvider>(context).quizHistoryModel;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: commonAppBar(context: context, name: "My Quiz"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              _cardWidget(height: height, width: width),
              if (quizHistoryModel != null) _quizBoard(),
            ],
          ),
        ));
  }

  Widget _cardWidget({height, width}) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height * 0.17,
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xff949DFE),
                borderRadius: BorderRadius.circular(35)),
          ),
          Container(
            margin: EdgeInsets.only(right: width * 0.40, bottom: height * 0.08),
            child: const Text("Your are playing good",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.only(right: width * 0.59, bottom: height * 0.02),
            child: const Text("keep it up!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          InkWell(
            onTap: () {
              push(
                context: context,
                page: const SubjectQuizPage(),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: width * 0.44, top: height * 0.08),
              alignment: Alignment.center,
              height: height * 0.055,
              width: width * 0.4,
              decoration: BoxDecoration(
                  color: ColorCode.buttonColor,
                  borderRadius: BorderRadius.circular(30)),
              child: const Text("Get started!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.5, bottom: width * 0.03),
            height: width * 0.390,
            width: width * 0.35,
            child: Image.asset("assets/images/box.png"),
          ),
        ],
      );

  Widget _quizBoard() => SizedBox(
        height: MediaQuery.of(context).size.height - 250 - (MediaQuery.of(context).size.height * 0.17),
        child: ListView.builder(
          shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          itemCount: quizHistoryModel!.data!.data!.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
                onTap: () {
                  push(
                    context: context,
                    page: QuizReviewPage(
                      quizId: quizHistoryModel!.data!.data![index].id!.toString(),
                      name: "quiz",
                    ),
                  );
                },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .6,
                              child: Text(
                                quizHistoryModel!.data!.data![index].subject!.title!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "Level: ${quizHistoryModel!.data!.data![index].level!.title!}",
                              style: const TextStyle(
                                color: ColorCode.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              ImageHelper.coinIcon,
                              height: 25,
                              width: 25,
                            ),
                            Text(
                              quizHistoryModel!.data!.data![index].coins!.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _participantWidget(index),

                        Text(
                          getTime(quizHistoryModel!.data!.data![index].time!),
                          style: const TextStyle(
                            color: ColorCode.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _participantWidget(int index) => SizedBox(
    width: MediaQuery.of(context).size.width * .5,
    child: Wrap(
      spacing: 15,
      runSpacing: 10,
      children: quizHistoryModel!.data!.data![index].participants!.map((e) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          e.user!.profileImage != null ? CircleAvatar(
            radius: 10,
            backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + e.user!.profileImage!),
          ) : const CircleAvatar(
            radius: 10,
            backgroundImage: AssetImage("assets/images/mentor.png"),
          ),
          const SizedBox(width: 05),
          Text(
            e.user!.name!,
            style: const TextStyle(
              color: ColorCode.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      )).toList()
    ),
  );


}
