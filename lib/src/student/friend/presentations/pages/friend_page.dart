import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/student/friend/presentations/pages/search_friend_page.dart';
import 'package:lifelab3/src/student/friend/presentations/widgets/friend_req_page.dart';
import 'package:lifelab3/src/student/friend/presentations/widgets/friend_tab_bar_widget.dart';
import 'package:lifelab3/src/student/friend/presentations/widgets/my_friend_widget.dart';
import 'package:lifelab3/src/student/friend/presentations/widgets/sent_freind_req_page.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FriendProvider>(context, listen: false).getMyFriend(context);
      Provider.of<FriendProvider>(context, listen: false).getSentFriend();
      Provider.of<FriendProvider>(context, listen: false).getFriendReq();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.friends,
        action: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CustomButton(
            name: StringHelper.searchFriend,
            width: 150,
            color: ColorCode.buttonColor,
            height: 30,
            onTap: () {
              push(
                context: context,
                page: const SearchFriendPage(),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FriendTabBarWidget(provider: provider, controller: _tabController,),
            const SizedBox(height: 20),
            if (provider.tabIndex == 0 && provider.myFriendListModel != null) const MyFriendWidget(),
            if (provider.tabIndex == 1 && provider.friendRequestModel != null) const FriendReqPage(),
            if (provider.tabIndex == 2 && provider.sentFriendRequestModel != null) const SentFriendReqPage(),
          ],
        ),
      ),
    );
  }
}
