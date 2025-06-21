import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/custom_text_field.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:provider/provider.dart';

class SearchContactWidget extends StatelessWidget {
  const SearchContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringHelper.addFromYourContacts,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          readOnly: false,
          hintName: StringHelper.searchInYourContact,
          maxLines: 1,
          height: 50,
          color: Colors.white,
          fieldController: Provider.of<StudentProgressProvider>(context).searchController,
          suffix: const Icon(
            Icons.search_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
      ],
    );
  }
}
