import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photofrenzy/competition/individual_competition.dart';

import '../global/firebase_tables.dart';
import '../profiles/random_user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  style: const TextStyle(color: Colors.white),
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xff352D3C),
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
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                    hintText: "Search",
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: Get.height * 0.8,
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseTable().competitionsTable.snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = Container(
                                  height: 200,
                                  width: 200,
                                  color: Colors.blueGrey,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return IndividualCompetitionsScreen(
                                            id: client["id"]);
                                      }));
                                    },
                                    child: Center(
                                      child: Text(client["title"]),
                                    ),
                                  ),
                                );
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
