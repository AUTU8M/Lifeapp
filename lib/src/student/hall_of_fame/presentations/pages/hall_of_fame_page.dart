import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/hall_of_fame/presentations/widget/coin_widget.dart';
import 'package:lifelab3/src/student/hall_of_fame/presentations/widget/hall_of_fame_mission_widget.dart';
import 'package:lifelab3/src/student/hall_of_fame/presentations/widget/hall_of_fame_quiz_widget.dart';
import 'package:lifelab3/src/student/hall_of_fame/provider/hall_of_fame_provider.dart';
import 'package:provider/provider.dart';

import '../widget/hall_of_fame_widget.dart';

class HallOfFamePage extends StatefulWidget {
  const HallOfFamePage({super.key});

  @override
  State<HallOfFamePage> createState() => _HallOfFamePageState();
}

class _HallOfFamePageState extends State<HallOfFamePage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HallOfFameProvider>(context, listen: false).getHallOfFameData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HallOfFameProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: "Hall of fame",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
        child: Column(
          children: [
            const HallOfFameWidget(),
            if(provider.hall != null && provider.hall!.data!.coinChampion!=null) const HallOfFameCoinWidget(),
            if(provider.hall != null && provider.hall!.data!.quizChampion!=null) const HallOfFameQuizWidget(),
            if(provider.hall != null && provider.hall!.data!.missionChampion!=null) const HallOfFameMissionWidget(),
          ],
        ),
      ),
    );
  }
}
