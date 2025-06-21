import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/student/mission/presentations/pages/submit_mission_page.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';

class GetStartedMissionWidget extends StatelessWidget {

  final MissionDatum data;
  final bool isAssigned;

  const GetStartedMissionWidget({super.key, required this.data, this.isAssigned = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: ShapeDecoration(
        color: isAssigned?Colors.red.withOpacity(0.5):Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // width: MediaQuery.of(context).size.width * .5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if(isAssigned)const Text("Assigned By Teacher")
              ],
            ),
          ),
          CustomButton(
            name: "Get Started",
            height: 40,
            width: 130,
            onTap: () {
              push(
                context: context,
                page: SubmitMissionPage(mission: data),
              );
            },
          ),
        ],
      ),
    );
  }
}
