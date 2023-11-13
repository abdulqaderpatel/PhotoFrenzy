import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../authentication/login.dart';
import '../global/firebase_tables.dart';
import '../global/show_message.dart';
import '../global/theme_mode.dart';
import '../profiles/edit_user_profile.dart';
import '../user_posts/comments.dart';
import '../user_posts/image_posts_list.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  ProfileScreen({required this.id});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var isLoading = false;

  List<Map<String, dynamic>> textPosts = [];
  List<Map<String, dynamic>> imagePosts = [];

  void getPosts() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("type", isEqualTo: "text")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }
      textPosts = temp;
    temp=[];

   data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("type", isEqualTo: "image")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }
    imagePosts = temp;

print(textPosts);
print(imagePosts);

    setState(() {
      isLoading = false;
    });
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Gap(50),
            Text("Profile"),
            PopupMenuButton(
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const EditUserProfileScreen();
                                }));
                          });
                        },
                        child: const Text("Edit profile")),
                    PopupMenuItem(
                        onTap: () async {
                          showToast(message: "Logged out successfully");
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                          }
                        },
                        child: const Text("Logout"))
                  ];
                })
          ],
        ),
      ),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
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
                                                Gap(10),
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
                                                Gap(20),
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
                                                          Text("0",
                                                              style: TextStyle(
                                                                  fontSize: 19,
                                                                  color: isDark(
                                                                          context)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                          Text(
                                                            "Posts",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                      Gap(45),
                                                      Column(
                                                        children: [
                                                          Text("0",
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
                                                      Gap(45),
                                                      Column(
                                                        children: [
                                                          Text("0",
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
                                                Gap(20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      client["username"],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark(context)
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Gap(5),
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
                                                Gap(5),
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
                        tabs: [
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

                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // Build your text posts here
                            // ...
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 0.8),
                                          borderRadius:
                                          BorderRadius.circular(80)),
                                      child: textPosts[index]["creator_profile_picture"] == ""
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
                                          textPosts[index]["creator_profile_picture"],
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
                                          textPosts[index]["creator_name"],
                                          style:
                                          TextStyle(fontSize: 19,color: isDark(context)?Colors.white:Colors.black),
                                        ),
                                        Text(
                                          "@${textPosts[index]["creator_username"]}",
                                          style:
                                          TextStyle(fontSize: 17,color: isDark(context)?Colors.white:Colors.grey),
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
                                              textPosts[index]["text"],
                                              style:
                                              Theme.of(context).textTheme.bodyMedium,
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

                                              },
                                              child: Icon(textPosts[index]["creator_name"]=="fdsfds"

                                                  ? Icons.favorite_outline
                                                  : Icons.favorite)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                              "0"
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.1,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) {
                                                    return CommentsScreen();
                                                  },
                                                ));
                                              },
                                              child: Icon(Icons.chat_bubble_outline)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "0",
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
                            );
                          },
                          childCount: textPosts.length, // Replace with your actual post count
                        ),
                      ),
                    ],
                  ),

                  // Image Posts Tab
                  CustomScrollView(
                    slivers: [
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,

                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // Build your image posts here
                            // ...
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ImagePostsListScreen(imagePosts, index);
                                }));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 1.5, right: 1.5),
                                child: Image.network(
                                  imagePosts[index]
                                  ["imageurl"], // Replace with the path to your image
                                  fit: BoxFit
                                      .fill, // Use BoxFit.fill to force the image to fill the container
                                ),
                              ),
                            );
                          },
                          childCount: imagePosts.length, // Replace with your actual post count
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
