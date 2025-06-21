import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final String? labelName;
  final String? hintName;
  final TextEditingController? fieldController;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final EdgeInsets? margin;
  final Function(String)? onChange;
  final bool readOnly;
  final Color? color;
  final Function(String?)? onSaved;
  final Function(String?)? onFieldSubmitted;
  final Function()? onEditingComplete;

  const CustomTextField({
    Key? key,
    this.fieldController,
    this.prefix,
    this.suffix,
    this.hintName,
    this.margin,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.height,
    this.width,
    this.labelName,
    this.textInputFormatter,
    this.keyboardType,
    required this.readOnly,
    this.validator,
    this.onTap,
    this.onChange,
    this.color,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: color,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: Colors.black45.withOpacity(0.3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: height == 44.0 ? 22.0 : 0.0, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                maxLength: maxLength,
                maxLines: maxLines,
                onTap: onTap,
                validator: validator,
                readOnly: readOnly,
                keyboardType: keyboardType,
                inputFormatters: textInputFormatter,
                controller: fieldController,
                onChanged: onChange,
                onSaved: onSaved,
                onFieldSubmitted: onFieldSubmitted,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  prefix: prefix,
                  suffixIcon: suffix,
                  hintText: hintName,
                  labelText: labelName,
                  labelStyle: TextStyle(
                    // fontFamily: ConstantHelper.defaultFont,
                    letterSpacing: -0.32,
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(.6),
                  ),
                  hintStyle: TextStyle(
                    letterSpacing: -0.32,
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(.4),
                  ),
                ),
                style: const TextStyle(
                  letterSpacing: -0.32,
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
