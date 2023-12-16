import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/user_posts/comments.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../global/theme_mode.dart';

class ImagePostsListScreen extends StatefulWidget {
  final List<ImagePost> images;
  final int count;

  const ImagePostsListScreen(this.images, this.count, {super.key});

  @override
  State<ImagePostsListScreen> createState() => _ImagePostsListScreenState();
}

class _ImagePostsListScreenState extends State<ImagePostsListScreen> {
  UserController userController = Get.put(UserController());
  ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Your Posts"),),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(
            top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
        child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            initialScrollIndex: widget.count,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {

              DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(
                  userController
                      .imageposts[index].post_id!));
              DateTime now = DateTime.now();

              String formattedTime = '';

              // Check if the date is today
              if (dateTime.year == now.year &&
                  dateTime.month == now.month &&
                  dateTime.day == now.day) {
                formattedTime = 'Today';
              } else {
                // Format the date
                formattedTime =
                    DateFormat('MMM d').format(dateTime);
              }

              // Format time (e.g., 3pm)
              formattedTime +=
                  ', ' + DateFormat.jm().format(dateTime);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.8),
                              borderRadius: BorderRadius.circular(80)),
                          child:
                              widget.images[index].creator_profile_picture == ""
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
                                        widget.images[index]
                                            .creator_profile_picture!,
                                      ),
                                    ),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userController
                                        .imageposts[index]
                                        .creator_name!,
                                    style: TextStyle(
                                        fontSize: 19,fontWeight: FontWeight.w800,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "@${userController.imageposts[index].creator_username}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(formattedTime)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  userController
                                      .imageposts[index].text!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isDark(context)
                                          ? Colors.white
                                          : Colors.black,fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.images[index].imageurl!,
                                // Replace with the path to your image
                                fit: BoxFit
                                    .fill, // Use BoxFit.fill to force the image to fill the container
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (!widget.images[index].likers.contains(
                                      FirebaseAuth.instance.currentUser!.uid)) {
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(widget.images[index].post_id)
                                        .update({
                                      "likes": FieldValue.increment(1),
                                      "likers": FieldValue.arrayUnion([
                                        FirebaseAuth.instance.currentUser!.uid
                                      ])
                                    });
                                    setState(() {
                                      widget.images[index].likes++;
                                      widget.images[index].likers.add(
                                          FirebaseAuth
                                              .instance.currentUser!.uid);
                                    });
                                  } else {
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(widget.images[index].post_id)
                                        .update({
                                      "likes": FieldValue.increment(-1),
                                      "likers": FieldValue.arrayRemove([
                                        FirebaseAuth.instance.currentUser!.uid
                                      ])
                                    });
                                    setState(() {
                                      widget.images[index].likes--;
                                      widget.images[index].likers.remove(
                                          FirebaseAuth
                                              .instance.currentUser!.uid);
                                    });
                                  }
                                },
                                child: Icon(widget.images[index].likers
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                widget.images[index].likes.toString(),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommentsScreen(
                                        postId: widget.images[index].post_id!,
                                        description: widget.images[index].text!,
                                        imageurl:
                                            widget.images[index].imageurl!,
                                      );
                                    }));
                                  },
                                  child: const Icon(Icons.chat_bubble_outline)),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                userController.imageposts[index].comments
                                    .toString(),
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
                ),
              );
            }),
      )),
    );
  }
}
