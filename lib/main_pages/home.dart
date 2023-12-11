import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/competition/individual_competition.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../profiles/random_user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;
  var items = [];

  void getData() async {
    setState(() {
      isLoading = true;
    });
    items = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firestore.collection('Competitions');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      items.add(data);
    }
    print(items);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  var colors = [
    Colors.green,
    Colors.blue,
    Colors.green,
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.green,
    Colors.green,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height,
                    child: PageView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                height: Get.height * 0.9,
                                decoration: BoxDecoration(
                                    color: colors[index],
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xfffc466b),
                                        Color(0xff3f5efb)
                                      ],
                                      stops: [0.25, 0.75],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return IndividualCompetitionsScreen(
                                              id: items[index]["id"]);
                                        }),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            // gradient: const LinearGradient(
                                            //     colors: [
                                            //       Color(0xff09203F),
                                            //       Color(0xff537895)
                                            //     ]),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: Get.height * 0.275,
                                                    width: Get.width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20)),
                                                        child: Image.network(
                                                          items[index]["image"],
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  Positioned(
                                                    top: Get.height * 0.025,
                                                    right: Get.width * 0.076,
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                                0xff65696E)
                                                            .withOpacity(0.4),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              DateFormat("d")
                                                                  .format(
                                                                DateTime.parse(
                                                                  items[index][
                                                                      "start_time"],
                                                                ),
                                                              ),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              DateFormat("MMMM")
                                                                  .format(
                                                                DateTime.parse(
                                                                  items[index][
                                                                      "start_time"],
                                                                ),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            items[index]
                                                                ["name"],
                                                            style: TextStyle(
                                                                fontSize: 23,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: isDark(
                                                                        context)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Theme: ${items[index]["type"]}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey),
                                                    ),
                                                    const Gap(10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Row(
                                                          children: [
                                                            Icon(Icons
                                                                .date_range),
                                                            Gap(3),
                                                            Text("Entry Fee",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ],
                                                        ),
                                                        Text(
                                                          "\$ ${items[index]["entry_fee"]}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    const Gap(10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Row(
                                                          children: [
                                                            Icon(Icons
                                                                .date_range),
                                                            Gap(3),
                                                            Text(
                                                                "Starting Time",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ],
                                                        ),
                                                        Text(
                                                          "${DateFormat("hh:mm a").format(
                                                            DateTime.parse(
                                                              items[index][
                                                                  "start_time"],
                                                            ),
                                                          )}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    const Gap(10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Row(
                                                          children: [
                                                            Icon(Icons
                                                                .date_range),
                                                            Gap(3),
                                                            Text("Ending Time",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ],
                                                        ),
                                                        Text(
                                                          "${DateFormat("hh:mm a").format(
                                                            DateTime.parse(
                                                              items[index]
                                                                  ["end_time"],
                                                            ),
                                                          )}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    Gap(10),
                                                    Center(
                                                      child: Text(
                                                        "Prize Money",
                                                        style: TextStyle(
                                                            color: Colors.white,fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Gap(3),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      width: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "\$ ${items[index][
                                                                  "prize_money"]}"
                                                              .toString(),
                                                          style: TextStyle(fontSize: 24,
                                                              color:
                                                                  Colors.white,fontWeight: FontWeight.w800),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.03,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ));
  }
}
