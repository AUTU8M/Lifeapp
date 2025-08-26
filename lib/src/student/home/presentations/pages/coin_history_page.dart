import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../models/coin_history_model.dart';
import 'package:lifelab3/src/common/utils/mixpanel_service.dart';
class CoinsHistoryPage extends StatefulWidget {
  final String totalCoin;

  const CoinsHistoryPage({
    Key? key,
    required this.totalCoin,
  }) : super(key: key);

  @override
  State<CoinsHistoryPage> createState() => _CoinsHistoryPageState();
}

late DateTime _startTime;
late DateTime _endTime;

class _CoinsHistoryPageState extends State<CoinsHistoryPage> {
  CoinsHistoryModel? coinsHistoryModel;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DashboardProvider>(context, listen: false)
          .getCoinHistoryData();
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _endTime = DateTime.now(); // ✅ Track when screen is closed

    final duration = _endTime.difference(_startTime).inSeconds;

    MixpanelService.track("Total Coins Screen Viewed", properties: {
      "duration_seconds": duration,
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.coins,

        action: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.totalCoin,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : coinsHistoryModel != null && coinsHistoryModel!.data != null
              ? _coinList()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/noCoinImage.png",
                        fit: BoxFit.fill,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: height * 0.22,
                          ),
                          const Text(
                            StringHelper.goodNews,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: height * 0.35),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            child: const Text(
                              StringHelper.coinMsg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _coinList() => SizedBox(
        height: MediaQuery.of(context).size.height * .85,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: coinsHistoryModel?.data?.data?.length,
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 15, right: 20, bottom: 20),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  // height: MediaQuery.of(context).size.height * .10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage("assets/images/letter.png"),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .40,
                                child: Text(
                                  coinsHistoryModel!.data!.data![index].type! ==
                                          2
                                      ? "Quiz Completed"
                                      : coinsHistoryModel!.data!.data![index]
                                          .coinableObject["title"],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .35,
                                child: Text(
                                  "${coinsHistoryModel?.data?.data?[index].createdAt!.day}"
                                  "-"
                                  "${coinsHistoryModel?.data?.data?[index].createdAt!.month}"
                                  "-"
                                  "${coinsHistoryModel?.data?.data?[index].createdAt!.year}",
                                  style: const TextStyle(
                                    color: Color(0xff959595),
                                    fontSize: 13,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        ImageHelper.coinIcon,
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${coinsHistoryModel?.data?.data?[index].amount}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 10),
                // const Divider(color: Colors.black26, thickness: 2,),
              ],
            ),
          ),
        ),
      );
}
