import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/subject_level_list/provider/subject_level_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../home/provider/dashboard_provider.dart';
import '../../../riddles/provider/riddle_provider.dart';

class QuizTopicListPage extends StatelessWidget {

  final SubjectLevelProvider provider;
  final String levelId;
  final String subjectId;

  const QuizTopicListPage({super.key, required this.provider, required this.levelId, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, name: StringHelper.quiz),
      body: provider.quizTopicModel != null && provider.quizTopicModel!.data!.laTopics!.isNotEmpty ? SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 100, left: 15, right: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 280,
          ),
          itemCount: provider.quizTopicModel!.data!.laTopics!.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  child: provider.quizTopicModel!.data!.laTopics![index].image != null
                      ? Image.network(ApiHelper.imgBaseUrl + provider.quizTopicModel!.data!.laTopics![index].image!.url!)
                      : Image.asset(ImageHelper.profileIcon2),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name
                      const SizedBox(height: 10),
                      Text(
                        provider.quizTopicModel!.data!.laTopics![index].title!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      // Button
                      const SizedBox(height: 20),
                      CustomButton(
                        name: StringHelper.start,
                        color: ColorCode.buttonColor,
                        height: 35,
                        onTap: () {
                          Map<String, dynamic> data = {
                            "la_subject_id": subjectId,
                            "la_level_id": levelId,
                            "participants": [Provider.of<DashboardProvider>(context, listen: false).dashboardModel!.data!.user!.id!],
                            "la_topic_id": provider.quizTopicModel!.data!.laTopics![index].id!,
                            "type": 2,
                          };
                          debugPrint("Data: $data");
                          Provider.of<RiddleProvider>(context, listen: false).addRiddleQuiz(context, data);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : const Center(
        child: Text(
          "Coming soon!",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
