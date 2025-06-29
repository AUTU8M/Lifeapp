  import 'package:flutter/material.dart';
  import 'package:lifelab3/src/common/helper/string_helper.dart';
  import 'package:lifelab3/src/common/widgets/common_appbar.dart';
  import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';
  import 'package:provider/provider.dart';


  import '../../../subject_level_list/provider/subject_level_provider.dart';
  import '../widgets/completed_mission_widget.dart';
  import '../widgets/get_started_mission_widget.dart';
  import '../widgets/in_review_mission_widget.dart';
  import '../widgets/rejected_mission_widget.dart';

  class MissionPage extends StatefulWidget {

    MissionListModel missionListModel;
    final String? subjectId;
    final String? levelId;

    MissionPage({super.key, required this.missionListModel, this.subjectId, this.levelId});

    @override
    State<MissionPage> createState() => _MissionPageState();
  }

  class _MissionPageState extends State<MissionPage> {

    ScrollController scrollController = ScrollController();
    int page = 1;
    bool isLoading = false;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      if (widget.subjectId != null) {
        scrollController.addListener(() {
            if ((scrollController.position.maxScrollExtent) ==
                scrollController.position.pixels) {
              page++;
                getData();
          }
        });
      }
    }

    getData() async {
      print("page : $page");
      isLoading = true;
      setState(() {});
      await Provider.of<SubjectLevelProvider>(context, listen: false).getMission({
        "type": 1,
        "la_subject_id": widget.subjectId,
        "la_level_id": widget.levelId,
      }, params: '?page=$page');
      (widget.missionListModel.data!.missions!.data ?? []).addAll(Provider.of<SubjectLevelProvider>(context, listen: false).missionListModel?.data?.missions?.data ?? []);
      isLoading = false;
      setState(() {});
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: commonAppBar(
          context: context,
          name: StringHelper.mission,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.subjectId != null) {
              (widget.missionListModel.data?.missions?.data ?? []).clear();
              page = 1;
              getData();
            }
          },
          child: widget.missionListModel.data!.missions!.data!.isNotEmpty ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                  itemCount: widget.missionListModel.data!.missions!.data!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      // TODO
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    // child: missionListModel.data!.missions!.data![index].submission == null
                    //     ? GetStartedMissionWidget(data: missionListModel.data!.missions!.data![index])
                    //     : const SizedBox(),
                    child: widget.missionListModel.data!.missions!.data![index].submission != null && widget.missionListModel.data!.missions!.data![index].submission!.approvedAt != null
                        ? CompletedMissionWidget(data: widget.missionListModel.data!.missions!.data![index])
                        : widget.missionListModel.data!.missions!.data![index].submission != null && widget.missionListModel.data!.missions!.data![index].submission!.approvedAt == null && widget.missionListModel.data!.missions!.data![index].submission!.rejectedAt == null
                        ? InReviewMissionWidget(data: widget.missionListModel.data!.missions!.data![index])
                        : widget.missionListModel.data!.missions!.data![index].submission != null && widget.missionListModel.data!.missions!.data![index].submission!.rejectedAt != null
                        ? RejectedMissionWidget(data: widget.missionListModel.data!.missions!.data![index])
                        : GetStartedMissionWidget(data: widget.missionListModel.data!.missions!.data![index], isAssigned: widget.missionListModel.data!.missions!.data![index].assignedBy != null),
                  ),
                ),
              ),
              if(isLoading)const Padding(
                  padding: EdgeInsets.only(bottom: 30,top: 10),
                child: CircularProgressIndicator(),
              )
            ],
          ) : Center(
            child: isLoading ? const CircularProgressIndicator() : const Text(
              "Coming soon!",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }
  }
