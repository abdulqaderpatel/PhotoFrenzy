import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/global/firebase_tables.dart';

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
    return Scaffold(bottomNavigationBar:   Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                  hintText: "Enter comment.."),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
              onTap: () async {
                int time = DateTime.now().millisecondsSinceEpoch;
                await FirebaseTable()
                    .commentsTable
                    .doc(time.toString())
                    .set({"id":time.toString(),
                  "postId": widget.postId,
                  "name": userinfo[0]["name"],
                  "username": userinfo[0]["username"],
                  "profile_picture": userinfo[0]
                  ["profile_picture"],
                  "message": commentController.text,
                  "likes": 0,
                  "likers": [],
                  "replies": 0
                });
                commentController.text = "";
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Icon(Icons.send)),
        ],
      ),
    ),resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
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
                                      leading: client["profile_picture"] != null
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              client["message"],
                                              style: TextStyle(),
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
                                                        FieldValue.increment(-1),
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
                                          Text(client["likers"].length.toString()),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        // Navigator.push(context,
                                        //     MaterialPageRoute(builder: (context) {
                                        //       return CommentReplies(
                                        //           postId: widget.postId,
                                        //           commentId: comments[index]["id"],
                                        //           index: index);
                                        //     }));
                                      },
                                      child: Text(
                                        " View replies (0)",
                                        style: TextStyle(fontSize: 16)
                                      ),
                                    ),
                                    SizedBox(
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
                    Gap(30),

                  ],
                ),
              ),
            ),
    );
  }
}
