import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/mentor/mentor_home/provider/mentor_home_provider.dart';
import 'package:lifelab3/src/student/connect/presentations/widgets/connect_session_details_widget.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/widgets/custom_button.dart';

class MentorUpcomingSessionWidget extends StatelessWidget {
  final MentorHomeProvider provider;

  const MentorUpcomingSessionWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringHelper.upcomingSession,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(),
          ],
        ),

        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            runSpacing: 10,
            spacing: 20,
            children: provider.upcomingSessionModel!.data!.sessions!.data!.map((e) => Container(
              // height: 410,
              width: MediaQuery.of(context).size.width * .43,
              padding: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  e.user!.profileImage != null ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    child: Image.network(ApiHelper.imgBaseUrl + e.user!.profileImage),
                  ) : ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    child: Image.asset(ImageHelper.profileIcon2),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        const SizedBox(height: 10),
                        Text(
                          e.user!.name ?? "",
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
                          e.heading ?? "",
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
                                "${e.date!.day}-${e.date!.month}-${e.date!.year}",
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
                                DateFormat("hh:mm a").format(DateTime.parse("2024-12-12 ${e.time!}")),
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
                          name: e.isBooked.toString() == "1"
                              ? StringHelper.booked
                              : StringHelper.viewDetails,
                          color: ColorCode.buttonColor,
                          height: 35,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ConnectSessionDetailsWidget(id: e.id.toString(),)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
