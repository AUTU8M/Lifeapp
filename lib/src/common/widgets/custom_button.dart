import 'package:flutter/material.dart';

import '../helper/color_code.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final double? height;
  final double? width;
  final Function()? onTap;
  final Color? color;
  final Color? textColor;
  final bool? isShadow;

  const CustomButton({
    Key? key,
    required this.name,
    this.onTap,
    this.height,
    this.width,
    this.color,
    this.textColor,
    this.isShadow,
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
        // margin: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color ?? ColorCode.buttonColor,
          boxShadow: isShadow != null && isShadow! ? const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ] : null
        ),
        child: Center(
          child: Text(
            name,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
