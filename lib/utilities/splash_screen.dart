// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';

import 'package:http/http.dart' as http;
import 'package:social_media/controllers/userController.dart';

import '../../../controllers/authController.dart';
import '../../../controllers/mainController.dart';
import 'comment_replies.dart';

class PostComments extends StatefulWidget {
  final String postId;
  final int index;
  const PostComments({required this.postId, required this.index});

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());
  bool isLoading = false;
  final commentController = TextEditingController();

  List comments = [];
  List commentLikes = [];
  List isCommentLikedByUser = [];

  List replies = [];
  List replyLikes = [];
  List isReplyLikedByUser = [];

  void getComments() async {
    print(widget.postId);
    setState(() {
      isLoading = true;
    });

    mainController.commentRepliesCount = [].obs;

    http.Response res = await get("$url/comments/${widget.postId}");
    print(res.body);

    comments = jsonDecode(res.body);
    print(comments);
    for (var element in comments) {
      http.Response res = await get("$url/likes/comment/${element["id"]}");
      commentLikes.add(res.body);
      http.Response isLikedByUserRes = await get(
          "$url/likes/comment/likedByUser/${authController.userId.value}/${element["id"]}");
      isCommentLikedByUser.add(isLikedByUserRes.body);
      http.Response repliesCountRes =
      await get("$url/replies/count/${element["id"]}");

      mainController.commentRepliesCount.add(repliesCountRes.body);
    }

    setState(() {
      isLoading = false;
    });
  }

  void likeComment(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/comment",
        body: jsonEncode({
          "userId": authController.userId.value,
          "commentId": comments[index]["id"]
        }),
        success: () {});

    http.Response res =
    await get("$url/likes/comment/${comments[index]["id"]}");
    http.Response likedByUserRes = await get(
        "$url/likes/comment/likedByUser/${authController.userId.value}/${comments[index]["id"]}");
    setState(() {
      commentLikes[index] = res.body;
      isCommentLikedByUser[index] = likedByUserRes.body;
    });
  }

  void dislikeComment(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/comment/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "commentId": comments[index]["id"]
        }),
        success: () {});

    http.Response res =
    await get("$url/likes/comment/${comments[index]["id"]}");
    http.Response likedByUserRes = await get(
        "$url/likes/comment/likedByUser/${authController.userId.value}/${comments[index]["id"]}");
    setState(() {
      commentLikes[index] = res.body;
      isCommentLikedByUser[index] = likedByUserRes.body;
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Comments"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: Get.width * 0.025,
                right: Get.width * 0.025),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: comments[index]["user"]["picture"] ==
                                  null
                                  ? const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/profile_picture.png"))
                                  : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      comments[index]["user"]
                                      ["picture"])),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${comments[index]["user"]["username"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${comments[index]["description"].toString()}",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (isCommentLikedByUser[index] ==
                                          "false") {
                                        likeComment(index);
                                      } else {
                                        dislikeComment(index);
                                      }
                                    },
                                    child: Icon(
                                        isCommentLikedByUser[index] == "false"
                                            ? Icons.favorite_outline
                                            : Icons.favorite),
                                  ),
                                  Text(commentLikes[index])
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return CommentReplies(
                                          postId: widget.postId,
                                          commentId: comments[index]["id"],
                                          index: index);
                                    }));
                              },
                              child: Obx(
                                    () => Text(
                                  " View replies (${mainController.commentRepliesCount[index]})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        );
                      }),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                            hintText: "Enter comment.."),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                        onTap: () async {
                          if (commentController.text.isNotEmpty) {
                            await post(
                                endpoint: "$url/comments/",
                                body: jsonEncode({
                                  "description": commentController.text,
                                  "userId": authController.userId.value,
                                  "postId": widget.postId
                                }),
                                success: () {});

                            http.Response res =
                            await get("$url/comments/${widget.postId}");

                            comments = [];
                            commentLikes = [];
                            isCommentLikedByUser = [];

                            comments = jsonDecode(res.body);
                            for (var element in comments) {
                              http.Response res = await get(
                                  "$url/likes/comment/${element["id"]}");
                              commentLikes.add(res.body);
                              http.Response isLikedByUserRes = await get(
                                  "$url/likes/comment/likedByUser/${authController.userId.value}/${element["id"]}");
                              isCommentLikedByUser.add(isLikedByUserRes.body);
                              http.Response repliesCountRes = await get(
                                  "$url/replies/count/${element["id"]}");

                              mainController.commentRepliesCount.insert(0, 0);
                            }

                            http.Response commentCountResponse = await get(
                                "$url/comments/count/${widget.postId}");
                            mainController.postCommentsCount[widget.index] =
                                commentCountResponse.body;

                            setState(() {});
                          }
                          commentController.text = "";
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Icon(Icons.send)),
                  ],
                )
              ],
            ),
          )),
    );
  }
}