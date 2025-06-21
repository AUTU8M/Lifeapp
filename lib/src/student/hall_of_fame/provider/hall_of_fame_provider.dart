import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:lifelab3/src/student/hall_of_fame/services/hall_of_fame_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/helper/color_code.dart';
import '../model/hall_of_fame_model.dart';

class HallOfFameProvider extends ChangeNotifier {

  HallOfFameModel? hall;

  final GlobalKey heartPointKey = GlobalKey();
  final GlobalKey brainPointKey = GlobalKey();
  final GlobalKey activityKey = GlobalKey();

  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController searchChildController = TextEditingController();
  TextEditingController statesSearchCont = TextEditingController();

  void shareHearPoint(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    RenderRepaintBoundary? boundary = heartPointKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary!.toImage(pixelRatio: 10);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngByte = byteData!.buffer.asUint8List();

    Directory imgPath = await getTemporaryDirectory();
    await imgPath.create(recursive: true);
    final file = await File('${imgPath.path}/lifelab.png').create();
    await file.writeAsBytes(pngByte);
    await Share.shareXFiles([XFile(file.path)],);
    if(await file.exists()) {
      file.delete();
    }

    // if(Platform.isIOS) {
    //   await WcFlutterShare.share(
    //     sharePopupTitle: 'share',
    //     fileName: 'share.png',
    //     mimeType: 'image/png',
    //     bytesOfFile: pngByte,
    //   );
    // } else {
    //   Directory imgPath = await getTemporaryDirectory();
    //   await imgPath.create(recursive: true);
    //   final file = await File('${imgPath.path}/lifelab.png').create();
    //   await file.writeAsBytes(pngByte);
    //   await Share.shareXFiles([XFile(file.path)],);
    //   if(await file.exists()) {
    //     file.delete();
    //   }
    // }

    Loader.hide();
  }

  void shareBrainPoint(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    try{
      RenderRepaintBoundary? boundary = brainPointKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngByte = byteData!.buffer.asUint8List();

      Directory imgPath = await getTemporaryDirectory();
      await imgPath.create(recursive: true);
      final file = await File('${imgPath.path}/lifelab.png').create();
      await file.writeAsBytes(pngByte);
      await Share.shareFiles([file.path],);
      if(await file.exists()) {
        file.delete();
      }

      // if(Platform.isIOS) {
      //   await WcFlutterShare.share(
      //     sharePopupTitle: 'share',
      //     // subject: 'This is subject',
      //     // text: 'This is text',
      //     fileName: 'share.png',
      //     mimeType: 'image/png',
      //     bytesOfFile: pngByte,
      //   );
      // } else {
      //   Directory imgPath = await getTemporaryDirectory();
      //   await imgPath.create(recursive: true);
      //   final file = await File('${imgPath.path}/lifelab.png').create();
      //   await file.writeAsBytes(pngByte);
      //   await Share.shareFiles([file.path],);
      //   if(await file.exists()) {
      //     file.delete();
      //   }
      // }
      Loader.hide();
    } catch (_) {
      Loader.hide();
    }
    Loader.hide();
  }

  void shareActivityPoint(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    try{
      RenderRepaintBoundary? boundary = activityKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngByte = byteData!.buffer.asUint8List();

      Directory imgPath = await getTemporaryDirectory();
      await imgPath.create(recursive: true);
      final file = await File('${imgPath.path}/lifelab.png').create();
      await file.writeAsBytes(pngByte);
      await Share.shareFiles([file.path],);
      if(await file.exists()) {
        file.delete();
      }

      // if(Platform.isIOS) {
      //   await WcFlutterShare.share(
      //     sharePopupTitle: 'share',
      //     // subject: 'This is subject',
      //     // text: 'This is text',
      //     fileName: 'share.png',
      //     mimeType: 'image/png',
      //     bytesOfFile: pngByte,
      //   );
      // } else {
      //   Directory imgPath = await getTemporaryDirectory();
      //   await imgPath.create(recursive: true);
      //   final file = await File('${imgPath.path}/lifelab.png').create();
      //   await file.writeAsBytes(pngByte);
      //   await Share.shareFiles([file.path],);
      //   if(await file.exists()) {
      //     file.delete();
      //   }
      // }
      Loader.hide();
    } catch (_) {
      Loader.hide();
    }
    Loader.hide();
  }

  Future getHallOfFameData(BuildContext context) async {
    Loader.show(
      context,
      progressIndicator: const CircularProgressIndicator(color: ColorCode.buttonColor,),
      overlayColor: Colors.black54,
    );

    Response response = await HallOfFameServices().getHallOfFameData();

    Loader.hide();

    if(response.statusCode == 200) {
      hall = HallOfFameModel.fromJson(response.data);
    } else {
      hall = null;
    }
    notifyListeners();
  }

}