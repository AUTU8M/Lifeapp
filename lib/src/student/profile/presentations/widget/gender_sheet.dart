import 'package:flutter/material.dart';

genderBottomSheet({required BuildContext context, required dynamic provider}) => showModalBottomSheet(
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
            "Select Gender",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: ["MALE", "FEMALE", "OTHER"]
                .map((e) => Container(
              padding: const EdgeInsets.only(bottom: 30),
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  provider.sexController.text = e;
                  provider.gender = ["MALE", "FEMALE", "OTHER"].indexOf(e);
                  provider.notifyListeners();
                  Navigator.pop(context);
                },
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    ),
  ),
);