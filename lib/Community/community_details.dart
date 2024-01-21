import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/Community/add_post_in_community.dart';
import 'package:photofrenzy/components/chat/posts/video.dart';

import '../global/firebase_tables.dart';

class CommunityDetails extends StatefulWidget {
  final Map<String, dynamic> community;

  const CommunityDetails({required this.community, super.key});

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  var items = [];
  var isLoaded = false;

  getData() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .communitiesTable
        .doc(widget.community["name"])
        .collection("Posts")
        .get();

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
      body: isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const Positioned(
                          left: 0, top: 0, child: Text("good morning")),
                      Positioned(
                        child: SizedBox(
                          height: 220,
                          width: Get.width * 1.5,
                          child: Image.network(
                            widget.community["imageurl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 10,
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  Text(
                                    "${widget.community["name"]} Photography",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return AddPostInCommunity(
                                          community: widget.community["name"],
                                        );
                                      }));
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: Get.height * 0.6,
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return items[index]["type"] == "text"
                              ? Text("text")
                              : items[index]["type"] == "image"
                                  ? Text("image")
                                  : VideoCard(
                                      videoUrl: items[index]["imageurl"]);
                        }),
                  )
                ],
              ),
            )),
    );
  }
}
