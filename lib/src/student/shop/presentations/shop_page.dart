
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:lifelab3/src/student/nav_bar/presentations/pages/nav_bar_page.dart';
import 'package:lifelab3/src/student/shop/presentations/raise_campaign_page.dart';
import 'package:lifelab3/src/student/shop/presentations/unlocked_coupon_page.dart';
import 'package:lifelab3/src/student/shop/service/shop_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/helper/color_code.dart';
import '../model/coupon_list_model.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  CouponListModel? couponListModel;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getShopData();
    });
    super.initState();
  }

  Future<void> getShopData() async {
    ShopServices().getCouponList().then((value) => {
      couponListModel = CouponListModel.fromJson(value.data),
      isLoading = false,
      setState(() {})
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getShopData,
      child: Scaffold(
        appBar: commonAppBar(
          context: context,
          name: "Shop",
          onBack: () {
            push(
              context: context,
              page: const NavBarPage(currentIndex: 0),
            );
          }
        ),
        body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : couponListModel != null
                ? _body()
                : Container()),
      ),
    );
  }

  Widget _body() => ListView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.only(bottom: 20),
    itemCount: couponListModel!.data!.length,
    itemBuilder: (context, index) =>
    (couponListModel!.data![index].redeemed!)
        ? _viewCouponWidget(index)
        : _unlockCouponWidget(index),
  );

  Widget _unlockCouponWidget(int index) => Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          showCouponDetails(index);
        },
        child: Container(
          height: 270,
          decoration: BoxDecoration(
              color: ColorCode.buttonColor, borderRadius: BorderRadius.circular(20)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: 0,
                child: InkWell(
                  onTap: () {
                    showCouponDetails(index);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(left: 40, right: 50, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: ColorCode.defaultBgColor,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          const Text(
                            "Unlock",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${couponListModel!.data![index].coin ?? "0"} Coins needed",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: "https://media.gappubobo.com/${couponListModel!.data![index].couponMediaId!.url!}",
                  placeholder: (img, _) => Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(25),
                    child: const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));

  Widget _viewCouponWidget(int index) => Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ]),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: "https://media.gappubobo.com/${couponListModel!.data![index].couponMediaId!.url!}",
            placeholder: (img, _) => Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(25),
              child: const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          couponListModel!.data![index].details ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            launch(couponListModel!.data![index].link!);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorCode.buttonColor,
            ),
            child: const Center(
              child: Text(
                "View",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  showCouponDetails(index) => showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              couponListModel!.data![index].title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              couponListModel!.data![index].details!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/coin.png",
                    height: 30,
                    width: 30,
                  ),
                  Text(
                    "${couponListModel!.data![index].coin} Coins required",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                Navigator.pop(ctx);
                if (int.parse(couponListModel!.data![index].coin!) <=
                    Provider.of<DashboardProvider>(context, listen: false)
                        .dashboardModel!
                        .data!
                        .user!
                        .earnCoins!) {
                  Response response = await ShopServices()
                      .getRedeemCouponData(
                      couponListModel!.data![index].id!.toString());

                  if(response.statusCode==200 || response.statusCode == 201) {
                    getShopData();
                    push(
                      context: context,
                      page: UnlockCouponPage(
                      url: couponListModel!
                          .data![index].couponMediaId!.url!,
                      coin: couponListModel!.data![index].coin!,
                      title: couponListModel!.data![index].title!,
                    ),
                    );
                  }
                } else {
                  push(
                    context: context,
                    page: const RaisedCampaignPage(),
                  );
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ColorCode.buttonColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Redeem Now!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    ),
  );
}
