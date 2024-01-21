import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/Community/add_post_in_community.dart';

class CommunityDetails extends StatefulWidget {
  final Map<String, dynamic> community;

  const CommunityDetails({required this.community, super.key});

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Stack(
              children: [
                const Positioned(left: 0, top: 0, child: Text("good morning")),
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
          ],
        ),
      )),
    );
  }
}
