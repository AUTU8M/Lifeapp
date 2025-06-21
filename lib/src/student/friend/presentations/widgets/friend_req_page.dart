import 'package:flutter/material.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class FriendReqPage extends StatelessWidget {
  const FriendReqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context);
    return provider.friendRequestModel != null &&
            (provider.friendRequestModel!.data ?? []).isNotEmpty
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: provider.friendRequestModel!.data!.length,
          padding: EdgeInsets.only(
              top: 20, bottom: MediaQuery.of(context).padding.bottom),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      // pushNewScreen(
                      //   context,
                      //   screen: ViewProfilePage(
                      //     name: myFriendListModel!.data!.friends![index].name!,
                      //     profile: myFriendListModel!
                      //         .data!.friends![index].profileImage,
                      //     school: "",
                      //     state:
                      //         myFriendListModel!.data!.friends![index].state!,
                      //     text: "Friends",
                      //     senderId: null,
                      //     receiverId: null,
                      //   ),
                      // );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: provider.friendRequestModel!.data![index].profileImage !=
                            null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://media.gappubobo.com/${
                                    provider.friendRequestModel!
                                        .data![index].profileImage!}"),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/images/pro.png"),
                          ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    children: [
                      // Name
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(
                          provider.friendRequestModel!.data![index].name!,
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
                      if (provider.friendRequestModel!.data![index].school != null)
                        const SizedBox(height: 5),
                      if (provider.friendRequestModel!.data![index].school != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .35,
                          child: Text(
                            provider.friendRequestModel!.data![index].school!.name ??
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
                          "${provider.friendRequestModel!.data![index].state}, India",
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
                      provider.acceptFriend(
                        context,
                          provider.friendRequestModel!
                              .data![index].fiendRequest!.id!.toString(),);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: ColorCode.buttonColor),
                      child: const Center(
                        child: Text(
                          "Accept",
                          style:
                              TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        : const Center(
            child: Text("No Friend Request Found !!!"),
          );
  }
}
