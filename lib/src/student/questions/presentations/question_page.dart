import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/student/questions/models/question_model.dart';
import 'package:lifelab3/src/student/questions/presentations/question_complete_page.dart';
import 'package:lifelab3/src/student/questions/services/que_services.dart';
import 'package:lottie/lottie.dart';

import '../../../common/helper/color_code.dart';

class QuestionPage extends StatefulWidget {

  final QuestionModel questionsModel;
  final int? time;
  final String quizId;
  final String name;

  const QuestionPage({super.key, required this.questionsModel, required this.time, required this.quizId, required this.name});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin {

  PageController pageController = PageController(initialPage: 0);

  late AnimationController animationController;

  bool isCompleted = false;

  List<String> answerList = [];

  List<Map<String, dynamic>> answerMap = [];

  submit() async {
    Response response = await QueServices().submitQuiz(
      data: {
        "answers": answerMap,
      },
      id: widget.quizId,
    );

    if(response.statusCode == 200) {
      quizCompleteDialog();
    } else {
      Navigator.pop(context);
    }
  }


  @override
  void initState() {
    if(widget.time != null) {
      animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.time!),
      )..addListener(() {
        if(animationController.isCompleted) {
          submit();
        }
        setState(() {});
      });
      animationController.forward();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      answerList = List.generate(widget.questionsModel.data!.data!.length, (index) => "");
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    if(widget.time != null) animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cancelPopup();
        return false;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              _cancelPopup();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            Lottie.asset(
              "assets/lottie/comic_new.json",
              repeat: true,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
            answerList.isNotEmpty ? _body() : const Center(
              child: Text(
                "Question are not available",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() => SingleChildScrollView(
    padding: EdgeInsets.only(
        left: 15, right: 15, top: MediaQuery.of(context).padding.top),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if(widget.time != null) LinearProgressIndicator(
          value: animationController.value,
          color: Colors.purple,
        ),
        const SizedBox(height: 80),
        _questionWidget(),
      ],
    ),
  );

  Widget _questionWidget() => SizedBox(
    height: MediaQuery.of(context).size.height - 200,
    child: PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.questionsModel.data!.data!.length,
      itemBuilder: (context, index) => Column(
        children: [
          Text(
            "Question ${index+1}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ColorCode.buttonColor,
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),
          widget.questionsModel.data!.data![index].title! is String ? Text(
            utf8.decode(widget.questionsModel.data!.data![index].title!.toString().codeUnits),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ) : CachedNetworkImage(
            imageUrl: ApiHelper.imgBaseUrl + widget.questionsModel.data!.data![index].title!["url"],
            placeholder: (context, _) => const LoadingWidget(height: 100,),
            height: 200,
          ),

          const SizedBox(height: 30),
          ..._listOfOptions(
              widget.questionsModel.data!.data![index].questions!,
              index,
              widget.questionsModel.data!.data![index].id!,
              widget.questionsModel.data!.data![index].answer!
          ),

          const Spacer(),
          _nextQueButton(index),
        ],
      ),
    ),
  );

  List<Widget> _listOfOptions(List<Questions> options, int index, int questionId, Answer answer) => options.map((e) => _levelButton(
    e: e,
    index: index,
    questionId: questionId,
    answer: answer,
  )).toList();

  Widget _levelButton({required Questions e, required int index, required int questionId, required Answer answer}) => InkWell(
    onTap: () {
      answerList[index] = e.id!.toString();
      debugPrint("Answer List: $answerList");
      answerMap.removeWhere((element) => element["question_id"] == questionId);

      answerMap.add({
        "question_id": questionId,
        "answer_id": e.id!,
      });

      debugPrint("Answers: $answerMap");
      setState(() {});
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      alignment: Alignment.center,
      // height: MediaQuery.of(context).size.height * 0.04,
      width: MediaQuery.of(context).size.width * 0.6,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: answerList[index] == e.id!.toString() ? Colors.purple : Colors.white,
        border: Border.all(color: ColorCode.buttonColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        utf8.decode(e.title!.codeUnits),
        style: TextStyle(
          color: answerList[index] == e.id!.toString() ? Colors.white : Colors.purple,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _nextQueButton(int index) => InkWell(
    onTap: () {
      if(index+1 == answerList.length && widget.time == null) {
        submit();
      } else if(index+1 == answerList.length) {
        // Fluttertoast.showToast(msg: "Please wait for timer to complete.");
        submit();
      } else {
        if(answerList[index].isNotEmpty && !isCompleted) {
          pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.bounceOut);
        } else {
          Fluttertoast.showToast(msg: "Please select answer");
        }
      }
      setState(() {

      });
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      alignment: Alignment.center,
      height: 45,
      decoration: BoxDecoration(
        color: ColorCode.buttonColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        (index+1 == answerList.length) ? "Submit" : "Next",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  Widget _submitButton() => InkWell(
    onTap: () {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompletedPage(
        quizId: widget.quizId,
        time: widget.time.toString(),
        name: widget.name,
      )));
    },
    child: Container(
      alignment: Alignment.center,
      height: 45,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: ColorCode.buttonColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        "Submit",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  quizCompleteDialog() => showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/B2 1.png",
              height: MediaQuery.of(context).size.height * .2,
            ),

            const SizedBox(height: 20),
            Text(
              "${widget.name} Completed",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),
            _submitButton(),
          ],
        ),
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
  );

  _cancelPopup() => showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (ctx) => Container(
      height: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.only(bottom: 50),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.035,left: 20,right: 20),
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Do you want to\n"
                      "cancel the ${widget.name}?",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Text(
                  "You can start the ${widget.name}\n"
                      "again from starting",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xff7A7A7A),
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: ColorCode.buttonColor, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            color: ColorCode.buttonColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.32,
                        decoration: BoxDecoration(
                          color: ColorCode.buttonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 15,
            top: 0,
            child: Container(
              alignment: Alignment.topRight,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset(
                "assets/images/cancel.png",
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
