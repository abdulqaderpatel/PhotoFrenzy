import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:photofrenzy/global/firebase_tables.dart';

import '../global/show_message.dart';

class RepliesScreen extends StatefulWidget {
  final String postId;
  final String commentId;
  final String description;
  final String imageurl;

  const RepliesScreen(
      {required this.postId,
      required this.commentId,
      required this.description,
      super.key,
      this.imageurl = ""});

  @override
  State<RepliesScreen> createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  List<Map<String, dynamic>> userinfo = [];
  var isLoading = false;

  void getComments() async {
    setState(() {
      isLoading = true;
    });

    var data = await FirebaseTable()
        .usersTable
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var element in data.docs) {
      setState(() {
        userinfo.add(
          element.data(),
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  final replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Replies"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseTable()
                              .repliesTable
                              .where("postId", isEqualTo: widget.postId)
                              .where("commentId", isEqualTo: widget.commentId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Column> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = Column(
                                  children: [
                                    ListTile(
                                      leading: client["profile_picture"] == ""
                                          ? const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/profile_picture.png"))
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  client["profile_picture"])),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${client["username"]}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              client["message"],
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: Column(
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                if (!client["likers"].contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)) {
                                                  await FirebaseTable()
                                                      .repliesTable
                                                      .doc(client["id"])
                                                      .update({
                                                    "likes":
                                                        FieldValue.increment(1),
                                                    "likers":
                                                        FieldValue.arrayUnion([
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                    ])
                                                  });
                                                } else {
                                                  await FirebaseTable()
                                                      .repliesTable
                                                      .doc(client["id"])
                                                      .update({
                                                    "likes":
                                                        FieldValue.increment(
                                                            -1),
                                                    "likers":
                                                        FieldValue.arrayRemove([
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                    ])
                                                  });
                                                }
                                              },
                                              child: Icon(client["likers"]
                                                      .contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline)),
                                          Text(client["likers"]
                                              .length
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    )
                                  ],
                                );
                                clientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: clientWidgets,
                            );
                          }),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: replyController,
                            decoration: const InputDecoration(
                                hintText: "Enter reply.."),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                            onTap: () async {
                              if (replyController.text.isEmpty) {
                                showToast(message: "Reply cannot be empty",error: true);
                                return;
                              }
                              int time = DateTime.now().millisecondsSinceEpoch;
                              await FirebaseTable()
                                  .repliesTable
                                  .doc(time.toString())
                                  .set({
                                "id": time.toString(),
                                "creator_id":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "postId": widget.postId,
                                "commentId": widget.commentId,
                                "name": userinfo[0]["name"],
                                "username": userinfo[0]["username"],
                                "profile_picture": userinfo[0]
                                    ["profile_picture"],
                                "message": replyController.text,
                                "likes": 0,
                                "likers": [],
                              });

                              replyController.text = "";
                              FocusManager.instance.primaryFocus?.unfocus();
                              await FirebaseTable()
                                  .commentsTable
                                  .doc(widget.commentId)
                                  .update({"replies": FieldValue.increment(1)});
                            },
                            child: const Icon(Icons.send)),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
