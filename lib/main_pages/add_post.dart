import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/models/text_post.dart';
import '../global/firebase_tables.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final textController = TextEditingController();
  File? postImage = File("");
  var buttonLoading = false;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        postImage = File(pickedFile.path);
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
            InkWell(
              onTap: () {
                getImageGallery();
              },
              child: const Icon(
                Icons.image,
                size: 28,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: buttonLoading
                    ? null
                    : () async {
                  if(textController.text.isEmpty)
                    {
                      showErrorDialog(context, "Post cannot be empty. Write something!!");
                      return;
                    }
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

                        UserController userController =
                            Get.put(UserController());
                        if (postImage!.path.isEmpty) {
                          await FirebaseTable().postsTable.doc(id).set({
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
                          userController.userPostCount.value++;
                          showToast(message: "Post created successfully");
                          userController.textposts.add(
                            TextPost(
                              FirebaseAuth.instance.currentUser!.uid,
                              FirebaseAuth.instance.currentUser!.displayName,
                              temp[0]["profile_picture"],
                              temp[0]["username"],
                              id,
                              textController.text,
                              "text",
                              0,
                              [],
                              0,
                              [],
                              [],
                              [],
                              [],
                              [],
                              [],
                            ),
                          );
                          setState(() {
                            buttonLoading = false;
                          });
                        } else {
                          Reference ref = FirebaseStorage.instance.ref(
                              "/${FirebaseAuth.instance.currentUser!.uid}/$id");
                          UploadTask uploadTask =
                              ref.putFile(postImage!.absolute);
                          Future.value(uploadTask).then(
                            (value) async {
                              var newUrl = await ref.getDownloadURL();
                              await FirebaseTable().postsTable.doc(id).set({
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
                              userController.userPostCount.value++;
                              showToast(message: "Post created successfully");
                              userController.imageposts.add(ImagePost(
                                FirebaseAuth.instance.currentUser!.uid,
                                FirebaseAuth.instance.currentUser!.displayName,
                                temp[0]["profile_picture"],
                                temp[0]["username"],
                                newUrl.toString(),
                                id,
                                "image",
                                "text",
                                0,
                                [],
                                0,
                                [],
                                [],
                                [],
                                [],
                                [],
                                [],
                              ));
                              setState(
                                () {
                                  buttonLoading = false;
                                },
                              );
                            },
                          );
                        }
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              top: 10,
              left: Get.width * 0.025,
              right: Get.width * 0.025,
              bottom: 15),
          child: postImage!.path.isEmpty
              ? Column(
                  children: [
                    TextField(
                        maxLines: 5,
                        controller: textController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write something here..",
                        )),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                          maxLines: 6,
                          controller: textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write something here..",
                          )),
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              constraints: BoxConstraints(
                                  minWidth: Get.width,
                                  minHeight: Get.height * 0.4,
                                  maxHeight: Get.height * 0.5),
                              margin: const EdgeInsets.only(top: 10),
                              child: Image.file(
                                postImage!, // Replace with the path to your image
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
                ),
        ),
      ),
    );
  }
}
