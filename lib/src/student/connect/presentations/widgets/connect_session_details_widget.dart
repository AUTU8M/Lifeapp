import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/student/connect/provider/connect_provider.dart';
import 'package:provider/provider.dart';

import 'connect_book_seat_button.dart';
import 'connect_get_link_button.dart';


class ConnectSessionDetailsWidget extends StatefulWidget {

  final String id;

  const ConnectSessionDetailsWidget({super.key, required this.id});

  @override
  State<ConnectSessionDetailsWidget> createState() => _ConnectSessionDetailsWidgetState();
}

class _ConnectSessionDetailsWidgetState extends State<ConnectSessionDetailsWidget> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ConnectProvider>(context, listen: false).sessionDetails(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ConnectProvider>(context).sessionDetailsModel;
    return data != null ? Scaffold(
      bottomNavigationBar: data.data!.isBooked.toString() == "1"
          ? ConnectGetLinkButton(link: data.data!.zoomLink!)
          : ConnectBookSeatButton(id: data.data!.id!.toString()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                data.data!.user!.profileImage != null
                    ? CachedNetworkImage(imageUrl: ApiHelper.imgBaseUrl + data.data!.user!.profileImage,)
                    :  Padding(
                      padding: const EdgeInsets.all(30),
                      child: Image.asset(ImageHelper.profileIcon),
                    ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Name
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .6,
                        child: Text(
                          data.data!.user!.name ?? "",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                data.data!.isBooked.toString() == "1"
                    ? Container(
                        height: 35,
                        width: 130,
                        padding: const EdgeInsets.only(left: 15),
                        decoration: const BoxDecoration(
                          color: ColorCode.buttonColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            StringHelper.booked,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  const SizedBox(height: 20),
                  Text(
                    data.data!.description ?? "",
                    style: const TextStyle(
                      color: ColorCode.textBlackColor,
                      fontSize: 15,
                      letterSpacing: .12,
                    ),
                  ),

                  // Headline
                  const SizedBox(height: 20),
                  Text(
                    data.data!.heading ?? "",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .12,
                    ),
                  ),

                  // Date & Time
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
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
                              "${data.data!.date!.day}-${data.data!.date!.month}-${data.data!.date!.year}",
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
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              DateFormat("hh:mm a").format(DateTime.parse("2024-12-12 ${data.data!.time!}")),
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
                    ],
                  ),

                  // Note
                  const SizedBox(height: 20),
                  const Text(
                    "Note: Its a online session and there are no recordings of the same. After you click on book a seat for me!. We will send you the zoom link on your registered email id.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      letterSpacing: .12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  //Zoom Link
                  const SizedBox(height: 20),
                  if(data.data!.isBooked.toString() == "1")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "Zoom Link : ",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: .12,
                                  fontWeight: FontWeight.w500,
                                ),),
                                TextSpan(text: data.data!.zoomLink!,
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Clipboard.setData(ClipboardData(text: data.data!.zoomLink!));
                                    Fluttertoast.showToast(msg: "Copied Successfully!");
                                  },
                                  style: const TextStyle(
                                  color: ColorCode.buttonColor,
                                  fontSize: 15,
                                  letterSpacing: .12,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ]
                            )
                        ),
                        const SizedBox(height: 10),
                        RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "Zoom Password : ",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: .12,
                                  fontWeight: FontWeight.w500,
                                ),),
                                TextSpan(text: data.data!.zoomPassword!,
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Clipboard.setData(ClipboardData(text: data.data!.zoomPassword!));
                                    Fluttertoast.showToast(msg: "Copied Successfully!");
                                  },
                                  style: const TextStyle(
                                  color: ColorCode.buttonColor,
                                  fontSize: 15,
                                  letterSpacing: .12,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ]
                            )
                        ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    ) : const LoadingWidget();
  }
}
