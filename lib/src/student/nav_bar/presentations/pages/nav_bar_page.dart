import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:lifelab3/src/student/shop/presentations/shop_page.dart';

import '../../../connect/presentations/pages/connect_page.dart';
import '../../../home/presentations/pages/home_page.dart';
import '../../../notification/presentations/notification_page.dart';
import '../../../tracker/presentations/pages/tracker_page.dart';
import '../widgets/nav_icon_widget.dart';

class NavBarPage extends StatefulWidget {

  final int currentIndex;

  const NavBarPage({required this.currentIndex, super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {

  int preIndex = 0;

  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // exitAlert(context);
        return true;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: [
          const HomePage(),
          const TrackerPage(),
          const ConnectPage(),
          const ShopPage(),
          const NotificationPage(),
        ],
        navBarStyle: NavBarStyle.style8,
        items: [
          navImageIcon(ImageHelper.homeIcon, 0, StringHelper.home),
          navImageIcon(ImageHelper.trackerIcon, 1, StringHelper.tracker),
          navImageIcon(ImageHelper.connectIcon, 2, StringHelper.connect),
          navImageIcon(ImageHelper.shopIcon, 3, StringHelper.shop),
          navImageIcon(ImageHelper.notificationIcon, 4, StringHelper.notification, context: context),
        ],
        navBarHeight: 80,
        stateManagement: true,
        backgroundColor: Colors.white,
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xffe5e5e5),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
      ),
    );
  }


}
