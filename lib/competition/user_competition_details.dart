import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        .competitionSubmissionsTable.where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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


  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
