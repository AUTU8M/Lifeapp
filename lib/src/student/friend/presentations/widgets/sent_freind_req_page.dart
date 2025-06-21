import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/helper/color_code.dart';

class SentFriendReqPage extends StatelessWidget {
  const SentFriendReqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FriendProvider>(context);
    return provider.sentFriendRequestModel != null &&
            (provider.sentFriendRequestModel!.data ?? []).isNotEmpty
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: provider.sentFriendRequestModel!.data!.length,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  provider.sentFriendRequestModel!.data![index].profileImage !=
                          null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://media.gappubobo.com/${
                                  provider.sentFriendRequestModel!
                                      .data![index].profileImage!}"),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage("assets/images/pro.png"),
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
                          provider.sentFriendRequestModel!.data![index].name!,
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
                      if (provider.sentFriendRequestModel!.data![index].school !=
                          null)
                        const SizedBox(height: 5),
                      if (provider.sentFriendRequestModel!.data![index].school !=
                          null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .35,
                          child: Text(
                            provider.sentFriendRequestModel!
                                    .data![index].school!.name ??
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
                          "${provider.sentFriendRequestModel!.data![index].state}, India",
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
                      // showUnfriendBottomSheet(index, isFriend: false);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: ColorCode.buttonColor,
                          ),
                          color: Colors.white),
                      child: const Center(
                        child: Text(
                          StringHelper.sent,
                          style: TextStyle(
                              color: ColorCode.buttonColor, fontSize: 12),
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
            child: Text("No Friend Request Sent !!!"),
          );
  }
}
