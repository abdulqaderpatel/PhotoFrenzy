import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/user_posts/comments.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
                        Container(
                            width: Get.width * 0.79,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.images[index].creator_name!,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  "@${widget.images[index].creator_username}",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )),
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
                                widget.images[index].text!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
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
