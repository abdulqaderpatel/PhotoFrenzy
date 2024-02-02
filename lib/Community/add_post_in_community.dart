import 'dart:io';


import 'package:cached_video_player/cached_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:video_player/video_player.dart';

import '../global/firebase_tables.dart';

class AddPostInCommunity extends StatefulWidget {
  final String community;

  const AddPostInCommunity({required this.community, super.key});

  @override
  State<AddPostInCommunity> createState() => _AddPostInCommunityState();
}

class _AddPostInCommunityState extends State<AddPostInCommunity> {
  List<String> list = <String>["Text", "Image", "Video"];
  String dropdownValue = "Text";

  CachedVideoPlayerController? _controller;

  final textController = TextEditingController();
  File? postImage = File("");
  File? video;
  var buttonLoading = false;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future getImageFromGallery() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      setState(() {
        postImage = File(pickedImageFile.path);
      });
    }
  }

  Future getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        video = File(pickedFile.path);
        _controller = CachedVideoPlayerController.file(video!)
          ..initialize().then((value) {
            _controller!.play();
          });
      });
    }
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: buttonLoading
                    ? null
                    : () async {
                        List<Map<String, dynamic>> temp = [];
                        var data = await FirebaseTable()
                            .usersTable
                            .where("id",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get();

                        for (var element in data.docs) {
                          setState(() {
                            temp.add(element.data());
                          });
                        }

                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        setState(() {
                          buttonLoading = true;
                        });
                        if (dropdownValue == "Text") {
                          await FirebaseTable()
                              .communitiesTable
                              .doc(widget.community)
                              .collection("Posts")
                              .doc(id)
                              .set({
                            "creator_name": temp[0]["name"],
                            "creator_username": temp[0]["username"],
                            "creator_profile_picture": temp[0]
                                ["profile_picture"],
                            "post_id": id,
                            "creator_id":
                                FirebaseAuth.instance.currentUser!.uid,
                            "type": "text",
                            "text": textController.text,
                            "likes": 0,
                            "likers": [],
                            "comments": 0,
                            "happy": [],
                            "sad": [],
                            "anger": [],
                            "fear": [],
                            "disgust": [],
                            "surprise": [],
                          });
                        } else if (dropdownValue == "Image") {
                          Reference ref = FirebaseStorage.instance.ref(
                              "/${FirebaseAuth.instance.currentUser!.uid}/$id");
                          UploadTask uploadTask =
                              ref.putFile(postImage!.absolute);
                          Future.value(uploadTask).then((value) async {
                            var newUrl = await ref.getDownloadURL();
                            await FirebaseTable()
                                .communitiesTable
                                .doc(widget.community)
                                .collection("Posts")
                                .doc(id)
                                .set({
                              "creator_name": temp[0]["name"],
                              "creator_username": temp[0]["username"],
                              "creator_profile_picture": temp[0]
                                  ["profile_picture"],
                              "post_id": id,
                              "creator_id":
                                  FirebaseAuth.instance.currentUser!.uid,
                              "type": "image",
                              "text": textController.text,
                              "imageurl": newUrl.toString(),
                              "likes": 0,
                              "likers": [],
                              "comments": 0,
                              "happy": [],
                              "sad": [],
                              "anger": [],
                              "fear": [],
                              "disgust": [],
                              "surprise": [],
                            });
                          });
                        } else {
                          Reference ref = FirebaseStorage.instance.ref(
                              "/${FirebaseAuth.instance.currentUser!.uid}/$id");
                          UploadTask uploadTask =
                          ref.putFile(video!.absolute);
                          Future.value(uploadTask).then((value) async {
                            var newUrl = await ref.getDownloadURL();
                            await FirebaseTable()
                                .communitiesTable
                                .doc(widget.community)
                                .collection("Posts")
                                .doc(id)
                                .set({
                              "creator_name": temp[0]["name"],
                              "creator_username": temp[0]["username"],
                              "creator_profile_picture": temp[0]
                              ["profile_picture"],
                              "post_id": id,
                              "creator_id":
                              FirebaseAuth.instance.currentUser!.uid,
                              "type": "video",
                              "text": textController.text,
                              "imageurl": newUrl.toString(),
                              "likes": 0,
                              "likers": [],
                              "comments": 0,
                              "happy": [],
                              "sad": [],
                              "anger": [],
                              "fear": [],
                              "disgust": [],
                              "surprise": [],
                            });
                          });
                        }
                        showToast(message: "Post created successfully");
                        setState(() {
                          buttonLoading = false;
                        });
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: buttonLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        "Create Post",
                        style: GoogleFonts.lato(
                            letterSpacing: 0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            width: Get.width,
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).colorScheme.background,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                TextField(
                    maxLines: 5,
                    controller: textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write something here..",
                    )),
                dropdownValue == "Text"
                    ? Container()
                    : dropdownValue == "Image"
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            minWidth: Get.width,
                                            minHeight: Get.height * 0.4,
                                            maxHeight: Get.height * 0.5),
                                        margin: const EdgeInsets.only(top: 10),
                                        child: postImage!.path.isEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  getImageFromGallery();
                                                },
                                                child: const Center(
                                                  child: Icon(Icons.add),
                                                ),
                                              )
                                            : Image.file(
                                                postImage!,
                                                // Replace with the path to your image
                                                fit: BoxFit
                                                    .fill, // Use BoxFit.fill to force the image to fill the container
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 15,
                                        right: 10,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              postImage = File("");
                                            });
                                          },
                                          child: const Icon(
                                            Icons.highlight_remove,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : video != null
                            ? _controller!.value.isInitialized
                                ? Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio:
                                            _controller!.value.aspectRatio,
                                        child: CachedVideoPlayer(_controller!),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _controller!.value.isPlaying
                                                ? _controller!.pause()
                                                : _controller!.play();
                                            _controller!.setLooping(true);
                                          });
                                        },
                                        child: Icon(_controller!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                      )
                                    ],
                                  )
                                : Container()
                            : Container(
                                constraints: BoxConstraints(
                                    minWidth: Get.width,
                                    minHeight: Get.height * 0.4,
                                    maxHeight: Get.height * 0.5),
                                margin: const EdgeInsets.only(top: 10),
                                child:  InkWell(
                                        onTap: () {
                                          getVideoFromGallery();
                                        },
                                        child: const Center(
                                          child: Icon(Icons.add),
                                        ),
                                      )

                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
