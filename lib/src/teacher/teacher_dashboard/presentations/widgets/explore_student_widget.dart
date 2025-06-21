import 'package:flutter/material.dart';

import '../../../../common/helper/color_code.dart';
import '../../../../common/helper/image_helper.dart';
import '../../../../common/helper/string_helper.dart';

class ExploreStudentWidget extends StatelessWidget {
  const ExploreStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              StringHelper.exploreStudent,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            InkWell(
              onTap: () {
                // TODO
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Text(
                StringHelper.seeAll,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChallengeWidget(
              name: StringHelper.science,
              img: ImageHelper.scienceIcon,
              isSubscribe: false,
            ),
            _ChallengeWidget(
              name: StringHelper.maths,
              img: ImageHelper.mathsIcon,
              isSubscribe: false,
            ),
            _ChallengeWidget(
              name: StringHelper.financial,
              img: ImageHelper.financeIcon,
              isSubscribe: false,
            ),
            _ChallengeWidget(
              name: StringHelper.mentalHealth,
              img: ImageHelper.mentalHealth,
              isSubscribe: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _ChallengeWidget extends StatelessWidget {

  final String name;
  final String img;
  final bool isSubscribe;

  const _ChallengeWidget({
    required this.name,
    required this.img,
    required this.isSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * .2,
                width: MediaQuery.of(context).size.width * .2,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black54)
                ),
                child: Center(
                  child: Image.asset(img),
                ),
              ),
              if(isSubscribe) Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * .15,
                  decoration: const BoxDecoration(
                    color: ColorCode.buttonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      StringHelper.subscribe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}