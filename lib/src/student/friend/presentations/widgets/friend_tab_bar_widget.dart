import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';

import '../../../../common/helper/color_code.dart';

class FriendTabBarWidget extends StatelessWidget {

  final FriendProvider provider;
  final TabController controller;

  const FriendTabBarWidget({super.key, required this.provider, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: ColorCode.buttonColor,
        ),
        insets: EdgeInsets.only(left: 15, right: 15),
      ),
      labelPadding: const EdgeInsets.only(left: 15, right: 15),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: ColorCode.buttonColor,
      indicatorColor: ColorCode.buttonColor,
      unselectedLabelColor: Colors.black45,
      labelStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.only(top: 30),
      onTap: (i) {
        provider.updateIndex(i);
      },
      tabs: [
        Text((provider.myFriendListModel != null &&
            provider.myFriendListModel!.data!.friends!.isNotEmpty
            ? "${provider.myFriendListModel!.data!.friends!.length} "
            : "") + StringHelper.friends),
        const Text(StringHelper.request),
        const Text(StringHelper.sent),
      ],
    );
  }
}
