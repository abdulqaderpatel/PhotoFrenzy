import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/Community/add_post_in_community.dart';
import 'package:photofrenzy/components/chat/posts/video.dart';
import 'package:photofrenzy/global/constants.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../user_posts/comments.dart';

class CommunityDetails extends StatefulWidget {
  final Map<String, dynamic> community;

  const CommunityDetails({required this.community, super.key});

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  var textPosts = [];
  var isLoaded = false;

  getData() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .communitiesTable
        .doc(widget.community["name"])
        .collection("Posts")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    textPosts = temp;

    setState(() {
      isLoaded = false;
    });

    print(textPosts);
  }

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


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            leading: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            actions: const [

            ],
            expandedHeight: 165.0,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              bool isAppBarExpanded = constraints.maxHeight >
                  kToolbarHeight + MediaQuery
                      .of(context)
                      .padding
                      .top;
              return Container(
                color: Theme.of(context).colorScheme.secondary,
                child: FlexibleSpaceBar(
                  title: isAppBarExpanded
                      ? const SizedBox()
                      : Container(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                        Text("${widget.community["name"]} Photography",style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return AddPostInCommunity(
                                        community: widget
                                            .community["name"],
                                      );
                                    }));
                          },
                          child: const Icon(Icons.add),
                        ),
                                            ],
                                          ),
                      ),
                  background: Stack(
                    children: [
                      const Positioned(
                          left: 0, top: 0, child: Text("good morning")),
                      Positioned(
                        child: SizedBox(
                          height: 220,
                          width: Get.width * 1.5,
                          child: Image.network(
                            widget.community["imageurl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 10,
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  Text(
                                    "${widget
                                        .community["name"]} Photography",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return AddPostInCommunity(
                                                  community: widget
                                                      .community["name"],
                                                );
                                              }));
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),),
              );
            }),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(textPosts[index]["post_id"]));

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
                    ', ' + DateFormat.jm().format(dateTime);
                return textPosts[index]["type"] == "text"
                    ? Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10),
                  child: Column(
                    children: [
                      const Gap(10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 0.8),
                                borderRadius:
                                BorderRadius.circular(80)),
                            child: textPosts[index][
                            "creator_profile_picture"] ==
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
                                textPosts[index][
                                "creator_profile_picture"],
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
                                      textPosts[index]
                                      ["creator_name"],
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight:
                                          FontWeight.w800,
                                          color: isDark(
                                              context)
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Text(
                                      "@${textPosts[index]["creator_username"]}",
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
                        margin: EdgeInsets.only(
                            left: Get.width * 0.17),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                      textPosts[index]["text"],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: isDark(
                                              context)
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
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (!textPosts[index]["likers"]
                                        .contains(FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid)) {
                                      setState(() {
                                        textPosts[index]
                                        ["likes"]++;
                                        textPosts[index]
                                        ["likers"]
                                            .add(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid);
                                      });
                                      await FirebaseTable()
                                          .communitiesTable
                                          .doc(
                                          widget
                                              .community["name"])
                                          .collection("Posts")
                                          .doc(
                                          textPosts[index]
                                          ["post_id"])
                                          .update({
                                        "likes":
                                        FieldValue.increment(
                                            1),
                                        "likers": FieldValue
                                            .arrayUnion([
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid
                                        ])
                                      });
                                    } else {
                                      setState(() {
                                        textPosts[index]["likes"]--;

                                        textPosts[index]
                                        ["likers"]
                                            .remove(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                      });
                                      await FirebaseTable()
                                          .communitiesTable
                                          .doc(
                                          widget
                                              .community["name"])
                                          .collection("Posts")
                                          .doc(
                                          textPosts[index]
                                          ["post_id"])
                                          .update({
                                        "likes":
                                        FieldValue.increment(
                                            -1),
                                        "likers": FieldValue
                                            .arrayRemove([
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid
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
                                        if (!
                                        textPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          setState(() {
                                            textPosts[
                                            index]
                                            ["likers"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);

                                            textPosts[
                                            index]
                                            ["likes"]++;
                                          });
                                          await FirebaseTable()
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
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
                                        textPosts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "happy"
                                            :
                                        textPosts[
                                        index]
                                        ["sad"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "sad"
                                            :
                                        textPosts[index]
                                        ["fear"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "fear"
                                            : textPosts[index]["anger"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "anger"
                                            : textPosts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "disgust"
                                            : textPosts[index]["surprise"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "surprise"
                                            : "none";
                                        if (userReaction ==
                                            "none") {
                                          await FirebaseTable()
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
                                              index]
                                              ["post_id"])
                                              .update({
                                            "${reaction!
                                                .value}":
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
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
                                              index]
                                              ["post_id"])
                                              .update({
                                            "${reaction!
                                                .value}":
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
                                        if (!
                                        textPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            textPosts[
                                            index]
                                            ["sad"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            textPosts[
                                            index]
                                            ["fear"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            textPosts[
                                            index]
                                            ["disgust"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            textPosts[
                                            index]
                                            ["anger"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            textPosts[
                                            index]
                                            ["surprise"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          }
                                        } else {
                                          userReaction ==
                                              "happy"
                                              ?
                                          textPosts[
                                          index]
                                          ["happy"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "sad"
                                              ?
                                          textPosts[
                                          index]
                                          ["sad"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "disgust"
                                              ?
                                          textPosts[
                                          index]
                                          ["disgust"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "anger"
                                              ? textPosts[index]["anger"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "fear"
                                              ? textPosts[index]["fear"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : textPosts[index]["surprise"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            textPosts[
                                            index]
                                            ["sad"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            textPosts[
                                            index]
                                            ["fear"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            textPosts[
                                            index]
                                            ["disgust"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            textPosts[
                                            index]
                                            ["anger"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            textPosts[
                                            index]
                                            ["surprise"]
                                                .add(
                                                FirebaseAuth
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
                                          icon: !
                                          textPosts[
                                          index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? const Icon(
                                              Icons
                                                  .thumb_up)
                                              :
                                          textPosts[
                                          index]
                                          ["happy"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[0].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[1].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[2].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[3].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["disgust"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[4].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : Text(
                                              emojis[5].code,
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
                                InkWell(onTap: () {
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
                                          const EdgeInsets
                                              .all(10),
                                          width: Get.width,
                                          child: Column(
                                              mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[0]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["happy"]
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
                                                      emojis[1]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["sad"]
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
                                                      emojis[2]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["fear"]
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
                                                      emojis[3]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["anger"]
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
                                                      emojis[4]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["disgust"]
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
                                                      emojis[5]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["surprise"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                              ]),
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
                                      textPosts[index]["likes"]
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
                                              return CommentsScreen(
                                                postId:
                                                textPosts[index]
                                                ["post_id"],
                                                description:
                                                textPosts[index]
                                                ["text"],
                                              );
                                            },
                                          ));
                                    },
                                    child: const Icon(Icons
                                        .chat_bubble_outline)),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  textPosts[index]["comments"]
                                      .toString(),
                                ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                InkWell(onTap: () {
                                  shareText(context,
                                      textPosts[index]["text"]);
                                },
                                    child: const Icon(Icons
                                        .replay_outlined)),

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
                )
                    : textPosts[index]["type"] == "image"
                    ? Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                Border.all(
                                    color: Colors.grey,
                                    width: 0.8),
                                borderRadius: BorderRadius
                                    .circular(
                                    80)),
                            child:
                            textPosts[index]["creator_profile_picture"] ==
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
                                textPosts[index]
                                ["creator_profile_picture"],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.02,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      textPosts[index]["creator_name"],
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight
                                              .w800,
                                          color: isDark(
                                              context)
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Text(
                                      "@${textPosts[index]["creator_username"]}",
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
                        margin: EdgeInsets.only(
                            left: Get.width * 0.17),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(textPosts[index]["text"],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight
                                            .w500)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius
                                      .circular(
                                      10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius
                                    .circular(10),
                                child: Image.network(
                                  textPosts[index]["imageurl"],
                                  // Replace with the path to your image
                                  fit: BoxFit
                                      .fill, // Use BoxFit.fill to force the image to fill the container
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (!
                                    textPosts[index]["likers"]
                                        .contains(FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid)) {
                                      setState(() {
                                        textPosts[index]
                                        ["likes"]++;

                                        textPosts[index]
                                        ["likers"]
                                            .add(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid);
                                      });
                                      await FirebaseTable()
                                          .communitiesTable
                                          .doc(
                                          widget
                                              .community["name"])
                                          .collection("Posts")
                                          .doc(
                                          textPosts[index]
                                          ["post_id"])
                                          .update({
                                        "likes":
                                        FieldValue.increment(
                                            1),
                                        "likers": FieldValue
                                            .arrayUnion([
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid
                                        ])
                                      });
                                    } else {
                                      setState(() {
                                        textPosts[index]
                                        ["likes"]--;

                                        textPosts[index]
                                        ["likers"]
                                            .remove(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid);
                                      });
                                      await FirebaseTable()
                                          .communitiesTable
                                          .doc(
                                          widget
                                              .community["name"])
                                          .collection("Posts")
                                          .doc(
                                          textPosts[index]
                                          ["post_id"])
                                          .update({
                                        "likes":
                                        FieldValue.increment(
                                            -1),
                                        "likers": FieldValue
                                            .arrayRemove([
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid
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
                                        if (!
                                        textPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          setState(() {
                                            textPosts[
                                            index]
                                            ["likers"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);

                                            textPosts[
                                            index]
                                            ["likes"]++;
                                          });
                                          await FirebaseTable()
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
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
                                        textPosts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "happy"
                                            :
                                        textPosts[
                                        index]
                                        ["sad"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "sad"
                                            :
                                        textPosts[index]
                                        ["fear"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "fear"
                                            : textPosts[index]["anger"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "anger"
                                            : textPosts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "disgust"
                                            : textPosts[index]["surprise"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "surprise"
                                            : "none";
                                        if (userReaction ==
                                            "none") {
                                          await FirebaseTable()
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
                                              index]
                                              ["post_id"])
                                              .update({
                                            "${reaction!
                                                .value}":
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
                                              .communitiesTable
                                              .doc(
                                              widget
                                                  .community["name"])
                                              .collection(
                                              "Posts")
                                              .doc(
                                              textPosts[
                                              index]
                                              ["post_id"])
                                              .update({
                                            "${reaction!
                                                .value}":
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
                                        if (!
                                        textPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            textPosts[
                                            index]
                                            ["sad"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            textPosts[
                                            index]
                                            ["fear"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            textPosts[
                                            index]
                                            ["disgust"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            textPosts[
                                            index]
                                            ["anger"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            textPosts[
                                            index]
                                            ["surprise"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          }
                                        } else {
                                          userReaction ==
                                              "happy"
                                              ?
                                          textPosts[
                                          index]
                                          ["happy"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "sad"
                                              ?
                                          textPosts[
                                          index]
                                          ["sad"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "disgust"
                                              ?
                                          textPosts[
                                          index]
                                          ["disgust"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "anger"
                                              ? textPosts[index]["anger"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "fear"
                                              ? textPosts[index]["fear"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : textPosts[index]["surprise"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "sad") {
                                            textPosts[
                                            index]
                                            ["sad"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "fear") {
                                            textPosts[
                                            index]
                                            ["fear"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "disgust") {
                                            textPosts[
                                            index]
                                            ["disgust"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "anger") {
                                            textPosts[
                                            index]
                                            ["anger"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                          } else if (reaction
                                              .value ==
                                              "surprise") {
                                            textPosts[
                                            index]
                                            ["surprise"]
                                                .add(
                                                FirebaseAuth
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
                                          icon: !
                                          textPosts[
                                          index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? const Icon(
                                              Icons
                                                  .thumb_up)
                                              :
                                          textPosts[
                                          index]
                                          ["happy"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[0].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[1].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[2].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[3].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : textPosts[index]["disgust"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[4].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : Text(
                                              emojis[5].code,
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
                                InkWell(onTap: () {
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
                                          const EdgeInsets
                                              .all(10),
                                          width: Get.width,
                                          child: Column(
                                              mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[0]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                        ["happy"]
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
                                                      emojis[1]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                            .sad
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
                                                      emojis[2]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                            .fear
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
                                                      emojis[3]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                            .anger
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
                                                      emojis[4]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                            .disgust
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
                                                      emojis[5]
                                                          .code,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          22),
                                                    ),
                                                    Text(
                                                        textPosts[
                                                        index]
                                                            .surprise
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                              ]),
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
                                    textPosts[index]["likes"]
                                        .toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return CommentsScreen(
                                                  postId: textPosts[index]["post_id"],
                                                  description: textPosts[index]["text"],
                                                  imageurl:
                                                  textPosts[index]["imageurl"],
                                                );
                                              }));
                                    },
                                    child: const Icon(
                                        Icons
                                            .chat_bubble_outline)),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  textPosts[index]["comments"]
                                      .toString(),
                                ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                InkWell(onTap: () {
                                  shareImage(context,
                                      textPosts[index]["text"],
                                      textPosts[index]["imageurl"]);
                                },
                                    child: const Icon(Icons
                                        .replay_outlined)),
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
                )
                    : Container(margin: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 0.8),
                                borderRadius:
                                BorderRadius.circular(80)),
                            child: textPosts[index][
                            "creator_profile_picture"] ==
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
                                textPosts[index][
                                "creator_profile_picture"],
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
                                      textPosts[index]
                                      ["creator_name"],
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight:
                                          FontWeight.w800,
                                          color: isDark(
                                              context)
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Text(
                                      "@${textPosts[index]["creator_username"]}",
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
                      Container(margin: EdgeInsets.only(
                          left: Get.width * 0.14),
                        child: Column(
                          children: [

                            VideoCard(
                              videoUrl: textPosts[index]["imageurl"],
                              message: textPosts[index]["text"],),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets
                                  .symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (!textPosts[index]["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        setState(() {
                                          textPosts[index]
                                          ["likes"]++;
                                          textPosts[index]
                                          ["likers"]
                                              .add(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                        });
                                        await FirebaseTable()
                                            .communitiesTable
                                            .doc(
                                            widget
                                                .community["name"])
                                            .collection(
                                            "Posts")
                                            .doc(
                                            textPosts[index]
                                            ["post_id"])
                                            .update({
                                          "likes":
                                          FieldValue
                                              .increment(
                                              1),
                                          "likers": FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ])
                                        });
                                      } else {
                                        setState(() {
                                          textPosts[index]["likes"]--;

                                          textPosts[index]
                                          ["likers"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                        });
                                        await FirebaseTable()
                                            .communitiesTable
                                            .doc(
                                            widget
                                                .community["name"])
                                            .collection(
                                            "Posts")
                                            .doc(
                                            textPosts[index]
                                            ["post_id"])
                                            .update({
                                          "likes":
                                          FieldValue
                                              .increment(
                                              -1),
                                          "likers": FieldValue
                                              .arrayRemove([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
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
                                          if (!
                                          textPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            setState(() {
                                              textPosts[
                                              index]
                                              ["likers"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);

                                              textPosts[
                                              index]
                                              ["likes"]++;
                                            });
                                            await FirebaseTable()
                                                .communitiesTable
                                                .doc(
                                                widget
                                                    .community["name"])
                                                .collection(
                                                "Posts")
                                                .doc(
                                                textPosts[
                                                index]
                                                ["post_id"])
                                                .update({
                                              "likers": FieldValue
                                                  .arrayUnion(
                                                  [
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
                                                  ]),
                                              "likes": FieldValue
                                                  .increment(
                                                  1)
                                            });
                                          }

                                          var userReaction =
                                              "none";
                                          userReaction =
                                          textPosts[
                                          index]
                                          ["happy"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "happy"
                                              :
                                          textPosts[
                                          index]
                                          ["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "sad"
                                              :
                                          textPosts[index]
                                          ["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "fear"
                                              : textPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "anger"
                                              : textPosts[index]["disgust"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "disgust"
                                              : textPosts[index]["surprise"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "surprise"
                                              : "none";
                                          if (userReaction ==
                                              "none") {
                                            await FirebaseTable()
                                                .communitiesTable
                                                .doc(
                                                widget
                                                    .community["name"])
                                                .collection(
                                                "Posts")
                                                .doc(
                                                textPosts[
                                                index]
                                                ["post_id"])
                                                .update({
                                              "${reaction!
                                                  .value}":
                                              FieldValue
                                                  .arrayUnion(
                                                  [
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
                                                  ]),
                                            });
                                          } else {
                                            await FirebaseTable()
                                                .communitiesTable
                                                .doc(
                                                widget
                                                    .community["name"])
                                                .collection(
                                                "Posts")
                                                .doc(
                                                textPosts[
                                                index]
                                                ["post_id"])
                                                .update({
                                              "${reaction!
                                                  .value}":
                                              FieldValue
                                                  .arrayUnion(
                                                  [
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
                                                  ]),
                                              userReaction:
                                              FieldValue
                                                  .arrayRemove(
                                                  [
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
                                                  ])
                                            });
                                          }
                                          if (!
                                          textPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            if (reaction
                                                .value ==
                                                "happy") {
                                              textPosts[
                                              index]
                                              ["happy"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              textPosts[
                                              index]
                                              ["sad"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              textPosts[
                                              index]
                                              ["fear"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              textPosts[
                                              index]
                                              ["disgust"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              textPosts[
                                              index]
                                              ["anger"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              textPosts[
                                              index]
                                              ["surprise"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            }
                                          } else {
                                            userReaction ==
                                                "happy"
                                                ?
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "sad"
                                                ?
                                            textPosts[
                                            index]
                                            ["sad"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "disgust"
                                                ?
                                            textPosts[
                                            index]
                                            ["disgust"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "anger"
                                                ? textPosts[index]["anger"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "fear"
                                                ? textPosts[index]["fear"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : textPosts[index]["surprise"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                            if (reaction
                                                .value ==
                                                "happy") {
                                              textPosts[
                                              index]
                                              ["happy"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              textPosts[
                                              index]
                                              ["sad"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              textPosts[
                                              index]
                                              ["fear"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              textPosts[
                                              index]
                                              ["disgust"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              textPosts[
                                              index]
                                              ["anger"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              textPosts[
                                              index]
                                              ["surprise"]
                                                  .add(
                                                  FirebaseAuth
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
                                            icon: !
                                            textPosts[
                                            index]
                                            ["likers"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? const Icon(
                                                Icons
                                                    .thumb_up)
                                                :
                                            textPosts[
                                            index]
                                            ["happy"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? Text(
                                                emojis[0]
                                                    .code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : textPosts[index]["sad"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? Text(
                                                emojis[1]
                                                    .code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : textPosts[index]["fear"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? Text(
                                                emojis[2]
                                                    .code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : textPosts[index]["anger"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? Text(
                                                emojis[3]
                                                    .code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : textPosts[index]["disgust"]
                                                .contains(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                ? Text(
                                                emojis[4]
                                                    .code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : Text(
                                                emojis[5]
                                                    .code,
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
                                  InkWell(onTap: () {
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
                                            const EdgeInsets
                                                .all(10),
                                            width: Get.width,
                                            child: Column(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[0]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["happy"]
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
                                                        emojis[1]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["sad"]
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
                                                        emojis[2]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["fear"]
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
                                                        emojis[3]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["anger"]
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
                                                        emojis[4]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["disgust"]
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
                                                        emojis[5]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          textPosts[
                                                          index]
                                                          ["surprise"]
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                ]),
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
                                                  Navigator
                                                      .of(
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
                                        textPosts[index]["likes"]
                                            .toString()),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CommentsScreen(
                                                  postId:
                                                  textPosts[index]
                                                  ["post_id"],
                                                  description:
                                                  textPosts[index]
                                                  ["text"],
                                                );
                                              },
                                            ));
                                      },
                                      child: const Icon(Icons
                                          .chat_bubble_outline)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    textPosts[index]["comments"]
                                        .toString(),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  const Icon(
                                      Icons.replay_outlined),

                                ],
                              ),

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
              },
              childCount: textPosts.length,
            ),
          ),

        ],
      ),
    );
  }
}
