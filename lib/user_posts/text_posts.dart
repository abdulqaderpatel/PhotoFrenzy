import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/main_pages/profile.dart';

import 'package:photofrenzy/user_posts/comments.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';

class TextPostsScreen extends StatefulWidget {
  final String id;

  const TextPostsScreen({required this.id, super.key});

  @override
  State<TextPostsScreen> createState() => _TextPostsScreenState();
}

class _TextPostsScreenState extends State<TextPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.only(
            top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseTable()
                .postsTable
                .where("creator_id", isEqualTo: widget.id)
                .where("type", isEqualTo: "text")
                .snapshots(),
            builder: (context, snapshot) {
              List<Container> clientWidgets = [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs;
                for (var client in clients!) {
                  final clientWidget = Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.8),
                                  borderRadius: BorderRadius.circular(80)),
                              child: client["creator_profile_picture"] == ""
                                  ? const CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        "assets/images/profile_picture.png",
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        client["creator_profile_picture"],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: Get.width * 0.04,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client["creator_name"],
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: isDark(context)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  "@${client["creator_username"]}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDark(context)
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Get.width * 0.17),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      client["text"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () async {},
                                      child: Icon(
                                          client["creator_name"] == "fdsfds"
                                              ? Icons.favorite_outline
                                              : Icons.favorite)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Text("0"),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(
                                      onTap: () {

                                      },
                                      child: const Icon(
                                          Icons.chat_bubble_outline)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Text(
                                    "0",
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(onTap: (){
                                    shareText(context, client["text"]);
                                  },child: const Icon(Icons.replay_outlined)),

                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                  clientWidgets.add(clientWidget);
                }
              }

              return Column(
                children: clientWidgets,
              );
            }),
      ),
    ));
  }
}
