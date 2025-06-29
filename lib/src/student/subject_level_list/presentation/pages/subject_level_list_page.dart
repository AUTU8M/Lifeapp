import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/subject_level_provider.dart';
import '../widgets/subject_level_details_widget.dart';

class SubjectLevelListPage extends StatefulWidget {

  final String subjectId;
  final String navname;

  const SubjectLevelListPage({super.key, required this.subjectId, required this.navname});
  @override
  State<SubjectLevelListPage> createState() => _SubjectLevelListPageState();
}

class _SubjectLevelListPageState extends State<SubjectLevelListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SubjectLevelProvider>(context, listen: false).getLevel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectLevelProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: " ${StringHelper.levels}",
      ),
      body: provider.levels != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.levels!.data!.laLevels!.length,
        itemBuilder: (context, index) => SubjectLevelDetailsWidget(
          provider: provider,
          index: index,
          subjectId: widget.subjectId,
          navName: widget.navname,
        ),
      ) : const LoadingWidget(),
    );
  }
}
