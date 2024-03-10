import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/Follow/random_user_followers.dart';
import 'package:photofrenzy/Follow/random_user_following.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:photofrenzy/individual_chat.dart';
import 'package:photofrenzy/main_pages/profile.dart';
import 'package:photofrenzy/user_posts/random_image_posts_list.dart';
import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../models/image_post.dart';
import '../user_posts/comments.dart';

class RandomUserProfileScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const RandomUserProfileScreen({super.key, required this.data});

  @override
  RandomUserProfileScreenState createState() =>
      RandomUserProfileScreenState();
}

class RandomUserProfileScreenState extends State<RandomUserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var isLoading = false;

  List<Map<String, dynamic>> textPosts = [];
  List<ImagePost> imagePosts = [];

  var postsCount = 0;

  void getPosts() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: widget.data["id"])
        .count()
        .get()
        .then(
          (res) => postsCount = res.count,
      onError: (e) => showErrorDialog(context, "Error completing: $e"),
    );
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: widget.data["id"])
        .where("type", isEqualTo: "text")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }
    textPosts = temp;
    temp = [];

    data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: widget.data["id"])
        .where("type", isEqualTo: "image")
        .get();

    for (var element in data.docs) {
      setState(() {
        imagePosts.add(ImagePost(
            element.data()["creator_id"],
            element.data()["creator_name"],
            element.data()["creator_profile_picture"],
            element.data()["creator_username"],
            element.data()["imageurl"],
            element.data()["post_id"],
            element.data()["text"],
            element.data()["type"],
            element.data()["likes"],
            element.data()["likers"],
            element.data()["comments"],
            element.data()["happy"],
            element.data()["sad"],
            element.data()["fear"],
            element.data()["anger"],
            element.data()["disgust"],
            element.data()["surprise"]));
      });
    }

    setState(() {
      isLoading = false;
    });
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
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).cardColor,
        title: const Text("Profile"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(backgroundColor: Theme.of(context).cardColor,
                expandedHeight: 400.0,
                floating: false,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseTable()
                            .usersTable
                            .where("id", isEqualTo: widget.data["id"])
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Container> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: Get.width * 0.025,
                                            right: Get.width * 0.025,
                                            top: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey,
                                                          width: 0.8),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          80)),
                                                  child: client[
                                                  "profile_picture"] ==
                                                      ""
                                                      ? const CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    backgroundImage:
                                                    AssetImage(
                                                      "assets/images/profile_picture.png",
                                                    ),
                                                  )
                                                      : CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    backgroundImage:
                                                    NetworkImage(
                                                      client[
                                                      "profile_picture"],
                                                    ),
                                                  ),
                                                ),
                                                Gap(Get.width * 0.1),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                            postsCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                19,
                                                                color: isDark(
                                                                    context)
                                                                    ? Colors
                                                                    .white
                                                                    : Colors
                                                                    .black)),
                                                        Text(
                                                          "Posts",
                                                          style: Theme
                                                              .of(
                                                              context)
                                                              .textTheme
                                                              .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                    const Gap(40),
                                                    InkWell(onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) {
                                                                return RandomUserFollowers(
                                                                    id: client["id"]);
                                                              }));
                                                    },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              client["followers"]
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  19,
                                                                  color: isDark(
                                                                      context)
                                                                      ? Colors
                                                                      .white
                                                                      : Colors
                                                                      .black)),
                                                          Text(
                                                            "Followers",
                                                            style: Theme
                                                                .of(
                                                                context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Gap(40),
                                                    InkWell(onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) {
                                                                return RandomUserFollowing(
                                                                    id: client["id"]);
                                                              }));
                                                    },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              client["following"]
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  19,
                                                                  color: isDark(
                                                                      context)
                                                                      ? Colors
                                                                      .white
                                                                      : Colors
                                                                      .black)),
                                                          Text(
                                                            "Following",
                                                            style: Theme
                                                                .of(
                                                                context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Gap(15),
                                            Row(
                                              children: [
                                                AutoSizeText(
                                                  client["name"], maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      color: isDark(
                                                          context)
                                                          ? Colors
                                                          .white
                                                          : Colors
                                                          .black),
                                                ),
                                              ],
                                            ),
                                            const Gap(20),
                                            Row(
                                              children: [
                                                client["followers"].contains(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                    ? SizedBox(
                                                  width: Get.width *
                                                      0.46,
                                                  height:
                                                  Get.height *
                                                      0.05,
                                                  child:
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor: Colors
                                                          .white,
                                                      backgroundColor: Colors
                                                          .red,
                                                      minimumSize: Size(
                                                          Get.width,
                                                          40),

                                                      textStyle: const TextStyle(
                                                          fontSize:
                                                          15,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                      // Background color
                                                    ),
                                                    onPressed:
                                                        () {
                                                      FirebaseTable()
                                                          .usersTable
                                                          .doc(FirebaseAuth
                                                          .instance
                                                          .currentUser!.uid)
                                                          .update({
                                                        "following":
                                                        FieldValue
                                                            .arrayRemove([
                                                          client["id"],
                                                        ])
                                                      });
                                                      FirebaseTable()
                                                          .usersTable
                                                          .doc(client["id"])
                                                          .update({
                                                        "followers":
                                                        FieldValue
                                                            .arrayRemove([
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid
                                                        ])
                                                      });
                                                    },
                                                    child: const Text(
                                                        "Unfollow"),),
                                                )
                                                    : SizedBox(
                                                  height:
                                                  Get.height *
                                                      0.05,
                                                  width: Get.width *
                                                      0.46,
                                                  child:
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors
                                                            .white,
                                                        backgroundColor: Colors
                                                            .green,
                                                        minimumSize: Size(
                                                            Get.width,
                                                            40),

                                                        textStyle: const TextStyle(
                                                            fontSize:
                                                            15,
                                                            fontWeight:
                                                            FontWeight.w600),
                                                        // Background color
                                                      ),
                                                      onPressed:
                                                          () async {
                                                        FirebaseTable()
                                                            .usersTable
                                                            .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!.uid)
                                                            .update({
                                                          "following":
                                                          FieldValue.arrayUnion(
                                                              [
                                                                client["id"]
                                                              ])
                                                        });
                                                        FirebaseTable()
                                                            .usersTable
                                                            .doc(client["id"])
                                                            .update({
                                                          "followers":
                                                          FieldValue.arrayUnion(
                                                              [
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                              ])
                                                        });
                                                      },
                                                      child: const Text(
                                                          "Follow")),
                                                ),
                                                Gap(Get.width * 0.03),
                                                SizedBox(
                                                  height:
                                                  Get.height * 0.05,
                                                  width: Get.width * 0.46,
                                                  child: ElevatedButton(
                                                      style:
                                                      ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors
                                                            .white,
                                                        backgroundColor: Colors
                                                            .blue,
                                                        textStyle: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      ),
                                                      onPressed: () {
                                                        String chatId;
                                                        if (FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid
                                                            .compareTo(
                                                            widget
                                                                .data["id"]) ==
                                                            1) {
                                                          chatId = widget
                                                              .data[
                                                          "id"] +
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid;
                                                        } else {
                                                          chatId = FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid +
                                                              widget.data[
                                                              "id"];
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return IndividualChatScreen(
                                                                    combinedId:
                                                                    chatId,
                                                                    receiverInfo:
                                                                    widget
                                                                        .data,
                                                                  );
                                                                }));
                                                      },
                                                      child: const Text(
                                                          "Message")),
                                                ),
                                              ],
                                            ),
                                            const Gap(20),
                                            Row(
                                              children: [
                                                Text(
                                                  client["username"],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: isDark(
                                                          context)
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: SizedBox(
                                                    height:
                                                    Get.height * 0.14,
                                                    child: Text(
                                                      client["bio"],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: isDark(
                                                              context)
                                                              ? Colors
                                                              .white
                                                              : Colors
                                                              .black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              clientWidgets.add(clientWidget);
                            }
                          } else {
                            final clientWidget = Container(
                              color: const Color(0xff111111),
                            );
                            clientWidgets.add(clientWidget);
                          }

                          return Column(
                            children: clientWidgets,
                          );
                        })),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.text_fields),
                      ),
                      Tab(
                        icon: Icon(Icons.image),
                      )
                    ],
                  ),
                ),
                pinned: false,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              textPosts.isEmpty?SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.01,
                    ),

                    SvgPicture.asset(
                        "assets/images/no_text_posts.svg",
                        height: Get.height * 0.2),
                    SizedBox(height: Get.height*0.015,),
                    Text("No text posts",style: Theme.of(context).textTheme.displayLarge,)
                  ],
                ),
              ):
              CustomScrollView(
                slivers: [

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
                                                  color: isDark(context)
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
                                                  .postsTable
                                                  .doc(
                                                  textPosts[index]
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
                                                textPosts[index]["likes"]--;

                                                textPosts[index]
                                                ["likers"]
                                                    .remove(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid);
                                              });
                                              await FirebaseTable()
                                                  .postsTable
                                                  .doc(textPosts[index]
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
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);

                                                    textPosts[
                                                    index]
                                                    ["likes"]++;
                                                  });
                                                  await FirebaseTable()
                                                      .postsTable
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
                                                    .contains(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                    ? "happy"
                                                    :
                                                textPosts[
                                                index]
                                                ["sad"]
                                                    .contains(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid)
                                                    ? "sad"
                                                    :
                                                textPosts[index]
                                                ["fear"]
                                                    .contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    ? "fear"
                                                    : textPosts[index]["anger"]
                                                    .contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    ? "anger"
                                                    : textPosts[index]["disgust"]
                                                    .contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    ? "disgust"
                                                    : textPosts[index]["surprise"]
                                                    .contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    ? "surprise"
                                                    : "none";
                                                if (userReaction ==
                                                    "none") {
                                                  await FirebaseTable()
                                                      .postsTable
                                                      .doc(
                                                      textPosts[
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
                                                      .doc(
                                                      textPosts[
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
                                                  if (reaction.value ==
                                                      "happy") {
                                                    textPosts[
                                                    index]
                                                    ["happy"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "sad") {
                                                    textPosts[
                                                    index]
                                                    ["sad"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "fear") {
                                                    textPosts[
                                                    index]
                                                    ["fear"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "disgust") {
                                                    textPosts[
                                                    index]
                                                    ["disgust"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "anger") {
                                                    textPosts[
                                                    index]
                                                    ["anger"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "surprise") {
                                                    textPosts[
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
                                                      ?
                                                  textPosts[
                                                  index]
                                                  ["happy"]
                                                      .remove(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                                      : userReaction ==
                                                      "sad"
                                                      ?
                                                  textPosts[
                                                  index]
                                                  ["sad"]
                                                      .remove(FirebaseAuth
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
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      : userReaction == "anger"
                                                      ? textPosts[index]["anger"]
                                                      .remove(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      : userReaction == "fear"
                                                      ? textPosts[index]["fear"]
                                                      .remove(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      : textPosts[index]["surprise"]
                                                      .remove(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid);
                                                  if (reaction.value ==
                                                      "happy") {
                                                    textPosts[
                                                    index]
                                                    ["happy"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "sad") {
                                                    textPosts[
                                                    index]
                                                    ["sad"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "fear") {
                                                    textPosts[
                                                    index]
                                                    ["fear"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "disgust") {
                                                    textPosts[
                                                    index]
                                                    ["disgust"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "anger") {
                                                    textPosts[
                                                    index]
                                                    ["anger"]
                                                        .add(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);
                                                  } else if (reaction
                                                      .value ==
                                                      "surprise") {
                                                    textPosts[
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
                                                  icon: !
                                                  textPosts[
                                                  index]
                                                  ["likers"]
                                                      .contains(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                                      ? const Icon(Icons
                                                      .thumb_up)
                                                      :
                                                  textPosts[
                                                  index]
                                                  ["happy"]
                                                      .contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      ? Text(emojis[0].code,
                                                      style: const TextStyle(
                                                          fontSize: 22))
                                                      : textPosts[index]["sad"]
                                                      .contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      ? Text(emojis[1].code,
                                                      style: const TextStyle(
                                                          fontSize: 22))
                                                      : textPosts[index]["fear"]
                                                      .contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      ? Text(emojis[2].code,
                                                      style: const TextStyle(
                                                          fontSize: 22))
                                                      : textPosts[index]["anger"]
                                                      .contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      ? Text(emojis[3].code,
                                                      style: const TextStyle(
                                                          fontSize: 22))
                                                      : textPosts[index]["disgust"]
                                                      .contains(
                                                      FirebaseAuth.instance
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
                                                            Text(textPosts[
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
                                                            Text(textPosts[
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
                                                            Text(textPosts[
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
                                                            Text(textPosts[
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
                                                            Text(textPosts[
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
                                                            Text(textPosts[
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
                                          child: Text(textPosts[index]["likes"]
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
                                                      return CommentsScreen(comments: 0,
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
                                            child: const Icon(
                                                Icons.replay_outlined)),

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
                      },
                      childCount: textPosts
                          .length, // Replace with your actual post count
                    ),
                  ),
                ],
              ),

              imagePosts.isEmpty?SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.01,
                    ),

                    SvgPicture.asset(
                        "assets/images/no_image_posts.svg",
                        height: Get.height * 0.2),
                    SizedBox(height: Get.height*0.015,),
                    Text("No image posts",style: Theme.of(context).textTheme.displayLarge,)
                  ],
                ),
              ):
              CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        // Build your image posts here
                        // ...
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  //TODO
                                  return RandomImagePostsListScreen(
                                      imagePosts, index);
                                }));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 1.5, right: 1.5),
                            child: Image.network(
                              imagePosts[index].imageurl!,
                              // Replace with the path to your image
                              fit: BoxFit
                                  .fill, // Use BoxFit.fill to force the image to fill the container
                            ),
                          ),
                        );
                      },
                      childCount: imagePosts
                          .length, // Replace with your actual post count
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
