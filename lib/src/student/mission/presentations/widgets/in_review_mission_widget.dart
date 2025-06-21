import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';

class InReviewMissionWidget extends StatelessWidget {

  final MissionDatum data;

  const InReviewMissionWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4D292),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              data.title ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                "In review",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),

              const SizedBox(width: 10),
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  ImageHelper.fileIcon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
