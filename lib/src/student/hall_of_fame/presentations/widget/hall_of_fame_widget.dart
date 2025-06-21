import 'package:flutter/material.dart';

class HallOfFameWidget extends StatelessWidget {
  const HallOfFameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/hall_of_fame.png",
      height: 150,
      width: MediaQuery.of(context).size.width,
    );
  }
}
