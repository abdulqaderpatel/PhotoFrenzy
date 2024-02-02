import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/models/text_post.dart';
import 'package:share_plus/share_plus.dart';
import '../authentication/login.dart';
import '../competition/user_competition_details.dart';
import '../controllers/user_controller.dart';
import '../global/firebase_tables.dart';
import '../global/show_message.dart';
import '../global/theme_mode.dart';
import '../models/image_post.dart';
import '../profiles/edit_user_profile.dart';
import '../user_posts/comments.dart';
import '../user_posts/image_posts_list.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  const ProfileScreen({super.key, required this.id});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

final UserController userController = Get.put(UserController());

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  var isLoading = false;

  void getPosts() async {
    userController.textposts.clear();
    userController.imageposts.clear();
    setState(() {
      isLoading = true;
    });

    await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .count()
        .get()
        .then(
          (res) => userController.userPostCount.value = res.count,
          onError: (e) =>
              showErrorDialog(context, "Error completing the process"),
        );

    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("type", isEqualTo: "text")
        .get();

    for (var element in data.docs) {
      setState(() {
        userController.textposts.add(TextPost(
            element.data()["creator_id"],
            element.data()["creator_name"],
            element.data()["creator_profile_picture"],
            element.data()["creator_username"],
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
        temp.add(element.data());
      });
    }

    temp = [];

    data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("type", isEqualTo: "image")
        .get();

    for (var element in data.docs) {
      setState(() {
        userController.imageposts.add(ImagePost(
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

  void shareText(BuildContext context, String text) async {
    await Share.share(
      text,
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: Get.width,
              color: Colors.blue,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'More Info',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.to(const EditUserProfileScreen());
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark(context) ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(const UserCompetitionDetails());
              },
              child: Text(
                "Competitions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark(context) ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                showToast(message: "Logged out successfully");
                await FirebaseAuth.instance.signOut();
                userController.isLoggedOut.value=true;
                if (context.mounted) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                }
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    actions: [Container()],
                    expandedHeight: 400.0,
                    floating: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                        background: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseTable()
                                .usersTable
                                .where("id",
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 0.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80)),
                                                  child:
                                                      client["profile_picture"] ==
                                                              ""
                                                          ? const CircleAvatar(
                                                              radius: 40,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                "assets/images/profile_picture.png",
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 40,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                client[
                                                                    "profile_picture"],
                                                              ),
                                                            ),
                                                ),
                                                const Gap(10),
                                                Text(
                                                  client["name"],
                                                  style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isDark(context)
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                const Gap(20),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Get.width * 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Obx(
                                                            () => Text(
                                                                userController
                                                                    .userPostCount
                                                                    .value
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
                                                          ),
                                                          Text(
                                                            "Posts",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                      const Gap(45),
                                                      Column(
                                                        children: [
                                                          Text(
                                                              client["followers"]
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 19,
                                                                  color: isDark(
                                                                          context)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                          Text(
                                                            "Followers",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                      const Gap(45),
                                                      Column(
                                                        children: [
                                                          Text(
                                                              client["following"]
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 19,
                                                                  color: isDark(
                                                                          context)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                          Text(
                                                            "Following",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Gap(20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      client["username"],
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark(context)
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
                                                                  ? Colors.white
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
                  // Text Posts Tab
                  CustomScrollView(
                    slivers: [
                      Obx(
                        () => SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      userController
                                          .textposts[index].post_id!));

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

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                          child: userController.textposts[index]
                                                      .creator_profile_picture ==
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
                                                    userController
                                                        .textposts[index]
                                                        .creator_profile_picture!,
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
                                                    userController
                                                        .textposts[index]
                                                        .creator_name!,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: isDark(context)
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                  Text(
                                                    "@${userController.textposts[index].creator_username}",
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
                                                    userController
                                                        .textposts[index].text!,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (!userController
                                                      .textposts[index].likers
                                                      .contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)) {
                                                    setState(() {
                                                      userController
                                                          .textposts[index]
                                                          .likes++;
                                                      userController
                                                          .textposts[index]
                                                          .likers
                                                          .add(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);
                                                    });
                                                    await FirebaseTable()
                                                        .postsTable
                                                        .doc(userController
                                                            .textposts[index]
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
                                                          .textposts[index]
                                                          .likes--;
                                                      userController
                                                          .textposts[index]
                                                          .likers
                                                          .remove(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);
                                                    });
                                                    await FirebaseTable()
                                                        .postsTable
                                                        .doc(userController
                                                            .textposts[index]
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
                                                            .textposts[index]
                                                            .likers
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)) {
                                                          setState(() {
                                                            userController
                                                                .textposts[
                                                                    index]
                                                                .likers
                                                                .add(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid);
                                                            userController
                                                                .textposts[
                                                                    index]
                                                                .likes++;
                                                          });
                                                          await FirebaseTable()
                                                              .postsTable
                                                              .doc(userController
                                                                  .textposts[
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
                                                                .textposts[
                                                                    index]
                                                                .happy
                                                                .contains(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                            ? "happy"
                                                            : userController
                                                                    .textposts[
                                                                        index]
                                                                    .sad
                                                                    .contains(FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                                ? "sad"
                                                                : userController
                                                                        .textposts[index]
                                                                        .fear
                                                                        .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                    ? "fear"
                                                                    : userController.textposts[index].anger.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                        ? "anger"
                                                                        : userController.textposts[index].disgust.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                            ? "disgust"
                                                                            : userController.textposts[index].surprise.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                                ? "surprise"
                                                                                : "none";
                                                        if (userReaction ==
                                                            "none") {
                                                          await FirebaseTable()
                                                              .postsTable
                                                              .doc(userController
                                                                  .textposts[
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
                                                                  .textposts[
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
                                                            .textposts[index]
                                                            .likers
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)) {
                                                          if (reaction.value ==
                                                              "happy") {
                                                            userController
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                  .textposts[
                                                                      index]
                                                                  .happy
                                                                  .remove(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                              : userReaction ==
                                                                      "sad"
                                                                  ? userController
                                                                      .textposts[
                                                                          index]
                                                                      .sad
                                                                      .remove(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                  : userReaction ==
                                                                          "disgust"
                                                                      ? userController
                                                                          .textposts[
                                                                              index]
                                                                          .disgust
                                                                          .remove(FirebaseAuth.instance.currentUser!.uid)
                                                                      : userReaction == "anger"
                                                                          ? userController.textposts[index].anger.remove(FirebaseAuth.instance.currentUser!.uid)
                                                                          : userReaction == "fear"
                                                                              ? userController.textposts[index].fear.remove(FirebaseAuth.instance.currentUser!.uid)
                                                                              : userController.textposts[index].surprise.remove(FirebaseAuth.instance.currentUser!.uid);
                                                          if (reaction.value ==
                                                              "happy") {
                                                            userController
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                .textposts[
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
                                                                  .textposts[
                                                                      index]
                                                                  .likers
                                                                  .contains(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                              ? const Icon(Icons
                                                                  .thumb_up)
                                                              : userController
                                                                      .textposts[
                                                                          index]
                                                                      .happy
                                                                      .contains(
                                                                          FirebaseAuth.instance.currentUser!.uid)
                                                                  ? Text(emojis[0].code, style: const TextStyle(fontSize: 22))
                                                                  : userController.textposts[index].sad.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                      ? Text(emojis[1].code, style: const TextStyle(fontSize: 22))
                                                                      : userController.textposts[index].fear.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                          ? Text(emojis[2].code, style: const TextStyle(fontSize: 22))
                                                                          : userController.textposts[index].anger.contains(FirebaseAuth.instance.currentUser!.uid)
                                                                              ? Text(emojis[3].code, style: const TextStyle(fontSize: 22))
                                                                              : userController.textposts[index].disgust.contains(FirebaseAuth.instance.currentUser!.uid)
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
                                                                    Text(userController
                                                                        .textposts[
                                                                            index]
                                                                        .happy
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
                                                                    Text(userController
                                                                        .textposts[
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
                                                                    Text(userController
                                                                        .textposts[
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
                                                                    Text(userController
                                                                        .textposts[
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
                                                                    Text(userController
                                                                        .textposts[
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
                                                                    Text(userController
                                                                        .textposts[
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
                                                child: Text(userController
                                                    .textposts[index].likes
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
                                                          postId: userController
                                                              .textposts[index]
                                                              .post_id!,
                                                          description:
                                                              userController
                                                                  .textposts[
                                                                      index]
                                                                  .text!,
                                                        );
                                                      },
                                                    ));
                                                  },
                                                  child: const Icon(Icons
                                                      .chat_bubble_outline)),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Obx(
                                                () => Text(
                                                  userController
                                                      .textposts[index].comments
                                                      .toString(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.1,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    shareText(
                                                        context,
                                                        userController
                                                            .textposts[index]
                                                            .text!);
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
                            childCount: userController.textposts
                                .length, // Replace with your actual post count
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Image Posts Tab
                  CustomScrollView(
                    slivers: [
                      Obx(
                        () => SliverGrid(
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
                                    return ImagePostsListScreen(
                                        userController.imageposts, index);
                                  }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 1.5, right: 1.5),
                                  child: Image.network(
                                    userController.imageposts[index].imageurl!,
                                    // Replace with the path to your image
                                    fit: BoxFit
                                        .fill, // Use BoxFit.fill to force the image to fill the container
                                  ),
                                ),
                              );
                            },
                            childCount: userController.imageposts
                                .length, // Replace with your actual post count
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
