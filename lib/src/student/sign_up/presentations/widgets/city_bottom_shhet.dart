import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/student/sign_up/provider/sign_up_provider.dart';

cityBottomSheet(
        {required BuildContext context, required SignUpProvider provider}) =>
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
          builder: (context, state) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 100, right: 100, top: 15),
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  StringHelper.selectCity,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: const Icon(
                                    Icons.subdirectory_arrow_left,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                              ),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0)),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                child: Center(
                                  child: TextFormField(
                                    controller: provider.citySearchCont,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey.shade400,
                                          size: 24),
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      if(val.isNotEmpty) {
                                        provider.searchCityList = List.from(provider.cityList.where((element) => element.cityName!.toLowerCase()
                                            .contains(provider.citySearchCont.text.toLowerCase())));
                                      } else {
                                        provider.searchCityList = provider.cityList;
                                        provider.notifyListeners();
                                      }
                                      state(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if (provider.searchCityList.isNotEmpty)
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: provider.searchCityList.length,
                                    itemBuilder: (builder, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 12, top: 8),
                                            title: Text(
                                              provider.searchCityList[index]
                                                  .cityName!,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            onTap: () {
                                              provider.cityController.text =
                                                  provider.searchCityList[index]
                                                      .cityName!;
                                              provider.citySearchCont.clear();
                                              state(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const Divider(
                                            color: Colors.black54,
                                            height: 0.2,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
    );
