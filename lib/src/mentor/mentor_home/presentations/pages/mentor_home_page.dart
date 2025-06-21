import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/mentor/mentor_home/presentations/widgets/mentor_my_session_widget.dart';
import 'package:lifelab3/src/mentor/mentor_home/presentations/widgets/mentor_upcoming_session_widget.dart';
import 'package:lifelab3/src/mentor/mentor_home/provider/mentor_home_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/mentor_home_app_bar.dart';
import '../widgets/mentor_home_drawer.dart';

class MentorHomePage extends StatefulWidget {
  const MentorHomePage({super.key});

  @override
  State<MentorHomePage> createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MentorHomeProvider>(context, listen: false).storeToken();
      Provider.of<MentorHomeProvider>(context, listen: false).upcomingSession(context);
      Provider.of<MentorHomeProvider>(context, listen: false).getDashboardData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MentorHomeProvider>(context);
    return Scaffold(
      drawer: const MentorDrawerView(),
      body: provider.dashboardModel != null ? RefreshIndicator(
        onRefresh: () async {
          provider.upcomingSession(context);
          provider.getDashboardData();
        },
        edgeOffset: 50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              MentorHomeAppBar(
                name: provider.dashboardModel!.data!.user!.name!,
                img: provider.dashboardModel!.data!.user!.imagePath,
              ),

              const SizedBox(height: 20),
              const MentorMySessionWidget(),

              const SizedBox(height: 20),
              if(provider.upcomingSessionModel != null) MentorUpcomingSessionWidget(provider: provider,),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
