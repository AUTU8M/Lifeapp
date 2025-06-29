import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/subject_level_list/presentation/pages/quiz_topic_list_page.dart';
import 'package:lifelab3/src/student/subject_level_list/provider/subject_level_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/common_navigator.dart';
import '../../../mission/presentations/pages/mission_page.dart';
import '../../../puzzle/presentations/pages/puzzle_page.dart';
import '../../../riddles/presentations/pages/riddles_page.dart';
import '../widgets/level_mission_widget.dart';
import '../widgets/level_vision_widget.dart';

import '../widgets/level_puzzles_widget.dart';
import '../widgets/level_quiz_widget.dart';
import '../widgets/level_riddles_widget.dart';
import '../widgets/level_subscribe_widget.dart';

class LevelChallengePage extends StatefulWidget {

  final String levelName;
  final String levelId;
  final String subjectId;
  final String navName;

  const LevelChallengePage({super.key, required this.levelName, required this.levelId, required this.subjectId, required this.navName});

  @override
  State<LevelChallengePage> createState() => _LevelChallengePageState();
}

class _LevelChallengePageState extends State<LevelChallengePage> {

  void checkNavigation() async {

    Map<String,dynamic> data = {
      "type": 1,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    Map<String,dynamic> data1 = {
      "type": 5,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    Map<String,dynamic> data2 = {
      "type": 6,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    Map<String,dynamic> rData = {
      "type": 3,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    Map<String,dynamic> qData = {
      "type": 2,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    Map<String,dynamic> pData = {
      "type": 4,
      "la_subject_id": widget.subjectId,
      "la_level_id": widget.levelId,
    };
    // Mission
    Provider.of<SubjectLevelProvider>(context, listen: false).getMission(data).whenComplete(() {

      if(widget.navName == StringHelper.mission) {
        push(
          context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context, listen: false).missionListModel!,
          ),
        );
      }
    });

    Provider.of<SubjectLevelProvider>(context, listen: false).getVisionMission(data).whenComplete(() {
      final visionData = Provider.of<SubjectLevelProvider>(context, listen: false).visionListModel;

      debugPrint("✅ [Vision] - Total Missions: ${visionData?.data?.missions?.data?.length}");

      if(widget.navName == StringHelper.vision) {
        push(
          context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context, listen: false).visionListModel!,
          ),
        );
      }
    });

    // Jigyasa
    Provider.of<SubjectLevelProvider>(context, listen: false).getJigyasaMission(data1).whenComplete(() {
      if(widget.navName == StringHelper.jigyasaSelf) {
        push(
          context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context, listen: false).jigyasaListModel!,
          ),
        );
      }
    });

    // Pragya
    Provider.of<SubjectLevelProvider>(context, listen: false).getPragyaMission(data2).whenComplete(() {
      if(widget.navName == StringHelper.pragyaSelf) {
        push(
          context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context, listen: false).pragyaListModel!,
          ),
        );
      }

    });

    // Riddle
    Provider.of<SubjectLevelProvider>(context, listen: false).getRiddleTopic(rData).whenComplete(() {
      final model = Provider.of<SubjectLevelProvider>(context, listen: false).riddleTopicModel;
      debugPrint("→ Riddle topics for subject=${widget.subjectId}, level=${widget.levelId}: ${model?.data?.laTopics}");
      if(widget.navName == StringHelper.riddles) {
        push(
          context: context,
          page: RiddlesPage(
            provider: Provider.of<SubjectLevelProvider>(context, listen: false),
            levelId: widget.levelId,
            subjectId: widget.subjectId,
          ),
        );
      }
    });

    // Quiz
    Provider.of<SubjectLevelProvider>(context, listen: false).getQuizTopic(qData).whenComplete(() {
      final quizData = Provider.of<SubjectLevelProvider>(context, listen: false).quizTopicModel;
      debugPrint("✅ [Quiz]  Total Topics: ${quizData?.data?.laTopics?.length}");
      if(widget.navName == StringHelper.quizSelf) {
        push(
          context: context,
          page: QuizTopicListPage(
            provider: Provider.of<SubjectLevelProvider>(context, listen: false),
            levelId: widget.levelId,
            subjectId: widget.subjectId,
          ),
        );
      }

    });

    // Puzzle
    Provider.of<SubjectLevelProvider>(context, listen: false).getPuzzleTopic(pData).whenComplete(() {
      if(widget.navName == StringHelper.puzzles) {
        push(
          context: context,
          page: PuzzlePage(
            provider: Provider.of<SubjectLevelProvider>(context, listen: false),
            levelId: widget.levelId,
            subjectId: widget.subjectId,
          ),
        );
      }
    });

  }

  @override
  void initState() {
    checkNavigation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectLevelProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: "${widget.levelName} ${StringHelper.challenges}"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [


            //vision
            LevelVisionWidget(provider: provider, levelId: widget.levelId, subjectId: widget.subjectId),

            // Mission
             LevelMissionWidget(provider: provider, levelId: widget.levelId, subjectId: widget.subjectId),


            // Riddles

            // Quiz
             LevelQuizWidget(provider: provider, levelId: widget.levelId, subjectId: widget.subjectId,),

            // Puzzle
             LevelPuzzlesWidget(provider: provider, levelId: widget.levelId, subjectId: widget.subjectId,),

            // Jigyasa
            const SizedBox(height: 30),
            if (provider.jigyasaListModel != null && provider.jigyasaListModel!.data!.missions!.data!.isNotEmpty)
              LevelSubscribeWidget(
                name: StringHelper.jigyasaSelf,
                img: ImageHelper.jigyasaIcon,
                model: provider.jigyasaListModel!,
              ),


            // Pragya
            const SizedBox(height: 30),
            if(provider.pragyaListModel != null && provider.pragyaListModel!.data!.missions!.data!.isNotEmpty) LevelSubscribeWidget(
              name: StringHelper.pragyaSelf,
              img: ImageHelper.pragyaIcon,
              model: provider.pragyaListModel!,
            ),

            const SizedBox(height: 50),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
