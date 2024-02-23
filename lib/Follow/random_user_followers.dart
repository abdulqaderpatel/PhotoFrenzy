import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../global/firebase_tables.dart';

class RandomUserFollowers extends StatefulWidget {
  final String id;

  const RandomUserFollowers({required this.id, super.key});

  @override
  State<RandomUserFollowers> createState() => _RandomUserFollowersState();
}

class _RandomUserFollowersState extends State<RandomUserFollowers> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff00141C)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff00141C),
          title: const Text("Followers"),
        ),
        body: Container(
          color: const Color(0xff0A171F),
          child: Container(
            margin: EdgeInsets.symmetric(),
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
                                  final clientWidget =
                                      client["following"].contains(widget.id)
                                          ? Container(
                                              child: Card(
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
                                                                    NetworkImage(
                                                                        client[
                                                                            "profile_picture"]),
                                                              ),
                                                    title: Text(
                                                      client["username"],
                                                      style: const TextStyle(
                                                          color: Colors.white,
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
      ),
    );
  }
}
