import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';

class RandomUserFollowing extends StatefulWidget {
  final String id;

  const RandomUserFollowing({required this.id, super.key});

  @override
  State<RandomUserFollowing> createState() => _RandomUserFollowingState();
}

class _RandomUserFollowingState extends State<RandomUserFollowing> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff00141C)),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Following"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.78,
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseTable()
                              .usersTable
                              .where("id", isNotEqualTo: widget.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = client["followers"]
                                        .contains(widget.id)
                                    ? Container(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: isDark(context)
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: ListTile(
                                              leading:
                                                  client["profile_picture"] ==
                                                          ""
                                                      ? const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  "assets/images/profile_picture.png"),
                                                        )
                                                      : CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(client[
                                                                  "profile_picture"]),
                                                        ),
                                              title: Text(
                                                client["username"],
                                                style:  TextStyle(
                                                    color:isDark(context)? Colors.white:Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              subtitle: Text(
                                                client["name"],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )),
                                      )
                                    : Container();
                                clientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: clientWidgets,
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
