import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

void push(
        {required BuildContext context,
        required Widget page,
        bool? withNavbar}) =>
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: page,
      withNavBar: withNavbar ?? false,
    );

void pushRemoveUntil({required BuildContext context, required Widget page}) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => page), (route) => false);
