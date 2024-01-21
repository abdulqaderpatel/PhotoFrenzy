import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/Community/community_details.dart';
import 'package:video_player/video_player.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';

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
        title: const Text(
          "Explore Communities",
        ),
        centerTitle: true,
      ),
      body: isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                child: Column(
                  children: items.mapIndexed<Widget>((index,community) {
                    return InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CommunityDetails(community: items[index],);
                      }));
                    },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community["imageurl"]),
                        ),
                        title: Text(
                          "${community["name"]} Photography",
                          style: TextStyle(
                              color:
                                  isDark(context) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
