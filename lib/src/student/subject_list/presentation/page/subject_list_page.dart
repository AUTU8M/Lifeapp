import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/subject_details_widget.dart';

class SubjectListPage extends StatelessWidget {

  final String navName;

  const SubjectListPage({super.key, required this.navName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, name: StringHelper.subjects),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.subjectModel!.data!.subject!.length,
        itemBuilder: (context, index) => SubjectDetailsWidget(
          provider: provider,
          index: index,
          navName: navName,
        ),
      ),
    );
  }
}
