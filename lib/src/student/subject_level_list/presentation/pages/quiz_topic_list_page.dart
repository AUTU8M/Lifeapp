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
  final int? filterTopicId;

  const QuizTopicListPage({
    super.key,
    required this.provider,
    required this.levelId,
    required this.subjectId,
    this.filterTopicId,
  });
  @override
  Widget build(BuildContext context) {
    final allTopics = provider.quizTopicModel?.data?.laTopics ?? [];
    final topics = filterTopicId != null
        ? allTopics.where((t) => t.id == filterTopicId).toList()
        : allTopics;

    print('Filter Topic ID: $filterTopicId');
    print('All topics count: ${allTopics.length}');
    print('Filtered topics count: ${topics.length}');
    print('Filtered topic IDs: ${topics.map((e) => e.id).toList()}');

    return Scaffold(
      appBar: commonAppBar(context: context, name: StringHelper.quiz),
      body: topics.isNotEmpty
          ? SizedBox(
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
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];  // Use filtered topic here

            return Container(
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
                ],
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
                    child: topic.image != null
                        ? Image.network(ApiHelper.imgBaseUrl + topic.image!.url!)
                        : Image.asset(ImageHelper.profileIcon2),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          topic.title ?? '',
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
                        const SizedBox(height: 20),
                        CustomButton(
                          name: StringHelper.start,
                          color: ColorCode.buttonColor,
                          height: 35,
                          onTap: () {
                            Map<String, dynamic> data = {
                              "la_subject_id": subjectId,
                              "la_level_id": levelId,
                              "participants": [
                                Provider.of<DashboardProvider>(context, listen: false)
                                    .dashboardModel!
                                    .data!
                                    .user!
                                    .id!
                              ],
                              "la_topic_id": topic.id!,
                              "type": 2,
                            };
                            debugPrint("Data: $data");
                            Provider.of<RiddleProvider>(context, listen: false)
                                .addRiddleQuiz(context, data);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
          : const Center(
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
