import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/authentication/login.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:photofrenzy/user_posts/image_posts.dart';
import 'package:photofrenzy/user_posts/text_posts.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../profiles/edit_user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(vsync: this, length: 2);
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseTable()
                    .usersTable
                    .where("id",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Container> clientWidgets = [];
                  if (snapshot.hasData) {
                    final clients = snapshot.data?.docs;
                    for (var client in clients!) {
                      final clientWidget = Container(height: Get.height*1.35,
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
                                              color: Colors.grey, width: 0.8),
                                          borderRadius:
                                              BorderRadius.circular(80)),
                                      child: client["profile_picture"] == ""
                                          ? const CircleAvatar(
                                              radius: 40,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                "assets/images/profile_picture.png",
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 40,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(
                                                client["profile_picture"],
                                              ),
                                            ),
                                    ),
                                    Gap(10),
                                    Text(
                                      client["name"],
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                          color: isDark(context)
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Gap(20),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text("0",
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      color: isDark(context)
                                                          ? Colors.white
                                                          : Colors.black)),
                                              Text(
                                                "Posts",
                                                style: Theme.of(context)
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
                                                      color: isDark(context)
                                                          ? Colors.white
                                                          : Colors.black)),
                                              Text(
                                                "Followers",
                                                style: Theme.of(context)
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
                                                      color: isDark(context)
                                                          ? Colors.white
                                                          : Colors.black)),
                                              Text(
                                                "Following",
                                                style: Theme.of(context)
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
                                              fontWeight: FontWeight.bold,
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
                                            height: Get.height * 0.13,
                                            child: Text(
                                              client["bio"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(10),
                                    Container(
                                      height: 50,
                                      child: TabBar(
                                          controller: tabController,
                                          tabs: [
                                            Icon(Icons.text_format,color: isDark(context)?Colors.white:Colors.black,),
                                            Icon(Icons.image,color:isDark(context)?Colors.white:Colors.black,),
                                          ]),
                                    ),
                                   Container(height:Get.height*0.80,
                                     child: TabBarView(
                                     controller: tabController,
                                     children: const [
                                       TextPostsScreen(),
                                       ImagePostsScreen(),
                                     ]),
                                   )

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
                }),
          ),
        ],
      ),
    );
  }
}
