import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/quiz/presentations/pages/quiz_time_page.dart';
import 'package:lifelab3/src/student/quiz/services/quiz_services.dart';
import 'package:lottie/lottie.dart';

import '../../../../common/helper/color_code.dart';

class SubjectQuizPage extends StatefulWidget {
  const SubjectQuizPage({Key? key}) : super(key: key);

  @override
  State<SubjectQuizPage> createState() => _SubjectQuizPageState();
}

class _SubjectQuizPageState extends State<SubjectQuizPage> {

  String _subjectId = '';

  Map<String, dynamic> subjectData = {};

  List<dynamic> _subjectList = [];
  List<bool> _selectSubjectList = [];

  getSubjectData() async {
    Response response = await QuizServices().getQuizSubjectData();

    if (response.statusCode == 200 || response.statusCode == 201) {
      subjectData = response.data;
      _subjectList = subjectData["data"]["subject"];
      _selectSubjectList = List.generate(_subjectList.length, (index) => false);
      setState(() {});
    }
  }

  @override
  void initState() {
    getSubjectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: _nextButton(),
      extendBody: true,
      body: Stack(
        children: [
          Lottie.asset(
            "assets/lottie/comic_new.json",
            repeat: true,
            height: height,
            fit: BoxFit.fill,
          ),
          _body(height: height, width: width),
        ],
      ),
    );
  }

  Widget _body({required double height, required double width}) => SingleChildScrollView(
    padding: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).padding.top),
    child: Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 35,
              width: 35,
              child: Icon(
                Icons.close,
                color: Colors.lightBlue[50],
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.1),
        const Text(
          "Start a new\n"
          "quiz round!\n",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorCode.buttonColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Choose the subject you want to play in",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 30),
        ..._listOfSubject(height, width),
      ],
    ),
  );

  List<Widget> _listOfSubject(double height, double width) => _subjectList.map((e) => _levelButton(
    height: height,
    width: width,
    e: e,
  )).toList();

  Widget _levelButton({required double height, required double width, required Map e,}) => InkWell(
    onTap: () {
      _selectSubjectList = List.generate(_subjectList.length, (index) => false);
      _selectSubjectList[_subjectList.indexOf(e)] = true;
      _subjectId = e["id"].toString();
      setState(() {});
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      alignment: Alignment.center,
      height: height * 0.04,
      width: width * 0.6,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _selectSubjectList[_subjectList.indexOf(e)] ? ColorCode.buttonColor : Colors.white,
        border: _selectSubjectList[_subjectList.indexOf(e)] ? null : Border.all(color: ColorCode.buttonColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        e["title"],
        style: TextStyle(
          color: _selectSubjectList[_subjectList.indexOf(e)] ? Colors.white : Colors.purple,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  Widget _nextButton() => InkWell(
    onTap: () {
      if(_subjectId.isNotEmpty) {
        push(
          context: context,
          page: TimeQuizPage(subjectId: _subjectId),
        );
      } else {
        Fluttertoast.showToast(msg: "Please select subject");
      }
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      height: 45,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorCode.buttonColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        "Next",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
