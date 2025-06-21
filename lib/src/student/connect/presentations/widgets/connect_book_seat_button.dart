import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/student/connect/provider/connect_provider.dart';
import 'package:provider/provider.dart';

class ConnectBookSeatButton extends StatelessWidget {

  final String id;

  const ConnectBookSeatButton({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20, left: 15, right: 15,
      ),
      child: CustomButton(
        name: StringHelper.bookASeat,
        height: 45,
        color: ColorCode.buttonColor,
        onTap: () {
          Provider.of<ConnectProvider>(context, listen: false).bookSession(context, id);
        },
      ),
    );
  }
}
