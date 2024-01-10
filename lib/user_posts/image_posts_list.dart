import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/user_posts/comments.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../global/theme_mode.dart';

class ImagePostsListScreen extends StatefulWidget {
  final List<ImagePost> images;
  final int count;

  const ImagePostsListScreen(this.images, this.count, {super.key});

  @override
  State<ImagePostsListScreen> createState() => _ImagePostsListScreenState();
}

class _ImagePostsListScreenState extends State<ImagePostsListScreen> {
  UserController userController = Get.put(UserController());
  ItemScrollController itemScrollController = ItemScrollController();

  var parser = EmojiParser();

  var a = EmojiParser().get("coffee");

  var reactions = [
    Reaction<String>(
      value: 'happy',
      icon: Text(
        Emoji("happy", "😊").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'sad',
      icon: Text(
        Emoji("sad", "😔").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'fear',
      icon: Text(
        Emoji("fear", "😨").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'anger',
      icon: Text(
        Emoji("anger", "😠").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'disgust',
      icon: Text(
        Emoji("disgust", "🤢").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'surprise',
      icon: Text(
        Emoji("surprise", "😲").code,
        style: TextStyle(fontSize: 22),
      ),
    ),
  ];

  var emojis = [
    Emoji("happy", "😊"),
    Emoji("sad", "😔"),
    Emoji("fear", "😨"),
    Emoji("anger", "😠"),
    Emoji("disgust", "🤢"),
    Emoji("surprise", "😲")
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Your Posts"),),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(
            top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
        child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            initialScrollIndex: widget.count,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {

              DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(
                  userController
                      .imageposts[index].post_id!));
              DateTime now = DateTime.now();

              String formattedTime = '';

              // Check if the date is today
              if (dateTime.year == now.year &&
                  dateTime.month == now.month &&
                  dateTime.day == now.day) {
                formattedTime = 'Today';
              } else {
                // Format the date
                formattedTime =
                    DateFormat('MMM d').format(dateTime);
              }

              // Format time (e.g., 3pm)
              formattedTime +=
                  ', ' + DateFormat.jm().format(dateTime);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.8),
                              borderRadius: BorderRadius.circular(80)),
                          child:
                              widget.images[index].creator_profile_picture == ""
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
                                        widget.images[index]
                                            .creator_profile_picture!,
                                      ),
                                    ),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userController
                                        .imageposts[index]
                                        .creator_name!,
                                    style: TextStyle(
                                        fontSize: 19,fontWeight: FontWeight.w800,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "@${userController.imageposts[index].creator_username}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(formattedTime)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  userController
                                      .imageposts[index].text!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isDark(context)
                                          ? Colors.white
                                          : Colors.black,fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.images[index].imageurl!,
                                // Replace with the path to your image
                                fit: BoxFit
                                    .fill, // Use BoxFit.fill to force the image to fill the container
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (!userController
                                      .imageposts[index].likers
                                      .contains(FirebaseAuth
                                      .instance
                                      .currentUser!
                                      .uid)) {
                                    setState(() {
                                      userController
                                          .imageposts[index]
                                          .likes++;
                                      userController
                                          .imageposts[index]
                                          .likers
                                          .add(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(userController
                                        .imageposts[index]
                                        .post_id)
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          1),
                                      "likers": FieldValue
                                          .arrayUnion([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  } else {
                                    setState(() {
                                      userController
                                          .imageposts[index]
                                          .likes--;
                                      userController
                                          .imageposts[index]
                                          .likers
                                          .remove(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(userController
                                        .imageposts[index]
                                        .post_id)
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          -1),
                                      "likers": FieldValue
                                          .arrayRemove([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  }
                                },
                                child: Obx(
                                      () => SizedBox(
                                    height: 33,
                                    child:
                                    ReactionButton<String>(
                                      toggle: false,
                                      direction:
                                      ReactionsBoxAlignment
                                          .rtl,
                                      onReactionChanged:
                                          (Reaction<String>?
                                      reaction) async {
                                        if (!userController
                                            .imageposts[index]
                                            .likers
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          setState(() {
                                            userController
                                                .imageposts[
                                            index]
                                                .likers
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                            userController
                                                .imageposts[
                                            index]
                                                .likes++;
                                          });
                                          await FirebaseTable()
                                              .postsTable
                                              .doc(userController
                                              .imageposts[
                                          index]
                                              .post_id)
                                              .update({
                                            "likers": FieldValue
                                                .arrayUnion([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid
                                            ]),
                                            "likes": FieldValue
                                                .increment(1)
                                          });
                                        }

                                        var userReaction =
                                            "none";
                                        userReaction = userController
                                            .imageposts[
                                        index]
                                            .happy
                                            .contains(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            ? "happy"
                                            : userController
                                            .imageposts[
                                        index]
                                            .sad
                                            .contains(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            ? "sad"
                                            : userController
                                            .imageposts[index]
                                            .fear
                                            .contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? "fear"
                                            : userController.imageposts[index].anger.contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? "anger"
                                            : userController.imageposts[index].disgust.contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? "disgust"
                                            : userController.imageposts[index].surprise.contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? "surprise"
                                            : "none";
                                        if (userReaction ==
                                            "none") {
                                          await FirebaseTable()
                                              .postsTable
                                              .doc(userController
                                              .imageposts[
                                          index]
                                              .post_id)
                                              .update({
                                            "${reaction!.value}":
                                            FieldValue
                                                .arrayUnion([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid
                                            ]),
                                          });
                                        } else {
                                          await FirebaseTable()
                                              .postsTable
                                              .doc(userController
                                              .imageposts[
                                          index]
                                              .post_id)
                                              .update({
                                            "${reaction!.value}":
                                            FieldValue
                                                .arrayUnion([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid
                                            ]),
                                            userReaction:
                                            FieldValue
                                                .arrayRemove([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid
                                            ])
                                          });
                                        }
                                        if (!userController
                                            .imageposts[index]
                                            .likers
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          if (reaction.value ==
                                              "happy") {
                                            userController
                                                .imageposts[
                                            index]
                                                .happy
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            userController
                                                .imageposts[
                                            index]
                                                .sad
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            userController
                                                .imageposts[
                                            index]
                                                .fear
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            userController
                                                .imageposts[
                                            index]
                                                .disgust
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            userController
                                                .imageposts[
                                            index]
                                                .anger
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            userController
                                                .imageposts[
                                            index]
                                                .surprise
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          }
                                        } else {
                                          userReaction ==
                                              "happy"
                                              ? userController
                                              .imageposts[
                                          index]
                                              .happy
                                              .remove(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              : userReaction ==
                                              "sad"
                                              ? userController
                                              .imageposts[
                                          index]
                                              .sad
                                              .remove(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              : userReaction ==
                                              "disgust"
                                              ? userController
                                              .imageposts[
                                          index]
                                              .disgust
                                              .remove(FirebaseAuth.instance.currentUser!.uid)
                                              : userReaction == "anger"
                                              ? userController.imageposts[index].anger.remove(FirebaseAuth.instance.currentUser!.uid)
                                              : userReaction == "fear"
                                              ? userController.imageposts[index].fear.remove(FirebaseAuth.instance.currentUser!.uid)
                                              : userController.imageposts[index].surprise.remove(FirebaseAuth.instance.currentUser!.uid);
                                          if (reaction.value ==
                                              "happy") {
                                            userController
                                                .imageposts[
                                            index]
                                                .happy
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            userController
                                                .imageposts[
                                            index]
                                                .sad
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            userController
                                                .imageposts[
                                            index]
                                                .fear
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            userController
                                                .imageposts[
                                            index]
                                                .disgust
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            userController
                                                .imageposts[
                                            index]
                                                .anger
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            userController
                                                .imageposts[
                                            index]
                                                .surprise
                                                .add(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                          }
                                        }
                                      },
                                      reactions: reactions,
                                      placeholder: Reaction<
                                          String>(
                                          value: null,
                                          icon: !userController
                                              .imageposts[
                                          index]
                                              .likers
                                              .contains(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              ? const Icon(Icons
                                              .thumb_up)
                                              : userController
                                              .imageposts[
                                          index]
                                              .happy
                                              .contains(
                                              FirebaseAuth.instance.currentUser!.uid)
                                              ? Text(emojis[0].code, style: const TextStyle(fontSize: 22))
                                              : userController.imageposts[index].sad.contains(FirebaseAuth.instance.currentUser!.uid)
                                              ? Text(emojis[1].code, style: const TextStyle(fontSize: 22))
                                              : userController.imageposts[index].fear.contains(FirebaseAuth.instance.currentUser!.uid)
                                              ? Text(emojis[2].code, style: const TextStyle(fontSize: 22))
                                              : userController.imageposts[index].anger.contains(FirebaseAuth.instance.currentUser!.uid)
                                              ? Text(emojis[3].code, style: const TextStyle(fontSize: 22))
                                              : userController.imageposts[index].disgust.contains(FirebaseAuth.instance.currentUser!.uid)
                                              ? Text(emojis[4].code, style: const TextStyle(fontSize: 22))
                                              : Text(emojis[5].code, style: const TextStyle(fontSize: 22))),
                                      boxColor: Colors.black
                                          .withOpacity(0.5),
                                      boxRadius: 10,
                                      itemsSpacing: 0,
                                      itemSize:
                                      const Size(35, 35),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder:
                                        (BuildContext context) {
                                      return AlertDialog(
                                        title: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Reactions',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              )
                                            ]),
                                        content: Container(
                                          margin:
                                          EdgeInsets.all(
                                              10),
                                          width: Get.width,
                                          child: Column(mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[0].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].happy.length.toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[1].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].sad.length.toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[2].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].fear.length.toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[3].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].anger.length.toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[4].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].disgust.length.toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[5].code,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                    Text(userController.imageposts[index].surprise.length.toString())
                                                  ],
                                                ),
                                              ]



                                          ),
                                        ),
                                        actions: <Widget>[
                                          Center(
                                            child: TextButton(
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors
                                                        .red,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(userController
                                    .imageposts[index].likes
                                    .toString()),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommentsScreen(
                                        postId: widget.images[index].post_id!,
                                        description: widget.images[index].text!,
                                        imageurl:
                                            widget.images[index].imageurl!,
                                      );
                                    }));
                                  },
                                  child: const Icon(Icons.chat_bubble_outline)),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                userController.imageposts[index].comments
                                    .toString(),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              const Icon(Icons.replay_outlined),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                              ),
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
            }),
      )),
    );
  }
}
