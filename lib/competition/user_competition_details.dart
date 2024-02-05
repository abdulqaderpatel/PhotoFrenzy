import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/competition/user_competition_participation_details.dart';

import '../global/firebase_tables.dart';

class UserCompetitionDetails extends StatefulWidget {
  const UserCompetitionDetails({super.key});

  @override
  State<UserCompetitionDetails> createState() => _UserCompetitionDetailsState();
}

class _UserCompetitionDetailsState extends State<UserCompetitionDetails> {
  var textPosts = [];
  var isLoaded = false;

  getData() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .competitionSubmissionsTable
        .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    textPosts = temp;
    for (int i = 0; i < textPosts.length; i++) {
      if (DateTime.now().isBefore(DateTime.parse(textPosts[i]["end_time"]))) {
        textPosts.remove(textPosts[i]);
      }
    }

    setState(() {
      isLoaded = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Competitions"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: textPosts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserCompetitionParticipationDetails(
                            competitionSubmission: textPosts[index]);
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          height: Get.height * 0.13,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  textPosts[index]["competition_image"],
                                ),
                                fit: BoxFit.cover),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textPosts[index]["competition_name"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
