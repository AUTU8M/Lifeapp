
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/questions/services/que_services.dart';

import '../../../common/helper/color_code.dart';
import '../models/quiz_review_model.dart';


class QuizReviewPage extends StatefulWidget {

  final String quizId;
  final String name;

  const QuizReviewPage({super.key, required this.quizId, required this.name});

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {

  QuizReviewModel? quizReviewModel;


  List<Map<String,dynamic>> reviewList = [];

  void getQuizReviewData() async {

    Response response = await QueServices().quizReviewData(id: widget.quizId);

    if(response.statusCode == 200) {
      quizReviewModel = QuizReviewModel.fromJson(response.data);
      print(quizReviewModel!.toJson());
      setState(() {});
    }

  }

  @override
  void initState() {
    getQuizReviewData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, name: "${widget.name} Review"),
      body: quizReviewModel != null ? _body() : const SizedBox(),
    );
  }

  Widget _body() => ListView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 80),
    itemCount: quizReviewModel!.data!.length,
    itemBuilder: (context, index) => Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: Colors.black45.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
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
          quizReviewModel!.data![index].title! is String ? Text(
            utf8.decode(quizReviewModel!.data![index].title!.toString().codeUnits),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ) : CachedNetworkImage(imageUrl: ApiHelper.imgBaseUrl + quizReviewModel!.data![index].title!["url"],),

          const SizedBox(height: 30),
          ..._listOfOptions(
              quizReviewModel!.data![index].options!,
              index,
              quizReviewModel!.data![index].id!,
              quizReviewModel!.data![index].pivot!,
              quizReviewModel!.data![index].answerOptionId!.toString()
          ),
        ],
      ),
    ),
  );

  List<Widget> _listOfOptions(List<Option> options, int index, int questionId, Pivot pivot, String myAnswer) => options.map((e) => _levelButton(
    e: e,
    index: index,
    questionId: questionId,
    pivot: pivot,
    myAnswer: myAnswer,
  )).toList();

  Widget _levelButton({required Option e, required int index, required int questionId, required Pivot pivot, required String myAnswer}) => Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.6,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
    decoration: BoxDecoration(
      color: e.id!.toString() ==  quizReviewModel!.data![index].answerOptionId.toString() &&  quizReviewModel!.data![index].answerOptionId.toString() !=  pivot.laQuestionOptionId!.toString()   ?
      Colors.green:
        e.id!.toString() == pivot.laQuestionOptionId!.toString()  &&  pivot.laQuestionOptionId!.toString() ==  quizReviewModel!.data![index].answerOptionId.toString() ? Colors.green :
      e.id!.toString() == pivot.laQuestionOptionId!.toString()  &&  pivot.laQuestionOptionId!.toString() !=  quizReviewModel!.data![index].answerOptionId.toString() ? Colors.red
     : Colors.white,
      border: Border.all(color: ColorCode.buttonColor),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundColor: Colors.transparent,
        ),
        Expanded(
          child: Center(
            child: Text(
              e.title!,
              style: TextStyle(
                color: e.id!.toString() == pivot.laQuestionOptionId!.toString() || (pivot.laQuestionOptionId!.toString() != myAnswer && e.id!.toString() == myAnswer) ? Colors.white : Colors.purple,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child:e.id!.toString() ==  quizReviewModel!.data![index].answerOptionId.toString() && quizReviewModel!.data![index].answerOptionId.toString()!= pivot.laQuestionOptionId!.toString()?
          const Icon(Icons.done, color: Colors.purple, size: 15,):
            e.id!.toString() == pivot.laQuestionOptionId!.toString() &&  pivot.laQuestionOptionId!.toString() ==  quizReviewModel!.data![index].answerOptionId.toString()
              ? const Icon(Icons.done, color: Colors.purple, size: 15,)
              :  e.id!.toString() == pivot.laQuestionOptionId!.toString() &&  pivot.laQuestionOptionId!.toString() !=  quizReviewModel!.data![index].answerOptionId.toString()
              ? const Icon(Icons.clear, color: Colors.purple, size: 15,)
              : const SizedBox(),
        ),
      ],
    ),
  );
}
