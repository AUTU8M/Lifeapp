import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/home/presentations/pages/subscribe_page.dart';
import 'package:lifelab3/src/student/mission/presentations/pages/mission_page.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';
import '../../../../utils/storage_utils.dart';

class LevelSubscribeWidget extends StatelessWidget {

  final String name;
  final String img;
  final MissionListModel model;

  const LevelSubscribeWidget({
    super.key,
    required this.name,
    required this.img,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 10),
            Tooltip(
              message: name == StringHelper.jigyasaSelf ? "Earn rewards by creating your own\nJigyasa Model! Use the provided sheets as a \nreference and craft your unique model." : "Craft your own Pragya DIY activity to\nunlock rewards! Utilise the provided materials \nand instructions to design your personalised activity.",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorCode.defaultBgColor,
              ),
              showDuration: const Duration(seconds: 1),
              triggerMode: TooltipTriggerMode.manual,
              key: tooltipKey,
              margin: const EdgeInsets.only(left: 30),
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  tooltipKey.currentState?.ensureTooltipVisible();
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: ColorCode.buttonColor,
                  child: Text(
                    "i",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: name == StringHelper.jigyasaSelf ? const Color(0xffE08800) : const Color(0xff5EBAED),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Positioned(
                top: 25,
                left: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .55,
                  child: const Text(
                    StringHelper.learnDiy,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 22,
                left: 20,
                child: InkWell(
                  onTap: () {
                    if(name == StringHelper.jigyasaSelf && StorageUtil.getBool(StringHelper.isJigyasa)) {
                      push(
                        context: context,
                        page: MissionPage(
                          missionListModel: model,
                        ),
                      );
                    } else if(name == StringHelper.pragyaSelf && StorageUtil.getBool(StringHelper.isPragya)) {
                      push(
                        context: context,
                        page: MissionPage(
                          missionListModel: model,
                        ),
                      );
                    }  else {
                      push(
                        context: context,
                        page: SubScribePage(type: name == StringHelper.jigyasaSelf ? "5" : "6"),
                      );
                    }

                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: name == StringHelper.jigyasaSelf ? const Color(0xffA3671F) : const Color(0xff00659D),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: const Text(
                      StringHelper.getStarted,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -10,
                bottom: name == StringHelper.jigyasaSelf ? -15 : 0,
                child: Container(
                  alignment: Alignment.topRight,
                  height: name == StringHelper.jigyasaSelf ? 200 : 180,
                  child: Image.asset(
                    name == StringHelper.jigyasaSelf ? ImageHelper.jigyasaFrame : ImageHelper.pragyaFrame,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
