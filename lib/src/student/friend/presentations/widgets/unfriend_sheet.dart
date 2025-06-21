import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

showUnfriendBottomSheet(int index, {bool isFriend = true, required BuildContext context}) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  useRootNavigator: true,
  builder: (ctx) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Are you sure to unfriend?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _confirmButton(index, ctx, isFriend: isFriend),
              const SizedBox(width: 20),
              _cancelButton(ctx),
            ],
          ),
        ),
      ],
    ),
  ),
);

Widget _cancelButton(BuildContext ctx) => InkWell(
  onTap: () {
    Navigator.pop(ctx);
  },
  child: Container(
    height: 40,
    width: 150,
    decoration: BoxDecoration(
      color: ColorCode.buttonColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: const Center(
      child: Text(
        StringHelper.cancel,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
  ),
);

Widget _confirmButton(int index, BuildContext ctx, {isFriend = true}) => InkWell(
  onTap: () async {
    Navigator.pop(ctx);
    await Provider.of<FriendProvider>(ctx, listen: false).unfriend(ctx, isFriend
        ? Provider.of<FriendProvider>(ctx, listen: false).myFriendListModel!.data!.friends![index].id!.toString()
        : Provider.of<FriendProvider>(ctx, listen: false).sentFriendRequestModel!.data![index].id.toString());
  },
  child: Container(
    height: 40,
    width: 150,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: ColorCode.buttonColor, width: 2),
    ),
    child: const Center(
      child: Text(
        "Confirm",
        style: TextStyle(
          color: ColorCode.buttonColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
  ),
);