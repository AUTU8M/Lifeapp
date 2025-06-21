import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/api_helper.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class TrackerProfileWidget extends StatelessWidget {
  const TrackerProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    return Row(
      children: [
        provider.dashboardModel!.data!.user!.profileImage != null
            ? CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(ApiHelper.imgBaseUrl + provider.dashboardModel!.data!.user!.imagePath!),
        )
            : const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(ImageHelper.profileImg),
        ),

        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.dashboardModel!.data!.user!.name!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),
            Text(
              provider.dashboardModel!.data!.user!.mobileNo!.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),

            // SizedBox(height: 3),
            Text(
              "${provider.dashboardModel!.data!.user!.section != null ? provider.dashboardModel!.data!.user!.section!.name : ""} | ${provider.dashboardModel!.data!.user!.school?.name ?? ""}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        )
      ],
    );
  }
}
