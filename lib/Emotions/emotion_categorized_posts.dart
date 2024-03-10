import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/main_pages/profile.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../user_posts/comments.dart';

class EmotionCategorizedPosts extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final String emotion;

  const EmotionCategorizedPosts(
      {required this.posts, required this.emotion, super.key});

  @override
  State<EmotionCategorizedPosts> createState() =>
      _EmotionCategorizedPostsState();
}

class _EmotionCategorizedPostsState extends State<EmotionCategorizedPosts> {


  var parser = EmojiParser();

  var a = EmojiParser().get("coffee");

  var reactions = [
    Reaction<String>(
      value: 'happy',
      icon: Text(
        Emoji("happy", "😊").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'sad',
      icon: Text(
        Emoji("sad", "😔").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'fear',
      icon: Text(
        Emoji("fear", "😨").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'anger',
      icon: Text(
        Emoji("anger", "😠").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'disgust',
      icon: Text(
        Emoji("disgust", "🤢").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'surprise',
      icon: Text(
        Emoji("surprise", "😲").code,
        style: const TextStyle(fontSize: 22),
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

  var emotionSpecificPosts = [];

  @override
  void initState() {
    super.initState();
    if (widget.emotion == "happy") {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["happy"].length > widget.posts[i]["sad"].length &&
            widget.posts[i]["happy"].length >
                widget.posts[i]["anger"].length &&
            widget.posts[i]["happy"].length > widget.posts[i]["fear"].length &&
            widget.posts[i]["happy"].length >
                widget.posts[i]["disgust"].length &&
            widget.posts[i]["happy"].length >
                widget.posts[i]["surprise"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
      widget.posts.map((e) {

      });
    }
    else if (widget.emotion == "sad") {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["sad"].length > widget.posts[i]["happy"].length &&
            widget.posts[i]["sad"].length >
                widget.posts[i]["anger"].length &&
            widget.posts[i]["sad"].length > widget.posts[i]["fear"].length &&
            widget.posts[i]["sad"].length >
                widget.posts[i]["disgust"].length &&
            widget.posts[i]["sad"].length >
                widget.posts[i]["surprise"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
      widget.posts.map((e) {});
    }
    else if (widget.emotion == "anger") {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["anger"].length > widget.posts[i]["sad"].length &&
            widget.posts[i]["anger"].length >
                widget.posts[i]["happy"].length &&
            widget.posts[i]["anger"].length > widget.posts[i]["fear"].length &&
            widget.posts[i]["anger"].length >
                widget.posts[i]["disgust"].length &&
            widget.posts[i]["anger"].length >
                widget.posts[i]["surprise"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
      widget.posts.map((e) {

      });
    }
    else if (widget.emotion == "fear") {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["fear"].length > widget.posts[i]["sad"].length &&
            widget.posts[i]["fear"].length >
                widget.posts[i]["anger"].length &&
            widget.posts[i]["fear"].length > widget.posts[i]["happy"].length &&
            widget.posts[i]["fear"].length >
                widget.posts[i]["disgust"].length &&
            widget.posts[i]["fear"].length >
                widget.posts[i]["surprise"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
      widget.posts.map((e) {});
    }
    else if (widget.emotion == "disgust") {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["disgust"].length >
            widget.posts[i]["sad"].length &&
            widget.posts[i]["disgust"].length >
                widget.posts[i]["anger"].length &&
            widget.posts[i]["disgust"].length >
                widget.posts[i]["fear"].length &&
            widget.posts[i]["disgust"].length >
                widget.posts[i]["happy"].length &&
            widget.posts[i]["disgust"].length >
                widget.posts[i]["surprise"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
      widget.posts.map((e) {});
    }
    else {
      for (int i = 0; i < widget.posts.length; i++) {
        if (widget.posts[i]["surprise"].length >
            widget.posts[i]["sad"].length &&
            widget.posts[i]["surprise"].length >
                widget.posts[i]["anger"].length &&
            widget.posts[i]["surprise"].length >
                widget.posts[i]["fear"].length &&
            widget.posts[i]["surprise"].length >
                widget.posts[i]["disgust"].length &&
            widget.posts[i]["surprise"].length >
                widget.posts[i]["happy"].length) {
          setState(() {
            emotionSpecificPosts.add(widget.posts[i]);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.emotion), centerTitle: true,),
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: emotionSpecificPosts.length,
                itemBuilder: (context, index) {
                  DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(emotionSpecificPosts[index]["post_id"]));

                  // Get current DateTime
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
                  ', ${DateFormat.jm().format(dateTime)}';

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const Gap(10),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.8),
                                  borderRadius:
                                  BorderRadius.circular(80)),
                              child: emotionSpecificPosts[index]
                              ["creator_profile_picture"] ==
                                  ""
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
                                  emotionSpecificPosts[index]
                                  ["creator_profile_picture"],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.04,
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
                                        emotionSpecificPosts
                                        [index]["creator_name"],
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800,
                                            color: isDark(context)
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      Text(
                                        "@${emotionSpecificPosts[index]["creator_username"]}",
                                        style: const TextStyle(
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
                          margin:
                          EdgeInsets.only(left: Get.width * 0.17),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        emotionSpecificPosts[index]["text"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: isDark(context)
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight:
                                            FontWeight.w500)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              emotionSpecificPosts[index]["type"] ==
                                  "image"
                                  ? Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10)),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  child: Image.network(
                                    emotionSpecificPosts[index]["imageurl"],
                                    // Replace with the path to your image
                                    fit: BoxFit
                                        .fill, // Use BoxFit.fill to force the image to fill the container
                                  ),
                                ),
                              )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (!emotionSpecificPosts[index]["likers"]
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)) {
                                        setState(() {
                                          emotionSpecificPosts[index]
                                          ["likes"]++;
                                          emotionSpecificPosts[index]
                                          ["likers"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(
                                            emotionSpecificPosts[index]
                                            ["post_id"])
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
                                          emotionSpecificPosts[index]
                                          ["likes"]--;
                                          emotionSpecificPosts[index]
                                          ["likers"]
                                              .remove(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(
                                            emotionSpecificPosts[index]
                                            ["post_id"])
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
                                    child: SizedBox(
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
                                          if (!emotionSpecificPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            setState(() {
                                              emotionSpecificPosts[
                                              index]
                                              ["likers"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                              emotionSpecificPosts[
                                              index]
                                              ["likes"]++;
                                            });
                                            await FirebaseTable()
                                                .postsTable
                                                .doc(
                                                emotionSpecificPosts[
                                                index]
                                                ["post_id"])
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
                                          userReaction =
                                          emotionSpecificPosts[
                                          index]
                                          ["happy"]
                                              .contains(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              ? "happy"
                                              : emotionSpecificPosts[
                                          index]
                                          ["sad"]
                                              .contains(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              ? "sad"
                                              : emotionSpecificPosts[
                                          index]
                                          ["fear"]
                                              .contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "fear"
                                              : emotionSpecificPosts[
                                          index]
                                          ["anger"].contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "anger"
                                              : emotionSpecificPosts[
                                          index]
                                          ["disgust"].contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "disgust"
                                              : emotionSpecificPosts[
                                          index]
                                          ["surprise"].contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "surprise"
                                              : "none";
                                          if (userReaction ==
                                              "none") {
                                            await FirebaseTable()
                                                .postsTable
                                                .doc(
                                                emotionSpecificPosts[
                                                index]
                                                ["post_id"])
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
                                                .doc(emotionSpecificPosts[index]
                                            ["post_id"])
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
                                          if (!emotionSpecificPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            if (reaction.value ==
                                                "happy") {
                                              emotionSpecificPosts[
                                              index]
                                              ["happy"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              emotionSpecificPosts[
                                              index]
                                              ["sad"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              emotionSpecificPosts[
                                              index]
                                              ["fear"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              emotionSpecificPosts[
                                              index]
                                              ["disgust"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              emotionSpecificPosts[
                                              index]
                                              ["anger"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              emotionSpecificPosts[
                                              index]
                                              ["surprise"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            }
                                          } else {
                                            userReaction ==
                                                "happy"
                                                ? emotionSpecificPosts[
                                            index]
                                            ["happy"]
                                                .remove(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                : userReaction ==
                                                "sad"
                                                ? emotionSpecificPosts
                                            [index]
                                            ["sad"]
                                                .remove(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                : userReaction ==
                                                "disgust"
                                                ? emotionSpecificPosts[
                                            index]
                                            ["disgust"]
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : userReaction == "anger"
                                                ? emotionSpecificPosts[index]["anger"]
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : userReaction == "fear"
                                                ? emotionSpecificPosts[index]["fear"]
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : emotionSpecificPosts[index]["surprise"]
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid);
                                            if (reaction.value ==
                                                "happy") {
                                              emotionSpecificPosts[index]["happy"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              emotionSpecificPosts[
                                              index]
                                              ["sad"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              emotionSpecificPosts[
                                              index]
                                              ["fear"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              emotionSpecificPosts[index]["disgust"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              emotionSpecificPosts[
                                              index]
                                              ["anger"]
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              emotionSpecificPosts[
                                              index]
                                              ["surprise"]
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
                                            icon: !emotionSpecificPosts[index]
                                            ["likers"]
                                                .contains(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                ? const Icon(Icons
                                                .thumb_up)
                                                : emotionSpecificPosts[
                                            index]
                                            ["happy"]
                                                .contains(
                                                FirebaseAuth.instance
                                                    .currentUser!.uid)
                                                ? Text(emojis[0].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : emotionSpecificPosts[index]["sad"]
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[1].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : emotionSpecificPosts[index]["fear"]
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[2].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                :
                                            emotionSpecificPosts[index]["anger"]
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[3].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : emotionSpecificPosts[index]["disgust"]
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[4].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : Text(emojis[5].code,
                                                style: const TextStyle(
                                                    fontSize: 22))),
                                        boxColor: Colors.black
                                            .withOpacity(0.5),
                                        boxRadius: 10,
                                        itemsSpacing: 0,
                                        itemSize:
                                        const Size(35, 35),
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
                                              const EdgeInsets.all(
                                                  10),
                                              width: Get.width,
                                              child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[0].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["happy"]
                                                                .length
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[1].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["sad"]
                                                                .length
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[2].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["fear"]
                                                                .length
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[3].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["anger"]
                                                                .length
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[4].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["disgust"]
                                                                .length
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          emojis[5].code,
                                                          style: const TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Text(
                                                            emotionSpecificPosts[index]["surprise"]
                                                                .length
                                                                .toString())
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
                                    child: Text(
                                        emotionSpecificPosts[index]["likes"]
                                            .toString()),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CommentsScreen(comments: userController.imageposts[index].comments,
                                                  postId: emotionSpecificPosts[index]
                                                  ["post_id"],
                                                  description: emotionSpecificPosts[index]
                                                  ["text"],
                                                );
                                              },
                                            ));
                                      },
                                      child: const Icon(
                                          Icons.chat_bubble_outline)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    emotionSpecificPosts[index]["comments"]
                                        .toString(),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(onTap: () {
                                    emotionSpecificPosts[index]["type"] ==
                                        "text"
                                        ? shareText(context,
                                        emotionSpecificPosts[index]["text"])
                                        : shareImage(context,
                                        emotionSpecificPosts[index]["text"],
                                        emotionSpecificPosts[index]["imageurl"]);
                                  }, child: const Icon(Icons.replay_outlined)),

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
                        ),
                      ],
                    ),
                  );
                })
        ),
      ),
    );
  }
}
