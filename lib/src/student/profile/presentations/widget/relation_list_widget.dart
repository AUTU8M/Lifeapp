import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/profile/provider/profile_provider.dart';


void relationListBottomSheet(BuildContext context, ProfileProvider provider) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      color: Colors.white,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringHelper.parentName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: provider.relationList
                .map((e) => Column(
              children: [
                InkWell(
                  onTap: () {
                    provider.parentNameController.text = e.toString();
                    provider.notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.black54, height: 0.2),
                const SizedBox(height: 10),
              ],
            ))
                .toList(),
          ),
          const SizedBox(height: 50),
        ],
      ),
    ),
  ),
);