import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../../../../common/helper/color_code.dart';

class TimeQuizPage extends StatefulWidget {

  final String subjectId;

  const TimeQuizPage({Key? key, required this.subjectId}) : super(key: key);

  @override
  State<TimeQuizPage> createState() => _TimeQuizPageState();
}

class _TimeQuizPageState extends State<TimeQuizPage> {

  String selectedTime = '';

  List<String> timeString = ["30 seconds", "60 seconds", "2 minute", "5 minute"];
  List<bool> timeSelection = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _nextButton(),
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
          "Choose the time you want to play in",
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

  List<Widget> _listOfSubject(double height, double width) => timeString.map((e) => _levelButton(
    height: height,
    width: width,
    name: e,
  )).toList();

  Widget _levelButton({required double height, required double width, required String name}) => InkWell(
    onTap: () {
      timeSelection = [false, false, false, false];
      timeSelection[timeString.indexOf(name)] = true;
      switch(name) {
        case "30 seconds":
          selectedTime = "30";
          break;

        case "60 seconds":
          selectedTime = "60";
          break;

        case "2 minute":
          selectedTime = "120";
          break;

        case "5 minute":
          selectedTime = "300";
          break;

        default:
          selectedTime = "30";
          break;
      }
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
        color: timeSelection[timeString.indexOf(name)] ? ColorCode.buttonColor : Colors.white,
        border: timeSelection[timeString.indexOf(name)] ? null : Border.all(color: ColorCode.buttonColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: timeSelection[timeString.indexOf(name)] ? Colors.white : Colors.purple,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  Widget _nextButton() => InkWell(
    onTap: () {
      if(selectedTime.isNotEmpty) {
        // TODO
        // push(
        //   context: context,
        //   page: StartQuizPage(
        //     subjectId: widget.subjectId,
        //     time: selectedTime,
        //   ),
        // );
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
        bottom: MediaQuery.of(context).padding.bottom + 40,
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
