import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/student/vision/presentations/vision_page.dart';
import 'package:provider/provider.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../common/widgets/common_navigator.dart';
import '../../../mission/presentations/pages/mission_page.dart';
import '../../../puzzle/presentations/pages/puzzle_page.dart';
import '../../../riddles/presentations/pages/riddles_page.dart';
import '../../provider/subject_level_provider.dart';
import '../pages/level_challenge_page.dart';
import '../pages/quiz_topic_list_page.dart';

class SubjectLevelDetailsWidget extends StatefulWidget {

  final SubjectLevelProvider provider;
  final int index;
  final String subjectId;
  final String navName;
  const SubjectLevelDetailsWidget({super.key, required this.provider, required this.index, required this.subjectId, required this.navName});
  @override
  State<SubjectLevelDetailsWidget> createState() => _SubjectLevelDetailsWidgetState();
}
class _SubjectLevelDetailsWidgetState extends State<SubjectLevelDetailsWidget> {
  void checkNavigation(String levelId) {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Map<String,dynamic> data = {
      "type": 1,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    Map<String,dynamic> data1 = {
      "type": 5,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    Map<String,dynamic> data2 = {
      "type": 6,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    Map<String,dynamic> rData = {
      "type": 3,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    Map<String,dynamic> qData = {
      "type": 2,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    Map<String,dynamic> pData = {
      "type": 4,
      "la_subject_id": widget.subjectId,
      "la_level_id": levelId,
    };
    // Mission
    Provider.of<SubjectLevelProvider>(context, listen: false).getMission(data).whenComplete(() {
      Loader.hide();

      if(widget.navName == 'Mission')
      {
        push(
            context: context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(context, listen: false).missionListModel!,
          ),
        );
      }
      if(widget.navName == 'Vision') {
        print('ccccc ${widget.navName}');
        push(
          context: context,
          page: VisionPage(navName: 'Vision', subjectId: widget.subjectId , levelId:levelId )
        );
      }
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


      // Quiz
      Provider.of<SubjectLevelProvider>(context, listen: false).getQuizTopic(qData).whenComplete(() {
        final quizData = Provider.of<SubjectLevelProvider>(context, listen: false).quizTopicModel;
        debugPrint("✅ [Quiz]  Total Topics: ${quizData?.data?.laTopics?.length}");
        if(widget.navName == StringHelper.quizSelf) {
          push(
            context: context,
            page: QuizTopicListPage(
              provider: Provider.of<SubjectLevelProvider>(context, listen: false),
              levelId: widget.provider.levels!.data!.laLevels![widget.index].id!.toString(),
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
              levelId: widget.provider.levels!.data!.laLevels![widget.index].id!.toString(),
              subjectId: widget.subjectId,
            ),
          );
        }
      });

    });

    if(widget.navName.isEmpty ) {
      Loader.hide();
      final level = widget.provider.levels!.data!.laLevels![widget.index];

      print('Navigating to LevelChallengePage with:');
      print('Level Name: ${level.title}');
      print('Level ID: ${level.id}');
      print('Subject ID: ${widget.subjectId}');
      print('Nav Name: ${widget.navName}');
      push(
        context: context,
        page: LevelChallengePage(
          levelName: widget.provider.levels!.data!.laLevels![widget.index].title!,
          levelId: widget.provider.levels!.data!.laLevels![widget.index].id!.toString(),
          subjectId: widget.subjectId,
          navName: widget.navName,
        ),
        withNavbar: true,
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(widget.provider.levels!.data!.laLevels![widget.index].unlock! == 1) {
          checkNavigation(widget.provider.levels!.data!.laLevels![widget.index].id!.toString());
        } else {
          Fluttertoast.showToast(msg: "Level is locked");
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorCode.levelListColor1,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.levels!.data!.laLevels![widget.index].title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  widget.provider.levels!.data!.laLevels![widget.index].description ?? "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if(widget.provider.levels!.data!.laLevels![widget.index].unlock! == 0) Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Image.asset(
                ImageHelper.lockIcon,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
