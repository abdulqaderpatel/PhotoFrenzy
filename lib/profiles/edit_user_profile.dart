import 'dart:io';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/global/show_message.dart';

import '../global/firebase_tables.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final usernameController = TextEditingController();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneNumberController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? profileImage;

  final picker = ImagePicker();

  bool buttonLoader = false;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  void incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;
    });
    nameController.text = items[0]["name"];
    usernameController.text = items[0]["username"];
    emailController.text = items[0]["email"];
    phoneNumberController.text = items[0]["phone_number"].toString();

    setState(() {
      isLoaded = true;
    });
  }

  Future<bool> checkIfUsernameIsUnique(String username) async {

    var userData = await FirebaseTable()
        .usersTable
        .where('username', isEqualTo: username)
        .get();

    List<Map<String, dynamic>> adminTemp = [];
    List<Map<String, dynamic>> userTemp = [];


    for (var element in userData.docs) {
      setState(() {
        userTemp.add(element.data());
      });
    }

    if (userTemp.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? SafeArea(
        child: Container(color: const Color(0xff404354),
          height: Get.height,

          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [


                  Container(padding: const EdgeInsets.all(15),width: Get.width,color: const Color(0xff373A49),
                    child: Column(
                      children:[ const Text(
                        "Edit Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 25),
                      ),
                        InkWell(
                          onTap: () {
                            getImageGallery();
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(top: 45, bottom: 30),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(70),

                            ),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: profileImage != null
                                  ? CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: FileImage(
                                  profileImage!,
                                ),
                              )
                                  : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  items[0]["profile_picture"],
                                ),
                              ),
                            ),
                          ),
                        ),],
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  TextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(),
                  const SizedBox(
                    height: 90,
                  ),

                  SizedBox(
                      width: Get.width * 0.8,
                      child: ElevatedButton(
                     child: Text("submit"),

                        onPressed: () async {
                          setState(() {
                            buttonLoader = true;
                          });
                          if (nameController.text.isEmpty) {
                            showToast(message: "Name cannot be empty",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (usernameController.text.isEmpty) {
                            showToast(message: "Username cannot be empty",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (phoneNumberController.text.isEmpty) {
                            showToast(message: "Phone number cannot be empty",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                              .hasMatch(nameController.text)) {
                            showToast(message: "Please enter a valid name",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                              .hasMatch(usernameController.text)) {
                            showToast(message: "Please enter a valid username",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (!await checkIfUsernameIsUnique(
                              usernameController.text) &&
                              items[0]["username"] !=
                                  usernameController.text) {
                            showToast(message: "Username has been already taken",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else if (phoneNumberController.text.length !=
                              10 ||
                              phoneNumberController.text.contains(".") ||
                              phoneNumberController.text.contains(",")) {
                            showToast(message: "Invalid phone number",error: true);
                            setState(() {
                              buttonLoader = false;
                            });
                          } else {
                            if (profileImage == null) {
                              await FirebaseTable()
                                  .usersTable
                                  .doc(FirebaseAuth
                                  .instance.currentUser!.uid)
                                  .update({
                                "username": usernameController.text,
                                "name": nameController.text,
                                "phone_number": phoneNumberController.text
                              });
                              showToast(message: "Profile updated successfully");
                              setState(() {
                                buttonLoader = false;
                              });
                              if(context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              Reference ref = FirebaseStorage.instance.ref(
                                  "/${FirebaseAuth.instance.currentUser!.uid}/profile_picture");
                              UploadTask uploadTask =
                              ref.putFile(profileImage!.absolute);
                              Future.value(uploadTask)
                                  .then((value) async {
                                var newUrl = await ref.getDownloadURL();
                                await FirebaseTable()
                                    .usersTable
                                    .doc(FirebaseAuth
                                    .instance.currentUser!.uid)
                                    .update({
                                  "image": newUrl.toString(),
                                  "username": usernameController.text,
                                  "name": nameController.text,
                                  "phone_number":
                                  phoneNumberController.text
                                });

                             showToast(message: "Profile updated successfully");
                                setState(() {
                                  buttonLoader = false;
                                });

                                if(context.mounted)
                                  {
                                    Navigator.pop(context);
                                  }
                              });
                            }
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}