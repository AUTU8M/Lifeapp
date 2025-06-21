import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/custom_text_field.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class SearchFriendPage extends StatefulWidget {

  const SearchFriendPage({super.key});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FriendProvider>(context,listen: false).clearData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.searchFriend,
      ),
      body: _searchFriend(provider),
    );
  }

  Widget _searchFriend(FriendProvider provider) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _searchFriendFromApi(provider),
        const SizedBox(height: 20),
        if(provider.searchFriendModel != null) _listOfSearchFriendByApi(provider),
      ],
    ),
  );

  Widget _searchFriendFromApi(FriendProvider provider) => Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: CustomTextField(
      readOnly: false,
      color: Colors.white,
      hintName: StringHelper.searchFriend,
      maxLines: 1,
      suffix: InkWell(
        onTap: () {
          provider.searchFriend(context);
        },
        child: const Icon(
          Icons.search_rounded,
          color: Colors.black54,
        ),
      ),
      onEditingComplete: () {
        provider.searchFriend(context);
      },
      onFieldSubmitted: (val) {
        provider.searchFriend(context);
      },
      onChange: (val) {
        if(val.isEmpty) {
          provider.clearData();
        }
      },
    ),
  );

  Widget _listOfSearchFriendByApi(FriendProvider provider) => SizedBox(
    height: MediaQuery.of(context).size.height * .75,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: provider.searchFriendModel!.data!.length,
      itemBuilder: (context, index) => Padding(
        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03, right: MediaQuery.of(context).size.width*0.03, bottom: 20),
        child: Column(
          children: [
            Container(
              padding:  EdgeInsets.symmetric(vertical: 20, horizontal: MediaQuery.of(context).size.width*0.05),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: provider.searchFriendModel!.data![index].profileImage !=
                        null
                        ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://media.gappubobo.com/${provider.searchFriendModel!.data![index]
                              .profileImage!}"),
                    )
                        : const CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      AssetImage("assets/images/pro.png"),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Column(
                    children: [
                      // Name
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(
                          provider.searchFriendModel!.data![index].name ?? "",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),

                      // School Name
                      if(provider.searchFriendModel!.data![index].school != null) const SizedBox(height: 5),
                      if(provider.searchFriendModel!.data![index].school != null) SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(
                          provider.searchFriendModel!.data![index].school!.name ?? "",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),

                      // City, State
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(
                          "${provider.searchFriendModel!.data![index].state}, India",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if(provider.searchFriendModel!.data![index].friendRequest == null) {
                        provider.sendReq(context, provider.searchFriendModel!.data![index].id!.toString());
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .05,right: MediaQuery.of(context).size.width * .05,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: provider.searchFriendModel!.data![index].friendRequest != null ? Border.all(color: ColorCode.buttonColor) : null,
                        color: provider.searchFriendModel!.data![index].friendRequest == null ? ColorCode.buttonColor : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Send",
                          // provider.searchFriendModel!.data![index].friendRequest == null
                          //     ? "Send"
                          //     : Provider.of<DashBoardProvider>(context, listen: true).dashBoardModel!.data!.user!.id == searchFriendModel!.data![index].friendRequest!.senderId!
                          //     ? "Already sent" :
                          // provider.searchFriendModel!.data![index].friendRequest!.status == "confirmed"?
                          // "Friends" : "Pending",
                          style: TextStyle(
                            color: provider.searchFriendModel!.data![index].friendRequest == null ? Colors.white : ColorCode.buttonColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
