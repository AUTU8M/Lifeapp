import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../common/helper/color_code.dart';
import '../../../subject_level_list/presentation/pages/subject_level_list_page.dart';

class SubjectDetailsWidget extends StatelessWidget {

  final DashboardProvider provider;
  final int index;
  final String navName;

  const SubjectDetailsWidget({super.key, required this.provider, required this.index, required this.navName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(!provider.subjectModel!.data!.subject![index].couponCodeUnlock!) {
          PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: SubjectLevelListPage(
                subjectId: provider.subjectModel!.data!.subject![index].id!.toString(),
                navname: navName,
              ),
              withNavBar: true,
          );
        } else {
          Fluttertoast.showToast(msg: StringHelper.locked);
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            // height: 140,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorCode.subjectListColor1,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        provider.subjectModel!.data!.subject![index].title!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        provider.subjectModel!.data!.subject![index].heading!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                provider.subjectModel!.data!.subject![index].image != null
                    ? Image.network(
                  ApiHelper.imgBaseUrl + provider.subjectModel!.data!.subject![index].image!.url!,
                  width: MediaQuery.of(context).size.width * .3,
                )
                    : Image.asset(
                  ImageHelper.subjectListIcon,
                  width: MediaQuery.of(context).size.width * .3,
                ),
              ],
            ),
          ),
          if(provider.subjectModel!.data!.subject![index].couponCodeUnlock!) Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xffA7A7A7).withOpacity(.5),
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
