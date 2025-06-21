import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:lifelab3/src/common/widgets/common_appbar.dart';

class PdfPage extends StatefulWidget {

  final String url;
  final String name;

  const PdfPage({super.key, required this.url, required this.name});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {

  //   @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     if (Platform.isAndroid) {
  //       await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  //     } else {
  //       // Handle other platforms as needed
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, name: widget.name),
      body: const PDF().cachedFromUrl(
        widget.url,
        placeholder: (double progress) => const Center(child: CircularProgressIndicator(color: Colors.blue,),),
      ),
    );
  }
}
