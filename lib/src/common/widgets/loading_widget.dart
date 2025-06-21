import 'package:flutter/material.dart';

import '../helper/color_code.dart';

class LoadingWidget extends StatelessWidget {

  final double? height;

  const LoadingWidget({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorCode.buttonColor,
        ),
      ),
    );
  }
}
