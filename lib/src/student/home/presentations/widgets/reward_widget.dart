import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/hall_of_fame/presentations/pages/hall_of_fame_page.dart';
import 'package:lifelab3/src/student/home/presentations/pages/coin_history_page.dart';

class RewardsWidget extends StatelessWidget {

  final String coin;
  final String friends;
  final String ranking;

  const RewardsWidget({
    required this.coin,
    required this.friends,
    required this.ranking,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringHelper.rewards,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RewardButton(
              name: StringHelper.coins,
              data: coin,
              img: ImageHelper.coinIcon,
              onTap: () {
                push(
                  context: context,
                  page: CoinsHistoryPage(totalCoin: coin),
                );
              },
            ),

            // RewardButton(
            //   name: StringHelper.friends,
            //   data: friends,
            //   img: ImageHelper.heartIcon,
            //   onTap: () {
            //     push(
            //       context: context,
            //       page: const FriendPage(),
            //     );
            //   },
            // ),

            RewardButton(
              name: StringHelper.ranking,
              data: ranking,
              img: ImageHelper.crownIcon,
              onTap: () {
                push(
                  context: context,
                  page: const HallOfFamePage(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class RewardButton extends StatelessWidget {

  final String name;
  final String data;
  final String img;
  final Function() onTap;

  const RewardButton({
    required this.name,
    required this.data,
    required this.img,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                img,
                height: MediaQuery.of(context).size.width * .07,
              ),

              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    data,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    minFontSize: 10,
                    maxFontSize: 15,
                  ),
                  AutoSizeText(
                    name,
                    minFontSize: 10,
                    maxFontSize: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

