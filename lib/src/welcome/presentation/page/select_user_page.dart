import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/border_button.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/mentor/code/presentation/pages/code_page.dart';
import 'package:lifelab3/src/teacher/teacher_login/presentations/pages/teacher_login_page.dart';

import '../../../student/student_login/presentation/pages/student_login_page.dart';

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ImageHelper.welcomeImg1),

            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                StringHelper.welcome,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                StringHelper.welcomeMsg2,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54
                ),
              ),
            ),

            // Student
            const SizedBox(height: 60),
            Center(
              child: BorderButton(
                name: StringHelper.student,
                height: 45,
                width: MediaQuery.of(context).size.width * .7,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentLoginPage()));
                },
              ),
            ),

            // Teacher
            const SizedBox(height: 20),
            Center(
              child: BorderButton(
                name: StringHelper.teacher,
                height: 45,
                width: MediaQuery.of(context).size.width * .7,
                onTap: () {
                  push(
                    context: context,
                    page: const TeacherLoginPage(),
                  );
                },
              ),
            ),

            // Mentor
            const SizedBox(height: 20),
            Center(
              child: BorderButton(
                name: StringHelper.mentor,
                height: 45,
                width: MediaQuery.of(context).size.width * .7,
                onTap: () {
                  push(
                    context: context,
                    page: const CodePage(),
                  );
                },
              ),
            ),

            const SizedBox(height: 70),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 18,
                ),

                SizedBox(width: 10),
                Text(
                  StringHelper.aLifeLabProduct,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
