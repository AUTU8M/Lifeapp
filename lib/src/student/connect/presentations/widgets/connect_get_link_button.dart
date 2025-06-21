import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/border_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectGetLinkButton extends StatelessWidget {

  final String link;

  const ConnectGetLinkButton({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20,
        left: 15,
        right: 15,
      ),
      child: BorderButton(
        name: StringHelper.getTheLink,
        height: 45,
        onTap: () {
          launchUrl(Uri.parse(link));
        },
      ),
    );
  }
}
