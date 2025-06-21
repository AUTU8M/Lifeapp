import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:lifelab3/src/common/widgets/common_navigator.dart';
import 'package:lifelab3/src/common/widgets/loading_widget.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/presentations/pages/mentor_create_session_page.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/presentation/widgets/mentor_my_session_list_add_session_button.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/provider/mentor_my_session_list_provider_page.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/custom_button.dart';

class MentorMySessionListPage extends StatefulWidget {
  const MentorMySessionListPage({super.key});

  @override
  State<MentorMySessionListPage> createState() => _MentorMySessionListPageState();
}

class _MentorMySessionListPageState extends State<MentorMySessionListPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MentorMySessionListProvider>(context, listen: false).getMySession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MentorMySessionListProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.mySession,
        action: MentorMySessionListAddSessionButton(provider: provider),
      ),
      body: provider.mySessionModel != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: provider.mySessionModel!.data!.sessions!.data!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            // TODO
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              border: Border.all(color: Colors.black54),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        provider.mySessionModel!.data!.sessions!.data![index].heading!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        push(
                          context: context,
                          page: const MentorCreateSessionPage(),
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "${provider.mySessionModel!.data!.sessions!.data![index].date!.day}-${provider.mySessionModel!.data!.sessions!.data![index].date!.month}-${provider.mySessionModel!.data!.sessions!.data![index].date!.year}",
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Time
                        const SizedBox(height: 7),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              provider.mySessionModel!.data!.sessions!.data![index].time!,
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    CustomButton(
                      name: StringHelper.copyLink,
                      color: ColorCode.buttonColor,
                      height: 35,
                      width: 100,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: provider.mySessionModel!.data!.sessions!.data![index].zoomLink!));
                        Fluttertoast.showToast(msg: "Copied");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) : const LoadingWidget(),
    );
  }
}
