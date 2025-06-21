import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';

schoolsBottomSheet(
        {required BuildContext context, required String schoolName, required dynamic provider}) =>
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    StringHelper.selectYourSchool,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.schoolListModel!.data!.school!.length,
                      itemBuilder: (builder, index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 12, top: 8),
                              title: Text(
                                provider.schoolListModel!.data!.school![index].name ?? "",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              onTap: () {
                                provider.schoolNameController.text = provider.schoolListModel!.data!.school![index].name!;
                                Navigator.of(context).pop();
                              },
                            ),
                            const Divider(
                              color: Colors.black54,
                              height: 0.2,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
