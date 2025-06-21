import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

import '../../provider/connect_provider.dart';

class ConnectTabBar extends StatelessWidget {

  final ConnectProvider provider;

  const ConnectTabBar({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(
            onTap: (index) {
              provider.updateTabIndex(index);
            },
            indicatorPadding: const EdgeInsets.only(bottom: -5),
            indicatorColor: ColorCode.buttonColor,
            tabs: const [
              Text(
                StringHelper.upcomingSession,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 15,
                ),
              ),
              Text(
                StringHelper.attendedSession,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
