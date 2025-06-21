import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/helper/api_helper.dart';
import '../../../common/helper/string_helper.dart';
import '../../../utils/storage_utils.dart';

class ShopServices {

  Dio dio = Dio();

  Future getCouponList() async {
    try {
      Response response = await dio.post(
        ApiHelper.baseUrl + ApiHelper.couponList,
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Coupon List Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Coupon List Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Coupon List Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Coupon List Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

  Future getRedeemCouponData(String id) async {
    try {
      Response response = await dio.get(
        "${ApiHelper.baseUrl}${ApiHelper.redeemCoupon}$id/redeem",
        options: Options(
          contentType: "application/json",
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${StorageUtil.getString(StringHelper.token)}"
          },
        ),
      );

      debugPrint("Redeem Coupon Code: ${response.statusCode}");

      return response;
    } on DioException catch (e) {
      debugPrint("Redeem Coupon Dio Error ${e.response}");
      Fluttertoast.showToast(msg: e.response!.data!["message"]);
      Loader.hide();
    } on SocketException catch(e) {
      Loader.hide();
      debugPrint("Redeem Coupon Socket Error: $e");
      Fluttertoast.showToast(msg: StringHelper.badInternet);
    } catch (e) {
      Loader.hide();
      debugPrint("Redeem Coupon Catch Error: $e");
      Fluttertoast.showToast(msg: StringHelper.tryAgainLater);
    }
  }

}