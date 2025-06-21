// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../helper/color_code.dart';


// class AppUpdateWidget extends StatelessWidget {

//   final String appUrl;

//   const AppUpdateWidget({Key? key, required this.appUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Shimmer.fromColors(
//           baseColor: ColorCode.buttonColor,
//           highlightColor: ColorCode.defaultBgColor,
//           child: Container(
//             height: 95,
//             width: MediaQuery.of(context).size.width,
//             margin: const EdgeInsets.only(top: 18, bottom: 0),
//             // padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.blue, width: 1.5),
//               // color: color,
//             ),
//           ),
//         ),
//         Container(
//           height: 92,
//           margin: const EdgeInsets.only( top: 20, bottom: 1),
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Get more with the new update",
//                     style: TextStyle(
//                       color: ColorCode.buttonColor,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),

//                   SizedBox(height: 10),
//                   Text(
//                     "We've enhanced the app, and added\nsome new changes!",
//                     style: TextStyle(
//                       color: ColorCode.grey,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               InkWell(
//                 onTap: () {
//                   if(Platform.isAndroid) {
//                     launchUrl(Uri.parse(appUrl));
//                   } else {
//                     launchUrl(Uri.parse(appUrl));
//                   }
//                 },
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 child: Container(
//                   height: 30,
//                   width: MediaQuery.of(context).size.width * .2,
//                   decoration: BoxDecoration(
//                     color: ColorCode.buttonColor,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "Update",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
