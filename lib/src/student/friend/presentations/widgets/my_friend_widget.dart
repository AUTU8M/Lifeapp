import 'package:flutter/material.dart';
import 'package:lifelab3/src/student/friend/presentations/widgets/unfriend_sheet.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class MyFriendWidget extends StatelessWidget {
  const MyFriendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.myFriendListModel!.data!.friends!.length,
      padding: EdgeInsets.only(
          top: 20, bottom: MediaQuery.of(context).padding.bottom),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              provider.myFriendListModel!.data!.friends![index].profileImage !=
                      null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "https://media.gappubobo.com/${provider.myFriendListModel!.data!.friends![index].profileImage!}"),
                    )
                  : const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/pro.png"),
                    ),
              const SizedBox(width: 12),
              Column(
                children: [
                  // Name
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Text(
                      provider.myFriendListModel!.data!.friends![index].name!,
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
                  if (provider
                          .myFriendListModel!.data!.friends![index].school !=
                      null)
                    const SizedBox(height: 5),
                  if (provider
                          .myFriendListModel!.data!.friends![index].school !=
                      null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .35,
                      child: Text(
                        provider.myFriendListModel!.data!.friends![index]
                                .school!.name ??
                            "",
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
                      "${provider.myFriendListModel!.data!.friends![index].state}, India",
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
                  showUnfriendBottomSheet(index, context: context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: ColorCode.buttonColor,
                  ),
                  child: const Center(
                    child: Text(
                      "Unfriend",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
