import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../global/firebase_tables.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  var communities = [
    "Portrait Photography",
    "Landscape Photography",
    " Macro Photography",
    "Street Photography",
    "Astro Photography",
    "Fashion Photography",
    "Sports Photography",
    "Food Photography",
    "Travel Photography",
    "Experimental Photography"
  ];

  var commun = [
    "Portrait",
    "Landscape",
    " Macro",
    "Street",
    "Astro",
    "Fashion",
    "Sports",
    "Food",
    "Travel",
    "Experimental"
  ];

  var items = [];
  var isLoaded = false;

  getData() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable().communitiesTable.get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;

    setState(() {
      isLoaded = false;
    });

    print(items);
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
        title: Text(
          "Explore Communities",
        ),
        centerTitle: true,
      ),
      body: isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                child: Column(
                  children: items.map<Widget>((community) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community["imageurl"]),
                      ),
                      title: Text("${community["name"]} Photography"),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
