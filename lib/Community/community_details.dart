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
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/user_mention_text.dart';
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
  UserController userController=Get.put(UserController());

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
print("timepass");
    userController.communityPosts.value = temp;

    setState(() {
      isLoaded = false;
    });

    print(userController.communityPosts);
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
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                child: FlexibleSpaceBar(
                  title: isAppBarExpanded
                      ? const SizedBox()
                      : Container(padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget.community["name"]} Photography",
                          style:  TextStyle(
                              color: isDark(context)? Colors.white:Colors.black,
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

                                  Text(
                                    "${widget
                                        .community["name"]} Photography",
                                    style:  TextStyle(
                                        color:isDark(context)? Colors.white:Colors.black,
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
          Obx(()=>SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(userController.communityPosts[index]["post_id"]));

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
                return userController.communityPosts[index]["type"] == "text"
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
                            child: userController.communityPosts[index][
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
                                userController.communityPosts[index][
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
                                      userController.communityPosts[index]
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
                                      "@${userController.communityPosts[index]["creator_username"]}",
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
                                  child: UserMentionText(text:
                                      userController.communityPosts[index]["text"],
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
                                  onTap: () async {
                                    if (!userController.communityPosts[index]["likers"]
                                        .contains(FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid)) {
                                      setState(() {
                                        userController.communityPosts[index]
                                        ["likes"]++;
                                        userController.communityPosts[index]
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
                                          userController.communityPosts[index]
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
                                        userController.communityPosts[index]["likes"]--;

                                        userController.communityPosts[index]
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
                                          userController.communityPosts[index]
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
                                        userController.communityPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          setState(() {
                                            userController.communityPosts[
                                            index]
                                            ["likers"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);

                                            userController.communityPosts[
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
                                              userController.communityPosts[
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
                                        userController.communityPosts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "happy"
                                            :
                                        userController.communityPosts[
                                        index]
                                        ["sad"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "sad"
                                            :
                                        userController.communityPosts[index]
                                        ["fear"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "fear"
                                            : userController.communityPosts[index]["anger"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "anger"
                                            : userController.communityPosts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "disgust"
                                            : userController.communityPosts[index]["surprise"]
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                        userController.communityPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
                                          index]
                                          ["disgust"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "anger"
                                              ? userController.communityPosts[index]["anger"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "fear"
                                              ? userController.communityPosts[index]["fear"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userController.communityPosts[index]["surprise"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
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
                                              : userController.communityPosts[index]["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[1].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[2].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[3].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["disgust"]
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                      userController.communityPosts[index]["likes"]
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
                                              return CommentsScreen(comments: userController.textposts[index].comments,
                                                postId:
                                                userController.communityPosts[index]
                                                ["post_id"],
                                                description:
                                                userController.communityPosts[index]
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
                                  userController.communityPosts[index]["comments"]
                                      .toString(),
                                ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                InkWell(onTap: () {
                                  shareText(context,
                                      userController.communityPosts[index]["text"]);
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
                    : userController.communityPosts[index]["type"] == "image"
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
                            userController.communityPosts[index]["creator_profile_picture"] ==
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
                                userController.communityPosts[index]
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
                                      userController.communityPosts[index]["creator_name"],
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
                                      "@${userController.communityPosts[index]["creator_username"]}",
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
                                UserMentionText(text:userController.communityPosts[index]["text"],
                                    ),
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
                                  userController.communityPosts[index]["imageurl"],
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
                                    userController.communityPosts[index]["likers"]
                                        .contains(FirebaseAuth
                                        .instance
                                        .currentUser!
                                        .uid)) {
                                      setState(() {
                                        userController.communityPosts[index]
                                        ["likes"]++;

                                        userController.communityPosts[index]
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
                                          userController.communityPosts[index]
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
                                        userController.communityPosts[index]
                                        ["likes"]--;

                                        userController.communityPosts[index]
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
                                          userController.communityPosts[index]
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
                                        userController.communityPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          setState(() {
                                            userController.communityPosts[
                                            index]
                                            ["likers"]
                                                .add(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);

                                            userController.communityPosts[
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
                                              userController.communityPosts[
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
                                        userController.communityPosts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "happy"
                                            :
                                        userController.communityPosts[
                                        index]
                                        ["sad"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "sad"
                                            :
                                        userController.communityPosts[index]
                                        ["fear"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "fear"
                                            : userController.communityPosts[index]["anger"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "anger"
                                            : userController.communityPosts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                            ? "disgust"
                                            : userController.communityPosts[index]["surprise"]
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                        userController.communityPosts[index]
                                        ["likers"]
                                            .contains(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)) {
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
                                          index]
                                          ["disgust"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "anger"
                                              ? userController.communityPosts[index]["anger"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userReaction ==
                                              "fear"
                                              ? userController.communityPosts[index]["fear"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              : userController.communityPosts[index]["surprise"]
                                              .remove(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                          if (reaction
                                              .value ==
                                              "happy") {
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                          userController.communityPosts[
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
                                          userController.communityPosts[
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
                                              : userController.communityPosts[index]["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[1].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[2].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? Text(
                                              emojis[3].code,
                                              style: const TextStyle(
                                                  fontSize: 22))
                                              : userController.communityPosts[index]["disgust"]
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
                                                        index]["sad"]

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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                                        userController.communityPosts[
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
                                    userController.communityPosts[index]["likes"]
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
                                                return CommentsScreen(comments: userController.imageposts[index].comments,
                                                  postId: userController.communityPosts[index]["post_id"],
                                                  description: userController.communityPosts[index]["text"],
                                                  imageurl:
                                                  userController.communityPosts[index]["imageurl"],
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
                                  userController.communityPosts[index]["comments"]
                                      .toString(),
                                ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                InkWell(onTap: () {
                                  shareImage(context,
                                      userController.communityPosts[index]["text"],
                                      userController.communityPosts[index]["imageurl"]);
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
                            child: userController.communityPosts[index][
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
                                userController.communityPosts[index][
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
                                      userController.communityPosts[index]
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
                                      "@${userController.communityPosts[index]["creator_username"]}",
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
                              videoUrl: userController.communityPosts[index]["imageurl"],
                              message: userController.communityPosts[index]["text"],),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets
                                  .symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (!userController.communityPosts[index]["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        setState(() {
                                          userController.communityPosts[index]
                                          ["likes"]++;
                                          userController.communityPosts[index]
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
                                            userController.communityPosts[index]
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
                                          userController.communityPosts[index]["likes"]--;

                                          userController.communityPosts[index]
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
                                            userController.communityPosts[index]
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
                                          userController.communityPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            setState(() {
                                              userController.communityPosts[
                                              index]
                                              ["likers"]
                                                  .add(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid);

                                              userController.communityPosts[
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
                                                userController.communityPosts[
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
                                          userController.communityPosts[
                                          index]
                                          ["happy"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "happy"
                                              :
                                          userController.communityPosts[
                                          index]
                                          ["sad"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "sad"
                                              :
                                          userController.communityPosts[index]
                                          ["fear"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "fear"
                                              : userController.communityPosts[index]["anger"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "anger"
                                              : userController.communityPosts[index]["disgust"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                              ? "disgust"
                                              : userController.communityPosts[index]["surprise"]
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
                                                userController.communityPosts[
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
                                                userController.communityPosts[
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
                                          userController.communityPosts[index]
                                          ["likers"]
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            if (reaction
                                                .value ==
                                                "happy") {
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
                                            index]
                                            ["disgust"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "anger"
                                                ? userController.communityPosts[index]["anger"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userReaction ==
                                                "fear"
                                                ? userController.communityPosts[index]["fear"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                : userController.communityPosts[index]["surprise"]
                                                .remove(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                            if (reaction
                                                .value ==
                                                "happy") {
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                              userController.communityPosts[
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
                                            userController.communityPosts[
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
                                            userController.communityPosts[
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
                                                : userController.communityPosts[index]["sad"]
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
                                                : userController.communityPosts[index]["fear"]
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
                                                : userController.communityPosts[index]["anger"]
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
                                                : userController.communityPosts[index]["disgust"]
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
                                                          userController.communityPosts[
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
                                                          userController.communityPosts[
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
                                                          userController.communityPosts[
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
                                                          userController.communityPosts[
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
                                                          userController.communityPosts[
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
                                                          userController.communityPosts[
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
                                        userController.communityPosts[index]["likes"]
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
                                                return CommentsScreen(comments: userController.imageposts[index].comments,
                                                  postId:
                                                  userController.communityPosts[index]
                                                  ["post_id"],
                                                  description:
                                                  userController.communityPosts[index]
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
                                    userController.communityPosts[index]["comments"]
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
              childCount: userController.communityPosts.length,
            ),
          ),),

        ],
      ),
    );
  }
}
