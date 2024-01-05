import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:photofrenzy/models/image_post.dart';
import 'package:photofrenzy/models/text_post.dart';
import '../global/firebase_tables.dart';
import '../global/theme_mode.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  Uint8List? imageFileUint8List;

  final textController = TextEditingController();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? postImage = XFile("");
  var buttonLoading = false;

  File? imagePath;

  FirebaseStorage storage = FirebaseStorage.instance;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a photograph"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: Get.width,
          child: ElevatedButton(
            onPressed: buttonLoading
                ? null
                : () async {
                    List<Map<String, dynamic>> temp = [];
                    var data = await FirebaseTable()
                        .usersTable
                        .where("id",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

                    UserController userController = Get.put(UserController());

                    Reference ref = FirebaseStorage.instance.ref(
                        "/${FirebaseAuth.instance.currentUser!.uid}/marketplace/$id");
                    var file = File(postImage!.path);
                    print(file);
                    UploadTask uploadTask = ref.putFile(imagePath!);
                    Future.value(uploadTask).then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      await FirebaseTable().productsTable.doc(id).set({
                        "creator_name": temp[0]["name"],
                        "creator_username": temp[0]["username"],
                        "creator_profile_picture": temp[0]["profile_picture"],
                        "image_id": id,
                        "creator_id": FirebaseAuth.instance.currentUser!.uid,
                        "title": nameController.text,
                        "description": descriptionController.text,
                        "price": priceController.text,
                        "imageurl": newUrl.toString(),
                      });

                      showToast(message: "Photograph uploaded to marketplace");

                      setState(() {
                        buttonLoading = false;
                      });
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: buttonLoading
                ? const CircularProgressIndicator(
                    color: Colors.red,
                  )
                : Text(
                    "Add to marketplace",
                    style: GoogleFonts.lato(
                        letterSpacing: 0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
          ),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: Get.height * 0.4,
                      width: Get.width,
                      margin: const EdgeInsets.only(top: 10),
                      child: imageFileUint8List == null
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (c) {
                                      return SimpleDialog(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        title: const Text(
                                          "Item Image",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: [
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              if (postImage != null) {
                                                String imagepath =
                                                    postImage!.path;

                                                imageFileUint8List =
                                                    await postImage!
                                                        .readAsBytes();

                                                imagePath =
                                                    File(postImage!.path);

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                //remove the background
                                                setState(() {
                                                  imageFileUint8List;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Capture image with camera",
                                              style: TextStyle(
                                                  color: isDark(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              final postImage =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (postImage != null) {
                                                String imagepath =
                                                    postImage.path;
                                                imageFileUint8List =
                                                    await postImage
                                                        .readAsBytes();

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                //remove the background
                                                setState(() {
                                                  imageFileUint8List;
                                                });

                                                imagePath =
                                                    File(postImage!.path);
                                              }
                                            },
                                            child: Text(
                                              "Capture image from gallery",
                                              style: TextStyle(
                                                  color: isDark(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                          SimpleDialogOption(
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                      child: Text("Cancel"))
                                                ],
                                              )),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(Icons.add))
                          : InkWell(
                              onTap: () {
                                showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (c) {
                                      return SimpleDialog(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        title: const Text(
                                          "Item Image",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: [
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              if (postImage != null) {
                                                String imagepath =
                                                    postImage!.path;
                                                imageFileUint8List =
                                                    await postImage!
                                                        .readAsBytes();

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                //remove the background
                                                setState(() {
                                                  imageFileUint8List;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Capture image with camera",
                                              style: TextStyle(
                                                  color: isDark(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              final postImage =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (postImage != null) {
                                                String imagepath =
                                                    postImage.path;
                                                imageFileUint8List =
                                                    await postImage
                                                        .readAsBytes();

                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                //remove the background
                                                setState(() {
                                                  imageFileUint8List;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Capture image from gallery",
                                              style: TextStyle(
                                                  color: isDark(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                          SimpleDialogOption(
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                      child: Text("Cancel"))
                                                ],
                                              )),
                                        ],
                                      );
                                    });
                              },
                              child: Image.memory(
                                imageFileUint8List!,
                                // Replace with the path to your image
                                fit: BoxFit
                                    .fill, // Use BoxFit.fill to force the image to fill the container
                              ),
                            ),
                    ),
                    const Gap(20),
                    TextField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Enter name",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: InputBorder.none),
                    ),
                    const Gap(10),
                    TextField(
                      controller: priceController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Enter price",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: InputBorder.none),
                    ),
                    const Gap(10),
                    TextField(
                      maxLines: 5,
                      maxLength: 100,
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          int newLines = newValue.text.split('\n').length;
                          if (newLines > 5) {
                            return oldValue;
                          } else {
                            return newValue;
                          }
                        }),
                      ],
                      controller: descriptionController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          prefixIcon: const Icon(Icons.info),
                          hintText:
                              "Write something cool about your photograph..",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: InputBorder.none),
                    ),
                  ],
                ),
              ))),
    );
  }
}
