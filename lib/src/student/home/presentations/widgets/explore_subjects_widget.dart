import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../common/helper/api_helper.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../subject_level_list/presentation/pages/subject_level_list_page.dart';
import '../../../subject_list/presentation/page/subject_list_page.dart';
import '../../../home/models/subject_model.dart';

class ExploreSubjectsWidget extends StatelessWidget {

  final List<Subject> subjects;

  const ExploreSubjectsWidget({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              StringHelper.exploreBySubject,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            TextButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const SubjectListPage(
                    navName: "",
                  ),
                  withNavBar: true,
                );
              },
              child: const Text(
                StringHelper.seeAll,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(subjects.isNotEmpty) SubjectWidget(name: subjects[0].title ?? "", img: subjects[0].image != null ? ApiHelper.imgBaseUrl + subjects[0].image!.url! : ImageHelper.scienceIcon, subjectId: subjects[0].id!.toString()),
            if(subjects.length >= 2) SubjectWidget(name: subjects[1].title ?? "", img: subjects[1].image != null ? ApiHelper.imgBaseUrl + subjects[1].image!.url! : ImageHelper.scienceIcon, subjectId: subjects[1].id!.toString()),
            subjects.length >= 3 ? SubjectWidget(name: subjects[2].title ?? "", img: subjects[2].image != null ? ApiHelper.imgBaseUrl + subjects[2].image!.url! : ImageHelper.scienceIcon, subjectId: subjects[2].id!.toString()) : SizedBox(width: MediaQuery
                .of(context)
                .size
                .width * .27,),
          ],
        ),
      ],
    );
  }
}

class SubjectWidget extends StatelessWidget {

  final String name;
  final String img;
  final String subjectId;

  const SubjectWidget(
      {required this.name, required this.img, super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        push(
          context: context,
          page: SubjectLevelListPage(
            subjectId: subjectId,
            navname: "",
          ),
          withNavbar: true,
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .width * .27,
            width: MediaQuery
                .of(context)
                .size
                .width * .27,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Center(
              child: img.contains("/media") ? CachedNetworkImage(imageUrl: img,) : Image.asset(
                  img),
            ),
          ),

          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * .2,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

