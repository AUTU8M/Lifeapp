import 'package:flutter/material.dart';

import '../helper/color_code.dart';

class BorderButton extends StatelessWidget {
  final String name;
  final double? height;
  final double? width;
  final Function()? onTap;

  const BorderButton({
    Key? key,
    required this.name,
    this.onTap,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: ColorCode.buttonColor)
        ),
        child: Center(
          child: Text(
            name,
            softWrap: true,
            maxLines: 1,
            style: const TextStyle(
              color: ColorCode.buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
