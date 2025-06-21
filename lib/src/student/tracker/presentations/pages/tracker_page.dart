import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/student/tracker/provider/tracker_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/tracker_app_bar_widget.dart';
import '../widgets/tracker_profile_widget.dart';
import '../widgets/tracker_subject_widget.dart';


class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TrackerProvider>(context, listen: false).trackerData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    return Scaffold(
      body: provider.trackerModel != null ? SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            const TrackerAppbarWidget(),

            const TrackerProfileWidget(),

            const SizedBox(height: 20),
            ...provider.trackerModel!.data!.subjects.entries.map((entry) {
              return Column(
                children: [
                  TrackerSubjectWidget(
                    title: entry.key,
                    data: entry.value,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),

          ],
        ),
      ) : const LoadingWidget(),
    );
  }
}
