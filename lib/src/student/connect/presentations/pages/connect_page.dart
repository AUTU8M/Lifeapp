import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/loading_widget.dart';
import '../../provider/connect_provider.dart';
import '../widgets/connect_app_bar.dart';
import '../widgets/connect_attended_session_widget.dart';
import '../widgets/connect_tab_bar.dart';
import '../widgets/connect_upcoming_session_widget.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ConnectProvider>(context, listen: false).upcomingSession(context);
      Provider.of<ConnectProvider>(context, listen: false).attendSession(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConnectProvider>(context);
    return Scaffold(
      body: provider.upcomingSessionModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            const ConnectAppbarWidget(),

            const SizedBox(height: 20),
            ConnectTabBar(provider: provider),

            provider.tabIndex == 0
                ? ConnectUpcomingSessionWidget(provider: provider)
                : ConnectAttendedSessionWidget(provider: provider),
          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}