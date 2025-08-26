// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lifelab3/src/common/helper/api_helper.dart';
// import 'package:lifelab3/src/common/helper/string_helper.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../common/widgets/custom_text_field.dart';
//
//
// class ChatPage extends StatefulWidget {
//
//
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//
//   ScrollController scrollController = ScrollController();
//
//   OpenAI? _openAI;
//   StreamSubscription? _subscription;
//
//   TextEditingController messageController = TextEditingController();
//   TextEditingController descController = TextEditingController();
//
//   String userId = "";
//   String queryId = "";
//   String rating = "";
//
//   bool isMaxScroll = true;
//
//   void _sendChatGptMessage(String text) async {
//
//     final request = CompleteText(
//       prompt: text,
//       model: TextDavinci3Model(),
//       maxTokens: 200,
//     );
//
//     _openAI!.onCompletion(request: request).then((response) {
//       debugPrint("Chat GPT Message: ${response!.choices}");
//       debugPrint("Chat GPT Message: ${response.choices[0].text}");
//     });
//
//     setState(() {
//
//     });
//
//   }
//
//   @override
//   void initState() {
//     _openAI = OpenAI.instance.build(token: ApiHelper.chatGptToken, orgId: "org-ULfLUi5ToYBXZb73y2liVTLe");
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         children: [
//            _chatMessages(),
//            _inputBox(),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
//
//   AppBar _appBar() => AppBar(
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     titleSpacing: 0,
//     leading: IconButton(
//       onPressed: () {
//         Navigator.pop(context);
//       },
//       icon: const Icon(Icons.arrow_back_ios_rounded),
//       color: Colors.black,
//     ),
//     title: const Row(
//       children: [
//         CircleAvatar(
//           radius: 17,
//           backgroundImage: AssetImage('assets/images/profile.jpg'),
//         ),
//
//         SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Chat",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 15,
//                 // fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
//
//   Widget _inputBox() => Padding(
//     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 35),
//     child: Row(
//       children: [
//         Expanded(
//           child: CustomTextField(
//             readOnly: false,
//             height: 45,
//             fieldController: messageController,
//             color: Colors.white,
//             keyboardType: TextInputType.multiline,
//             maxLines: 3,
//             minLines: 1,
//             onTap: () async {
//               await Future.delayed(const Duration(milliseconds: 500));
//               setState(() {
//                 isMaxScroll = true;
//               });
//             },
//           ),
//         ),
//
//         const SizedBox(width: 10),
//         InkWell(
//           onTap: () {
//             if(messageController.text.trim().isNotEmpty) {
//               // sendMessage();
//               _sendChatGptMessage(messageController.text.trim());
//             } else {
//               Fluttertoast.showToast(msg: "Please enter text");
//             }
//           },
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 15),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.blue,
//             ),
//             child: Transform.rotate(
//               angle: .8,
//               child: Image.asset(
//                 "assets/images/Send.png",
//                 height: 25,
//                 width: 25,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
//
//   Widget _chatMessages() => Expanded(
//     child: Padding(
//       padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//       child: ListView.builder(
//         shrinkWrap: true,
//         controller: scrollController,
//         // reverse: true,
//         itemCount: messageListModel!.data!.length,
//         itemBuilder: (context, index) {
//           Widget separator = const SizedBox();
//           if(messageListModel!.data!.length == 1) {
//             debugPrint("Cond 1");
//             if(DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!)) == DateFormat("dd/MM/yyyy").format(DateTime.now())) {
//               separator = _dateWidget("Today");
//             } else {
//               separator = _dateWidget(DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!)));
//             }
//           } else if(index+1 < messageListModel!.data!.length && DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!)) != DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index+1].createdAt!))) {
//             debugPrint("Cond 2");
//             String newDate;
//             if(DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!)) == DateFormat("dd/MM/yyyy").format(DateTime.now())) {
//               newDate = "Today";
//             } else {
//               newDate = DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!));
//             }
//             separator = _dateWidget(newDate);
//           } else if(index+1 == messageListModel!.data!.length) {
//             debugPrint("Cond 3");
//             String newDate;
//             if(DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!)) == DateFormat("dd/MM/yyyy").format(DateTime.now())) {
//               newDate = "Today";
//             } else {
//               newDate = DateFormat("dd/MM/yyyy").format(DateTime.parse(messageListModel!.data![index].createdAt!));
//             }
//             separator = _dateWidget(newDate);
//           }
//           return Column(
//             children: [
//               // separator,
//               _messages(index),
//             ],
//           );
//         },
//       ),
//     ),
//   );
//
//   Widget _messages(int index) => SizedBox(
//     width: MediaQuery.of(context).size.width,
//     child: Row(
//       mainAxisAlignment: messageListModel!.data![index].userId.toString() != userId ? MainAxisAlignment.start : MainAxisAlignment.end,
//       children: [
//         CustomPaint(
//           painter: messageListModel!.data![index].userId.toString() != userId ? LeftChatBubble() : RightChatBubble(),
//           child: Container(
//             padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 3),
//             margin: const EdgeInsets.only(bottom: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color:
//               messageListModel!.data![index].userId.toString() != userId ? Colors.white : ColorCode.purple,
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
//                       child: Text(
//                         messageListModel!.data![index].text.toString(),
//                         style: TextStyle(
//                           color: messageListModel!.data![index].userId.toString() != userId ? Colors.black : Colors.white,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 Row(
//                   children: [
//                     Text(
//                       DateFormat("hh:mm a").format(DateTime.parse(messageListModel!.data![index].createdAt!).toLocal()),
//                       style: TextStyle(
//                         color: messageListModel!.data![index].userId.toString() != userId ? Colors.black : Colors.white,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox()
//       ],
//     ),
//   );
//
//   Widget _dateWidget(String date) => Row(
//     children: [
//       const Expanded(
//         child: Divider(
//           color: Colors.grey,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         margin: const EdgeInsets.only(top: 15, bottom: 15),
//         child: Center(
//           child: Text(
//             date,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       ),
//       const Expanded(
//         child: Divider(
//           color: Colors.grey,
//         ),
//       ),
//     ],
//   );
//
//   _closeSheet() => showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Are sure to close question?",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                 ),
//               ),
//               // Image.asset(
//               //   "assets/images/B2 1.png",
//               //   height: 150,
//               //   width: 150,
//               // )
//             ],
//           ),
//
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _confirmSubmitButton(),
//                 const SizedBox(width: 20),
//                 _cancelButton(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
//
//   Widget _cancelButton() => InkWell(
//     onTap: () {
//       AssetAudioPlay().onClickAudio();
//       Navigator.pop(context);
//     },
//     child: Container(
//       height: 40,
//       width: 150,
//       decoration: BoxDecoration(
//         color: ColorCode.purple,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Center(
//         child: Text(
//           AppLocalizations.of(context)!.l175,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     ),
//   );
//
//   Widget _confirmSubmitButton() => InkWell(
//     onTap: () {
//       AssetAudioPlay().onClickAudio();
//       Navigator.pop(context);
//       closeQuery();
//     },
//     child: Container(
//       height: 40,
//       width: 150,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: Colors.black54, width: 2),
//       ),
//       child: Center(
//         child: Text(
//           AppLocalizations.of(context)!.l174,
//           style: const TextStyle(
//             color: ColorCode.purple,
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     ),
//   );
//
//   _ratingSheet() => showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//         color: Colors.white,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Are you satisfied?",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),
//                 Text(
//                   "Please rate your mentor",
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//             Center(
//               child: RatingBar(
//                 initialRating: 0,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 ratingWidget: RatingWidget(
//                   full: const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 25,),
//                   half: const Icon(Icons.star_half_rounded, color: Colors.amber, size: 25,),
//                   empty: const Icon(Icons.star_border_rounded, color: Colors.amber, size: 25,),
//                 ),
//                 itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 onRatingUpdate: (rat) {
//                   debugPrint("$rat");
//                   setState(() {
//                     rating = rat.toString();
//                   });
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.only(top: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.black),
//               ),
//               width: double.infinity,
//               child: TextField(
//                 controller: descController,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "ask your question",
//                   hintStyle: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15,
//                     color: Colors.black38,
//                   ),
//                   contentPadding: EdgeInsets.all(15),
//                 ),
//                 maxLines: 10,
//                 keyboardType: TextInputType.multiline,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             _submitRatingButton(),
//
//             const SizedBox(height: 40),
//
//           ],
//         ),
//       ),
//     ),
//   );
//
//   Widget _submitRatingButton() => InkWell(
//     onTap: () {
//       AssetAudioPlay().onClickAudio();
//       Navigator.pop(context);
//       if(rating.isNotEmpty) {
//         submitRating();
//       } else {
//         Fluttertoast.showToast(msg: "Please rate mentor");
//       }
//     },
//     child: Container(
//       height: 40,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.only(left: 15, right: 15),
//       decoration: BoxDecoration(
//         color: ColorCode.purple,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: const Center(
//         child: Text(
//           "Submit",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     ),
//   );
//
//   Widget _reviewRating() => Container(
//     constraints: const BoxConstraints(
//       maxHeight: 300,
//     ),
//     width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
//     padding: const EdgeInsets.all(15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if(!StorageUtil.getBool(Strings.IS_MENTOR)) const Text(
//             "Thank you for rating",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//
//           if(!StorageUtil.getBool(Strings.IS_MENTOR)) const SizedBox(height: 20),
//           RatingBarIndicator(
//             rating: double.tryParse(widget.rating)!,
//             itemBuilder: (context, index) => const Icon(
//               Icons.star_rate_rounded,
//               color: Color(0xffFFE600),
//             ),
//             itemCount: 5,
//             itemSize: 40,
//             direction: Axis.horizontal,
//           ),
//
//           const SizedBox(height: 20),
//           Text(
//             widget.desc,
//             style: const TextStyle(
//               color: Colors.black54,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
//
//   Widget _underReviewRating() => Container(
//     constraints: const BoxConstraints(
//       maxHeight: 300,
//     ),
//     width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
//     padding: const EdgeInsets.all(15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: const SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "The question has been closed!",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//
//           SizedBox(height: 20),
//           Text(
//             "Student will rate you shortly",
//             style: TextStyle(
//               color: Colors.black54,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
