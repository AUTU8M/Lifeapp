import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/student/vision/presentations/vision_page.dart';
import 'package:provider/provider.dart';
import 'package:lifelab3/src/student/vision/providers/vision_provider.dart';
import 'package:lifelab3/src/common/helper/image_helper.dart'; // for icons
import 'package:lifelab3/src/student/subject_level_list/presentation/pages/subject_level_list_page.dart'; // Add this import
import '../../subject_level_list/provider/subject_level_provider.dart'; // Add this import

class SubjectPage extends StatelessWidget {
  final String navName;

  const SubjectPage({super.key, required this.navName});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {
        "name": "Science",
        "description": "science in our daily life",
        "id": "1",
        "icon": ImageHelper.scienceIcon,
      },
      {
        "name": "Maths",
        "description": "Math Magic",
        "id": "2",
        "icon": ImageHelper.mathsIcon,
      },
      {
        "name": "Financial Literacy",
        "description": "Financial Literacy",
        "id": "12",
        "icon": ImageHelper.financeIcon,
      },
    ];

    return Scaffold(
      appBar: commonAppBar(context: context, name: "Subjects"),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return _buildSubjectCard(context, subject);
        },
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map subject) {
    final visionProvider = VisionProvider();
    final subjectLevelProvider = SubjectLevelProvider(); // Add this

    return GestureDetector(
      onTap: () {
        // Navigate to SubjectLevelListPage instead of VisionPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: subjectLevelProvider,
              child: SubjectLevelListPage(
                subjectName: subject["name"],
                subjectId: subject["id"],
                navname: navName,
              ),
            ),
          ),
        );

        // If you still need to initialize the vision provider for some reason,
        // you can keep this but it might not be necessary anymore
        WidgetsBinding.instance.addPostFrameCallback((_) {
          visionProvider.initWithSubject(subject["id"] , '1');
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject["name"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject["description"],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              subject["icon"],
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}