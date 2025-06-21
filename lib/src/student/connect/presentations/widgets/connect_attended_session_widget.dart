import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../provider/connect_provider.dart';
import 'connect_session_details_widget.dart';

class ConnectAttendedSessionWidget extends StatelessWidget {
  final ConnectProvider provider;

  const ConnectAttendedSessionWidget({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return provider.attendedSessionModel != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 25, bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 380,
              ),
              itemCount:
                  provider.attendedSessionModel!.data!.sessions!.data!.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        spreadRadius: 1,
                        blurRadius: 1,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    provider.attendedSessionModel!.data!.sessions!.data![index]
                                .user!.profileImage !=
                            null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            child: CachedNetworkImage(
                                imageUrl: ApiHelper.imgBaseUrl +
                                    provider
                                        .attendedSessionModel!
                                        .data!
                                        .sessions!
                                        .data![index]
                                        .user!
                                        .profileImage),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(ImageHelper.profileIcon),
                            ),
                          ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          const SizedBox(height: 10),
                          Text(
                            provider.attendedSessionModel!.data!.sessions!
                                .data![index].user!.name!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .12,
                            ),
                          ),


                          // Headline
                          const SizedBox(height: 5),
                          Text(
                            provider.attendedSessionModel!.data!.sessions!
                                .data![index].heading!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Date
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "${provider.attendedSessionModel!.data!.sessions!.data![index].date!.day}-${provider.attendedSessionModel!.data!.sessions!.data![index].date!.month}-${provider.attendedSessionModel!.data!.sessions!.data![index].date!.year}",
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Time
                          const SizedBox(height: 7),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .28,
                                child: Text(
                                  DateFormat("hh:mm a").format(DateTime.parse("2024-12-12 ${provider.attendedSessionModel!.data!.sessions!
                                      .data![index].time!}")),
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Button
                          const SizedBox(height: 7),
                          CustomButton(
                            name: provider.attendedSessionModel!.data!.sessions!
                                        .data![index].isBooked
                                        .toString() ==
                                    "1"
                                ? StringHelper.booked
                                : StringHelper.viewDetails,
                            color: ColorCode.buttonColor,
                            height: 35,
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ConnectSessionDetailsWidget(
                                    id: provider.attendedSessionModel!.data!
                                        .sessions!.data![index].id!
                                        .toString()),
                                withNavBar: false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const LoadingWidget();
  }
}
