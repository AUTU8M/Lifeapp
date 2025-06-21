import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/student/friend/model/friend_req_model.dart';
import 'package:lifelab3/src/student/friend/model/my_friend_list_model.dart';
import 'package:lifelab3/src/student/friend/model/sent_friend_model.dart';
import 'package:lifelab3/src/student/friend/presentations/models/search_friend_model.dart';
import 'package:lifelab3/src/student/friend/services/friend_services.dart';

import '../../../common/helper/color_code.dart';
import '../presentations/pages/friend_req_send_page.dart';

class FriendProvider extends ChangeNotifier {

  MyFriendListModel? myFriendListModel;
  SearchFriendModel? searchFriendModel;
  SentFriendRequestModel? sentFriendRequestModel;
  FriendRequestModel? friendRequestModel;

  TextEditingController searchFriendController = TextEditingController();

  int tabIndex = 0;

  Future searchFriend(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );
    Response response = await FriendServices().searchFriend(searchFriendController.text.trim());

    Loader.hide();

    if(response.statusCode == 200) {
      searchFriendModel = SearchFriendModel.fromJson(response.data);
    } else {
      searchFriendModel = null;
    }
    notifyListeners();
  }

  Future getMyFriend(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );
    Response response = await FriendServices().getMyFriend();

    Loader.hide();

    if(response.statusCode == 200) {
      myFriendListModel = MyFriendListModel.fromJson(response.data);
    } else {
      myFriendListModel = null;
    }
    notifyListeners();
  }

  Future getSentFriend() async {

    Response response = await FriendServices().getSentFriend();

    if(response.statusCode == 200) {
      sentFriendRequestModel = SentFriendRequestModel.fromJson(response.data);
    } else {
      sentFriendRequestModel = null;
    }
    notifyListeners();
  }

  Future getFriendReq() async {

    Response response = await FriendServices().getFriendReq();

    if(response.statusCode == 200) {
      friendRequestModel = FriendRequestModel.fromJson(response.data);
    } else {
      friendRequestModel = null;
    }
    notifyListeners();
  }

  Future sendReq(BuildContext context, String id) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await FriendServices().sendRequest(
      name: searchFriendController.text.trim(),
      recipientId: id,
      context: context,
    );

    Loader.hide();
    if(response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FriendReqSendPage(name: searchFriendController.text.trim()),));
    } else {
      Fluttertoast.showToast(msg: "Something went to wrong");
    }

  }

  Future unfriend(BuildContext context, String id) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await FriendServices().unfriendUser(
      id: id,
      context: context,
    );

    Loader.hide();
    if(response.statusCode == 200) {
      getMyFriend(context);
      getSentFriend();
    } else {
      Fluttertoast.showToast(msg: "Something went to wrong");
    }
    notifyListeners();
  }

  Future acceptFriend(BuildContext context, String id) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await FriendServices().acceptFriendUser(
      id: id,
      context: context,
    );

    Loader.hide();
    if(response.statusCode == 200) {
      getMyFriend(context);
      getSentFriend();
    } else {
      Fluttertoast.showToast(msg: "Something went to wrong");
    }
    notifyListeners();
  }

  void updateIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void clearData() {
    searchFriendModel = null;
    notifyListeners();
  }

}