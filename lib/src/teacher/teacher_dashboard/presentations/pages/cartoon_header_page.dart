import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/custom_button.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_subject_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartoonHeaderPage extends StatefulWidget {
  const CartoonHeaderPage({super.key});

  @override
  State<CartoonHeaderPage> createState() => _CartoonHeaderPageState();
}

class _CartoonHeaderPageState extends State<CartoonHeaderPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TeacherDashboardProvider>(context, listen: false).getConceptCartoonHeader();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.conceptCartoons,
      ),
      body: provider.headerModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.headerModel!.data!.heading!,
              style: const TextStyle(
                color: ColorCode.textBlackColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              provider.headerModel!.data!.description!,
              style: const TextStyle(
                color: ColorCode.textBlackColor,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(imageUrl: ApiHelper.imgBaseUrl + provider.headerModel!.data!.document!.url!),
            ),

            // Read more
            const SizedBox(height: 30),
            const Text(
              "Read more",
              style: TextStyle(
                color: ColorCode.textBlackColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  height: 45,
                  width: MediaQuery.of(context).size.width * .4,
                  name: provider.headerModel!.data!.buttonOneText!,
                  onTap: () {
                    launchUrl(Uri.parse(provider.headerModel!.data!.buttonOneLink!));
                  },
                ),
                CustomButton(
                  height: 45,
                  width: MediaQuery.of(context).size.width * .4,
                  name: provider.headerModel!.data!.buttonTwoText!,
                  onTap: () {
                    launchUrl(Uri.parse(provider.headerModel!.data!.buttonTwoLink!));
                  },
                ),
              ],
            ),

            // Get Started
            const SizedBox(height: 150),
            CustomButton(
              height: 45,
              width: MediaQuery.of(context).size.width,
              name: StringHelper.getStarted,
              onTap: () {
                push(
                  context: context,
                  page: const TeacherSubjectListPage(name: StringHelper.conceptCartoons),
                );
              },
            ),

            const SizedBox(height: 50),
          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}
