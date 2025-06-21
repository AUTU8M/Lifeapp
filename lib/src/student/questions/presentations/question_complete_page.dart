import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/questions/presentations/quiz_review_page.dart';
import 'package:lifelab3/src/student/questions/provider/question_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/color_code.dart';
import '../../../common/helper/image_helper.dart';
import '../../nav_bar/presentations/pages/nav_bar_page.dart';

class CompletedPage extends StatefulWidget {
  final String quizId;
  final String time;
  final String name;

  const CompletedPage({Key? key, required this.quizId, required this.time, required this.name})
      : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {


  @override
  void initState() {
    Provider.of<QuestionProvider>(context, listen: false).quizResult(id: widget.quizId);

    Timer(const Duration(seconds: 5), () {
      Provider.of<QuestionProvider>(context, listen: false).quizResult(id: widget.quizId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Lottie.asset(
            "assets/lottie/comic_new.json",
            repeat: true,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          _body(provider),
        ],
      ),
    );
  }

  Widget _body(QuestionProvider provider) => SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 15, right: 15, top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "${widget.name}\n"
              "Completed!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorCode.buttonColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Colors.black87),
                text: "you have done a great job!",
              ),
            ),
            const SizedBox(height: 20),
            if(widget.time != "null") Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/sandtime.png",
                  height: 25,
                  width: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  "${widget.time} seconds",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            if (provider.resultModel != null) _scoreBoard(provider),
            _homeButton(),
            const SizedBox(height: 20),
            _startQuizButton(),
            const SizedBox(height: 20),
            _reviewButton(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
            const SizedBox(height: 20),
          ],
        ),
      );

  Widget _homeButton() => InkWell(
        onTap: () {
          push(
            context: context,
            page: const NavBarPage(
              currentIndex: 0,
            ),
            withNavbar: true,
          );
        },
        child: Container(
          alignment: Alignment.center,
          height: 45,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
              color: ColorCode.buttonColor, borderRadius: BorderRadius.circular(30)),
          child: const Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _startQuizButton() => InkWell(
        onTap: () {
          Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          height: 45,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ColorCode.buttonColor),
          ),
          child: Text(
            "Start another ${widget.name}",
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _reviewButton() => InkWell(
        onTap: () {
          push(
            context: context,
            page: QuizReviewPage(quizId: widget.quizId, name: widget.name),
          );
        },
        child: Container(
          alignment: Alignment.center,
          height: 45,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
              color: ColorCode.buttonColor, borderRadius: BorderRadius.circular(30)),
          child: const Text(
            "Review",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _scoreBoard(QuestionProvider provider) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.resultModel!.data!.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            alignment: Alignment.center,
            // height: height * 0.11,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ColorCode.buttonColor),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                provider.resultModel!.data![index].user!.profileImage == null
                    ? const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/mentor.png"),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(ApiHelper.imgBaseUrl +
                            provider.resultModel!.data![index].user!.profileImage!),
                      ),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.resultModel!.data![index].user!.name!,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                    Text(
                      "${provider.resultModel!.data![index].totalCorrectAnswers!} Correct answers",
                      style: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.normal,
                          fontSize: 10),
                    ),
                    Text(
                      "${provider.resultModel!.data![index].totalWrongAnswers} Wrong answers",
                      style: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.normal,
                          fontSize: 10),
                    )
                  ],
                ),
                const Spacer(),
                if(provider.resultModel!.data![index].coins != null) Row(
                  children: [
                    Image.asset(
                      ImageHelper.coinIcon,
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 05),
                    Text(
                      "${provider.resultModel!.data![index].coins!} coins",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
