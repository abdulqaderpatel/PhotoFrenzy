import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/global/show_message.dart';

import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final usernameController = TextEditingController();

  final nameController = TextEditingController();

  final bioController = TextEditingController();

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
    phoneNumberController.text = items[0]["phone_number"];
    bioController.text = items[0]["bio"];

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
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            bottom: 15,
          ),
          padding: EdgeInsets.only(left: 12, right: 12),
          width: Get.width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child:buttonLoader?CircularProgressIndicator(color: Colors.grey,): Text(
              "Edit Profile",
              style: GoogleFonts.roboto(
                  letterSpacing: 0,
                  color:Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            onPressed: () async {
              setState(() {
                buttonLoader = true;
              });
              if (nameController.text.isEmpty) {
                showToast(message: "Name cannot be empty", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else if (usernameController.text.isEmpty) {
                showToast(message: "Username cannot be empty", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else if (phoneNumberController.text.isEmpty) {
                showToast(message: "Phone number cannot be empty", error: true);
                setState(() {
                  buttonLoader = false;
                });
              }
              else if (bioController.text.isEmpty) {
                showToast(message: "Your info cannot be empty", error: true);
                setState(() {
                  buttonLoader = false;
                });
              }
              else if (!RegExp(r'^[a-zA-Z0-9]+$')
                  .hasMatch(nameController.text)) {
                showToast(message: "Please enter a valid name", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                  .hasMatch(usernameController.text)) {
                showToast(
                    message: "Please enter a valid username", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else if (!await checkIfUsernameIsUnique(
                      usernameController.text) &&
                  items[0]["username"] != usernameController.text) {
                showToast(
                    message: "Username has been already taken", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else if (phoneNumberController.text.length != 10 ||
                  phoneNumberController.text.contains(".") ||
                  phoneNumberController.text.contains(",")) {
                showToast(message: "Invalid phone number", error: true);
                setState(() {
                  buttonLoader = false;
                });
              } else {
                if (profileImage == null) {
                  await FirebaseTable()
                      .usersTable
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "username": usernameController.text,
                    "name": nameController.text,
                    "phone_number": phoneNumberController.text,
                    "bio": bioController.text
                  });
                  showToast(message: "Profile updated successfully");
                  setState(() {
                    buttonLoader = false;
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  Reference ref = FirebaseStorage.instance.ref(
                      "/${FirebaseAuth.instance.currentUser!.uid}/profile_picture");
                  UploadTask uploadTask = ref.putFile(profileImage!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    await FirebaseTable()
                        .usersTable
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      "profile_picture": newUrl.toString(),
                      "username": usernameController.text,
                      "name": nameController.text,
                      "phone_number": phoneNumberController.text,
                      "bio": bioController.text
                    });

                    showToast(message: "Profile updated successfully");
                    setState(() {
                      buttonLoader = false;
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
              }
            },
          )),
      body: isLoaded
          ? SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Get.width * 0.025, right: Get.width * 0.025),
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color:isDark(context) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25),
                            ),
                            Gap(Get.height * 0.015),
                            InkWell(
                              onTap: () {
                                getImageGallery();
                              },
                              child: Container(
                                width: 80,
                                height: 80,
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              prefixIcon: const Icon(Icons.person),
                              hintText: "Enter Name",
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: InputBorder.none),
                        ),
                        Gap(Get.height * 0.013),
                        TextField(
                          controller: usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              prefixIcon: const Icon(Icons.verified_user),
                              hintText: "Enter Username",
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: InputBorder.none),
                        ),
                        Gap(Get.height * 0.013),
                        TextField(
                          controller: phoneNumberController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              prefixIcon: const Icon(Icons.phone),
                              hintText: "Enter Phone number",
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: InputBorder.none),
                        ),
                        Gap(Get.height * 0.013),
                        TextField(
                          maxLines: 5,
                          maxLength: 100,
                          inputFormatters: [
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              int newLines = newValue.text.split('\n').length;
                              if (newLines > 5) {
                                return oldValue;
                              } else {
                                return newValue;
                              }
                            }),
                          ],
                          controller: bioController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              prefixIcon: const Icon(Icons.info),
                              hintText: "Write about yourself..",
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: InputBorder.none),
                        ),
                        Gap(Get.height * 0.013),
                        const SizedBox(
                          height: 90,
                        ),
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
