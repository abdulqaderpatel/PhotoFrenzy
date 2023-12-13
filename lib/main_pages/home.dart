import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/competition/individual_competition.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/individual_chat.dart';
import 'package:photofrenzy/models/user.dart' as user;
import '../global/theme_mode.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var items = [];
  UserController userController = Get.put(UserController());

  void getData() async {
    userController.chattingUsers.clear();
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

    collectionReference = firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Chats");
    querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      userController.chattingUsers.add(user.User(
          id: data["id"],
          name: data["name"],
          username: data["username"],
          imageurl: data["imageurl"]));
    }

    setState(() {
      isLoading = false;
    });
  }

  void loadData() async {
    items = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firestore.collection('Competitions');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        items.add(data);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: false,
            ),
            endDrawer: Drawer(
              // Use endDrawer for right-side drawer
              child: Column(
                children: <Widget>[
                  Container(
                    width: Get.width,
                    color: Colors.blue,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Your Chats',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  Expanded(
                    child:Obx(()=>ListView.builder(
                        itemCount: userController.chattingUsers.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return IndividualChatScreen(
                                      combinedId: userController
                                          .chattingUsers[index].id,
                                      receiverInfo: {
                                        "profile_picture": userController
                                            .chattingUsers[index].imageurl,
                                        "id": userController
                                            .chattingUsers[index].id,
                                        "name": userController
                                            .chattingUsers[index].name,
                                        "username": userController
                                            .chattingUsers[index].username,
                                      });
                                }));
                              },
                              child: ListTile(
                                leading: userController
                                            .chattingUsers[index].imageurl !=
                                        ""
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userController
                                                .chattingUsers[index].imageurl),
                                      )
                                    : const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/profile_picture.png"),
                                      ),
                                title: Text(
                                  "hello",
                                  style: TextStyle(
                                      color: isDark(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  userController.chattingUsers[index].name,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),

                          );
                        }),),
                  ),
                  // Add more ListTile widgets as needed
                ],
              ),
            ),
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
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
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
                                    Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
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
                                                                .monetization_on_sharp),
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
                                                            Icon(Icons.timer),
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
                                                          DateFormat("hh:mm a")
                                                              .format(
                                                            DateTime.parse(
                                                              items[index][
                                                                  "start_time"],
                                                            ),
                                                          ),
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
                                                                .timer_outlined),
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
                                                          DateFormat("hh:mm a")
                                                              .format(
                                                            DateTime.parse(
                                                              items[index]
                                                                  ["end_time"],
                                                            ),
                                                          ),
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
                                                    const Center(
                                                      child: Text(
                                                        "Prize Money",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    const Gap(3),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.purple,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      width: 200,
                                                      child: Center(
                                                        child: Text(
                                                          "\$ ${items[index]["prize_money"]}"
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                    ),
                                                    const Gap(10),
                                                    items[index]["participants"]
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        ? ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              minimumSize: Size(
                                                                  Get.width,
                                                                  40),
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xffff9248),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              primary:
                                                                  Colors.blue,
                                                              // Background color
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                  return IndividualCompetitionsScreen(
                                                                    competitionDetails: {
                                                                      "id": items[
                                                                              index]
                                                                          [
                                                                          "id"],
                                                                      "name": items[
                                                                              index]
                                                                          [
                                                                          "name"],
                                                                      "image": items[
                                                                              index]
                                                                          [
                                                                          "image"],
                                                                      "entry_price":
                                                                          items[index]
                                                                              [
                                                                              "entry_price"],
                                                                      "prize_money":
                                                                          items[index]
                                                                              [
                                                                              "prize_money"],
                                                                      "start_time":
                                                                          items[index]
                                                                              [
                                                                              "start_time"],
                                                                      "end_time":
                                                                          items[index]
                                                                              [
                                                                              "end_time"],
                                                                      "type": items[
                                                                              index]
                                                                          [
                                                                          "type"],
                                                                      "description":
                                                                          items[index]
                                                                              [
                                                                              "description"]
                                                                    },
                                                                  );
                                                                }),
                                                              );
                                                            },
                                                            child: const Text(
                                                                "View Details"))
                                                        : ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              minimumSize: Size(
                                                                  Get.width,
                                                                  40),
                                                              backgroundColor:
                                                                  Colors.orange,
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              primary:
                                                                  Colors.blue,
                                                              onPrimary:
                                                                  Colors.white,
                                                              // Background color
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Competitions")
                                                                  .doc(items[
                                                                          index]
                                                                      ["id"])
                                                                  .update({
                                                                "participants":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                              loadData();
                                                            },
                                                            child: const Text(
                                                                "Compete")),
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
