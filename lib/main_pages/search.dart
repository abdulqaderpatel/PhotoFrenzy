import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';
import '../profiles/random_user_profile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String title = "";
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Container(
          height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      title = value.toString();
                    });
                  },
                  style:  TextStyle(color:isDark(context)?Colors.white: Colors.black),
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1, //<-- SEE HERE
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                      top: 2,
                      left: 5,
                    ),
                    errorStyle: const TextStyle(fontSize: 0),
                    hintStyle:  TextStyle(
                        color: isDark(context)?Colors.white:Colors.black, fontWeight: FontWeight.w400),
                    hintText: "Search",
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: Get.height * 0.8,
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseTable()
                              .usersTable
                              .where("id",
                                  isNotEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = title.isEmpty
                                    ? Container()
                                    : client["username"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(title.toLowerCase())
                                        ? Container(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return RandomUserProfileScreen(
                                                      data: {
                                                        "profile_picture": client[
                                                            "profile_picture"],
                                                        "id": client["id"],
                                                        "name": client["name"],
                                                        "username":
                                                            client["username"],
                                                        "followers":
                                                            client["followers"],
                                                        "following":
                                                            client["following"],
                                                        "bio": client["bio"],
                                                        "email":
                                                            client["email"],
                                                        "phone_number": client[
                                                            "phone_number"],
                                                      },
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Card(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  color:
                                                       isDark(context)?Color(0xff1B1212):Color(0xffEDEADE),
                                                  child: ListTile(
                                                    leading:
                                                        client["profile_picture"] ==
                                                                ""
                                                            ? const CircleAvatar(
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        "assets/images/profile_picture.png"),
                                                              )
                                                            : CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        client[
                                                                            "profile_picture"]),
                                                              ),
                                                    title: Text(
                                                      client["name"],
                                                      style: TextStyle(
                                                          color: isDark(context)?Colors.white:Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    subtitle: Text(
                                                      client["username"],
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )),
                                            ),
                                          )
                                        : Container();
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
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
