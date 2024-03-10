import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/main_pages/profile.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/user_posts/comments.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../global/theme_mode.dart';

class RandomImagePostsListScreen extends StatefulWidget {
  final List<ImagePost> images;
  final int count;

  const RandomImagePostsListScreen(this.images, this.count, {super.key});

  @override
  State<RandomImagePostsListScreen> createState() =>
      _RandomImagePostsListScreenState();
}

class _RandomImagePostsListScreenState
    extends State<RandomImagePostsListScreen> {
  ItemScrollController itemScrollController = ItemScrollController();

  var parser = EmojiParser();

  var a = EmojiParser().get("coffee");

  var reactions = [
    Reaction<String>(
      value: 'happy',
      icon: Text(
        Emoji("happy", "😊").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'sad',
      icon: Text(
        Emoji("sad", "😔").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'fear',
      icon: Text(
        Emoji("fear", "😨").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'anger',
      icon: Text(
        Emoji("anger", "😠").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'disgust',
      icon: Text(
        Emoji("disgust", "🤢").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'surprise',
      icon: Text(
        Emoji("surprise", "😲").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
  ];

  var emojis = [
    Emoji("happy", "😊"),
    Emoji("sad", "😔"),
    Emoji("fear", "😨"),
    Emoji("anger", "😠"),
    Emoji("disgust", "🤢"),
    Emoji("surprise", "😲")
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Posts"),
      ),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                initialScrollIndex: widget.count,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.images[index].post_id!));
                  DateTime now = DateTime.now();

                  String formattedTime = '';

                  // Check if the date is today
                  if (dateTime.year == now.year &&
                      dateTime.month == now.month &&
                      dateTime.day == now.day) {
                    formattedTime = 'Today';
                  } else {
                    // Format the date
                    formattedTime = DateFormat('MMM d').format(dateTime);
                  }

                  // Format time (e.g., 3pm)
                  formattedTime += ', ' + DateFormat.jm().format(dateTime);

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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        widget.images[index].creator_name!,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800,
                                            color: isDark(context)
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      Text(
                                        "@${widget.images[index]
                                            .creator_username}",
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.grey),
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
                                  Text(widget.images[index].text!,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: isDark(context)
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: Get.width,
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
                                      if (!
                                      widget.images[index].likers
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)) {
                                        setState(() {
                                          widget.images[index]
                                              .likes++;

                                          widget.images[index]
                                              .likers
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(
                                            widget.images[index]
                                                .post_id)
                                            .update({
                                          "likes":
                                          FieldValue.increment(
                                              1),
                                          "likers": FieldValue
                                              .arrayUnion([
                                            FirebaseAuth.instance
                                                .currentUser!.uid
                                          ])
                                        });
                                      } else {
                                        setState(() {
                                          widget.images[index]
                                              .likes--;

                                          widget.images[index]
                                              .likers
                                              .remove(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(
                                            widget.images[index]
                                                .post_id)
                                            .update({
                                          "likes":
                                          FieldValue.increment(
                                              -1),
                                          "likers": FieldValue
                                              .arrayRemove([
                                            FirebaseAuth.instance
                                                .currentUser!.uid
                                          ])
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      height: 33,
                                      child:
                                      ReactionButton<String>(
                                        toggle: false,
                                        direction:
                                        ReactionsBoxAlignment
                                            .rtl,
                                        onReactionChanged:
                                            (Reaction<String>?
                                        reaction) async {
                                          if (!
                                          widget.images[index]
                                              .likers
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            setState(() {
                                              widget.images[
                                              index]
                                                  .likers
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);

                                              widget.images[
                                              index]
                                                  .likes++;
                                            });
                                            await FirebaseTable()
                                                .postsTable
                                                .doc(
                                                widget.images[
                                                index]
                                                    .post_id)
                                                .update({
                                              "likers": FieldValue
                                                  .arrayUnion([
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid
                                              ]),
                                              "likes": FieldValue
                                                  .increment(1)
                                            });
                                          }

                                          var userReaction =
                                              "none";
                                          userReaction =
                                          widget.images[
                                          index]
                                              .happy
                                              .contains(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              ? "happy"
                                              :
                                          widget.images[
                                          index]
                                              .sad
                                              .contains(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)
                                              ? "sad"
                                              :
                                          widget.images[index]
                                              .fear
                                              .contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "fear"
                                              : widget.images[index].anger
                                              .contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "anger"
                                              : widget.images[index].disgust
                                              .contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "disgust"
                                              : widget.images[index].surprise
                                              .contains(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid)
                                              ? "surprise"
                                              : "none";
                                          if (userReaction ==
                                              "none") {
                                            await FirebaseTable()
                                                .postsTable
                                                .doc(
                                                widget.images[
                                                index]
                                                    .post_id)
                                                .update({
                                              "${reaction!.value}":
                                              FieldValue
                                                  .arrayUnion([
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid
                                              ]),
                                            });
                                          } else {
                                            await FirebaseTable()
                                                .postsTable
                                                .doc(
                                                widget.images[
                                                index]
                                                    .post_id)
                                                .update({
                                              "${reaction!.value}":
                                              FieldValue
                                                  .arrayUnion([
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid
                                              ]),
                                              userReaction:
                                              FieldValue
                                                  .arrayRemove([
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid
                                              ])
                                            });
                                          }
                                          if (!
                                          widget.images[index]
                                              .likers
                                              .contains(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)) {
                                            if (reaction.value ==
                                                "happy") {
                                              widget.images[
                                              index]
                                                  .happy
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              widget.images[
                                              index]
                                                  .sad
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              widget.images[
                                              index]
                                                  .fear
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              widget.images[
                                              index]
                                                  .disgust
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              widget.images[
                                              index]
                                                  .anger
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              widget.images[
                                              index]
                                                  .surprise
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            }
                                          } else {
                                            userReaction ==
                                                "happy"
                                                ?
                                            widget.images[
                                            index]
                                                .happy
                                                .remove(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                : userReaction ==
                                                "sad"
                                                ?
                                            widget.images[
                                            index]
                                                .sad
                                                .remove(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                : userReaction ==
                                                "disgust"
                                                ?
                                            widget.images[
                                            index]
                                                .disgust
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : userReaction == "anger"
                                                ? widget.images[index].anger
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : userReaction == "fear"
                                                ? widget.images[index].fear
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                : widget.images[index].surprise
                                                .remove(FirebaseAuth.instance
                                                .currentUser!.uid);
                                            if (reaction.value ==
                                                "happy") {
                                              widget.images[
                                              index]
                                                  .happy
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "sad") {
                                              widget.images[
                                              index]
                                                  .sad
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "fear") {
                                              widget.images[
                                              index]
                                                  .fear
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "disgust") {
                                              widget.images[
                                              index]
                                                  .disgust
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "anger") {
                                              widget.images[
                                              index]
                                                  .anger
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            } else if (reaction
                                                .value ==
                                                "surprise") {
                                              widget.images[
                                              index]
                                                  .surprise
                                                  .add(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid);
                                            }
                                          }
                                        },
                                        reactions: reactions,
                                        placeholder: Reaction<
                                            String>(
                                            value: null,
                                            icon: !
                                            widget.images[
                                            index]
                                                .likers
                                                .contains(FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid)
                                                ? const Icon(Icons
                                                .thumb_up)
                                                :
                                            widget.images[
                                            index]
                                                .happy
                                                .contains(
                                                FirebaseAuth.instance
                                                    .currentUser!.uid)
                                                ? Text(emojis[0].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : widget.images[index].sad
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[1].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : widget.images[index].fear
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[2].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : widget.images[index].anger
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[3].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : widget.images[index].disgust
                                                .contains(FirebaseAuth.instance
                                                .currentUser!.uid)
                                                ? Text(emojis[4].code,
                                                style: const TextStyle(
                                                    fontSize: 22))
                                                : Text(emojis[5].code,
                                                style: const TextStyle(
                                                    fontSize: 22))),
                                        boxColor: Colors.black
                                            .withOpacity(0.5),
                                        boxRadius: 10,
                                        itemsSpacing: 0,
                                        itemSize:
                                        const Size(35, 35),
                                      ),

                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  InkWell(onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder:
                                          (BuildContext context) {
                                        return AlertDialog(
                                          title: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  'Reactions',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                )
                                              ]),
                                          content: Container(
                                            margin:
                                            const EdgeInsets
                                                .all(10),
                                            width: Get.width,
                                            child: Column(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[0]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .happy
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[1]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .sad
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[2]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .fear
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[3]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .anger
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[4]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .disgust
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        emojis[5]
                                                            .code,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            22),
                                                      ),
                                                      Text(
                                                          widget.images[
                                                          index]
                                                              .surprise
                                                              .length
                                                              .toString())
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                          actions: <Widget>[
                                            Center(
                                              child: TextButton(
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .red,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(
                                                      context)
                                                      .pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                    child: Text(
                                      widget.images[index].likes.toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return CommentsScreen(comments: userController.imageposts[index].comments,
                                                    postId: widget.images[index]
                                                        .post_id!,
                                                    description: widget
                                                        .images[index].text!,
                                                    imageurl:
                                                    widget.images[index]
                                                        .imageurl!,
                                                  );
                                                }));
                                      },
                                      child: const Icon(
                                          Icons.chat_bubble_outline)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    widget.images[index].comments.toString(),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  InkWell(onTap: () {
                                    shareImage(
                                        context, widget.images[index].text!,
                                        widget.images[index].imageurl!);
                                  }, child: const Icon(Icons.replay_outlined)),

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
