import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/custom_text_field.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/presentations/widgets/mentor_create_seesion_submit_button.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/provider/mentor_create_session_provider.dart';
import 'package:provider/provider.dart';

class MentorCreateSessionPage extends StatelessWidget {
  const MentorCreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MentorCreateSessionProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: commonAppBar(
          context: context,
          name: StringHelper.createSession,
        ),
        bottomNavigationBar: MentorCreateSessionSubmitButton(provider: provider,),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              // Heading
              CustomTextField(
                readOnly: false,
                maxLines: 4,
                color: Colors.white,
                hintName: StringHelper.sessionHeading,
                fieldController: provider.headingController,
                keyboardType: TextInputType.multiline,
              ),

              // Heading
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: false,
                maxLines: 10,
                color: Colors.white,
                hintName: StringHelper.sessionDesc,
                fieldController: provider.descController,
                keyboardType: TextInputType.multiline,
              ),

              // Date
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      readOnly: true,
                      maxLines: 1,
                      color: Colors.white,
                      hintName: StringHelper.date,
                      fieldController: provider.dateController,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: provider.currentDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          provider.currentDate = picked;
                          provider.dateController.text =
                              "${picked.day}-${picked.month}-${picked.year}";
                          provider.notifyListeners();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorCode.buttonColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.date_range_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Time
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      readOnly: true,
                      maxLines: 1,
                      color: Colors.white,
                      hintName: StringHelper.time,
                      fieldController: provider.timeController,
                      onTap: () async {
                        final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: false),
                                child: child!,
                              );
                            });

                        if (time != null) {
                          provider.time = time;
                          provider.timeController.text = "${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                          provider.notifyListeners();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorCode.buttonColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
