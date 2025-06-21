import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../home/provider/dashboard_provider.dart';

PersistentBottomNavBarItem navImageIcon(String img, int index, String name,
    {context}) => PersistentBottomNavBarItem(
  icon: index==4?Stack(
    alignment: Alignment.bottomCenter,
    children: [
      ImageIcon(
        AssetImage(img),
        // size: 25,
      ),
      if((Provider.of<DashboardProvider>(context, listen: true).dashboardModel?.data?.user?.unreadNotificationCount ?? "0") != "0")Align(
          alignment: Alignment.topRight,
          child: Card(
            margin: const EdgeInsets.only(right: 20),
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              height: 15,
              width: 15,
              alignment: Alignment.center,
              // padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
              ),
              child: Text(Provider.of<DashboardProvider>(context, listen: true).dashboardModel?.data?.user?.unreadNotificationCount ?? "0",style: const TextStyle(fontSize: 10,color: Colors.white),),
            ),
          ),
        ),
    ],
  ):ImageIcon(
    AssetImage(img),
    // size: 25,
  ),
  title: (name),
  activeColorPrimary: ColorCode.buttonColor,
  inactiveColorPrimary: const Color(0xffa7a7a7),
  iconSize: 30,
  textStyle: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
  ),
);
