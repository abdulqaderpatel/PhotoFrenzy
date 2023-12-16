import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/main_pages/profile.dart';
import 'package:photofrenzy/user_posts/replies.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final String description;
  final String imageurl;

  const CommentsScreen(
      {required this.postId,
      required this.description,
      super.key,
      this.imageurl = ""});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
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

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Comments"),),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: "Enter comment.."),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
                onTap: () async {

                  int time = DateTime.now().millisecondsSinceEpoch;
                  await FirebaseTable().commentsTable.doc(time.toString()).set({
                    "id": time.toString(),
                    "creator_id": FirebaseAuth.instance.currentUser!.uid,
                    "postId": widget.postId,
                    "name": userinfo[0]["name"],
                    "username": userinfo[0]["username"],
                    "profile_picture": userinfo[0]["profile_picture"],
                    "message": commentController.text,
                    "likes": 0,
                    "likers": [],
                    "replies": 0
                  });

                  commentController.text = "";
                  FocusManager.instance.primaryFocus?.unfocus();
                  await FirebaseTable()
                      .postsTable
                      .doc(widget.postId)
                      .update({"comments": FieldValue.increment(1)});


                  for (int i = 0; i < userController.textposts.length; i++) {
                    if (userController.textposts[i].post_id == widget.postId) {
                      userController.textposts[i].comments++;
                      break;
                    }
                  }

                  for (int i = 0; i < userController.imageposts.length; i++) {
                    if (userController.imageposts[i].post_id == widget.postId) {
                      userController.imageposts[i].comments++;
                      break;
                    }
                  }
                },
                child: const Icon(Icons.send)),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseTable()
                            .commentsTable
                            .where("postId", isEqualTo: widget.postId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Column> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = Column(
                                children: [
                                  ListTile(
                                    leading: client["profile_picture"] == null
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
                                          Text(
                                            "${client["username"]}",
                                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w800)
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            client["message"],
                                            style: const TextStyle(color: Colors.grey),
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
                                                    .commentsTable
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
                                                    .commentsTable
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
                                  InkWell(
                                    onTap: () async {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                        return RepliesScreen(
                                          postId: widget.postId,
                                          commentId: client["id"],
                                          description: client["message"],
                                        );
                                      }));
                                    },
                                    child: Text(client["replies"]==0?"Reply":"View Replies (${client["replies"]})",
                                        style: const TextStyle(fontSize: 16)),
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
                  ],
                ),
              ),
            ),
    );
  }
}
