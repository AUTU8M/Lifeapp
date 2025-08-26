import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/home/presentations/widgets/student_faq_listview.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "${StringHelper.faq}s",
            style: TextStyle(
              color: ColorCode.textBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: const StudentFaqListView());
  }
}
