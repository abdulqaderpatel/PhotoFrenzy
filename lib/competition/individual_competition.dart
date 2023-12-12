import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/global/constants.dart';
import 'package:photofrenzy/global/firebase_tables.dart';

import 'package:http/http.dart' as http;
import '../global/show_message.dart';
import '../global/theme_mode.dart';

class IndividualCompetitionsScreen extends StatefulWidget {
  final Map<String, dynamic> competitionDetails;

  const IndividualCompetitionsScreen(
      {required this.competitionDetails, super.key});

  @override
  State<IndividualCompetitionsScreen> createState() =>
      _IndividualCompetitionsScreenState();
}

class _IndividualCompetitionsScreenState
    extends State<IndividualCompetitionsScreen> {
  File? postImage = File("");
  var buttonLoading = false;
  final picker = ImagePicker();

  var selectedFilteredImageType = "";

  FirebaseStorage storage = FirebaseStorage.instance;

  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  void incrementCounter() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .competitionsTable
        .doc(widget.competitionDetails["id"])
        .collection("Images")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;

    setState(() {
      isLoaded = false;
    });
  }

  var imageResponse = [];

  var effects = ["grayscale", "cartoon", "sketched", "blur"];

  @override
  void initState() {
    // TODO: implement initState
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (BuildContext context,
                    StateSetter setModalState /*You can rename this!*/) {
                  Future<void> fetchData(File? image) async {
                    imageResponse.clear();
                    for (var element in effects) {
                      var request = http.MultipartRequest('POST',
                          Uri.parse("http://10.0.2.2:5000/user/$element"));
                      request.files.add(await http.MultipartFile.fromPath(
                          'file', image!.path));
                      try {
                        var streamedResponse = await request.send();
                        var response =
                            await http.Response.fromStream(streamedResponse);

                        imageResponse.add(response.bodyBytes);

                        // Display the processed image
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                    setModalState(() {});
                  }

                  Future getImageGallery() async {
                    setState(() {
                      selectedFilteredImageType = "";
                    });
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setModalState(() {
                        postImage = File(pickedFile.path);
                      });
                      await fetchData(postImage);
                    }
                  }

                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Select an image",
                            style: TextStyle(
                                color: isDark(context)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                          Text("You can only submit one image per competition"),
                          Gap(15),
                          InkWell(
                            onTap: () {
                              getImageGallery();
                            },
                            child: postImage!.path.isNotEmpty
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    constraints: BoxConstraints(
                                        minWidth: Get.width,
                                        minHeight: Get.height * 0.4,
                                        maxHeight: Get.height * 0.5),
                                    child: selectedFilteredImageType != ""
                                        ? Image.memory(
                                            imageResponse[effects.indexOf(
                                                selectedFilteredImageType)],
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            postImage!,
                                            // Replace with the path to your image
                                            fit: BoxFit
                                                .fill, // Use BoxFit.fill to force the image to fill the container
                                          ),
                                  )
                                : DottedBorder(
                                    color: Colors.grey,
                                    strokeWidth: 1,
                                    dashPattern: [3, 3, 3, 3],
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      constraints: BoxConstraints(
                                          minWidth: Get.width,
                                          minHeight: Get.height * 0.4,
                                          maxHeight: Get.height * 0.5),
                                      child: const Center(
                                        child: Icon(Icons.camera),
                                      ),
                                    ),
                                  ),
                          ),
                          Gap(50),
                          SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: imageResponse.length == 4
                                      ? Row(
                                          children: effects.map((e) {
                                          var a = effects.indexOf(e);
                                          return Container(margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              children: [

                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await fetchData(postImage);
                                                        setModalState(() {
                                                          selectedFilteredImageType =
                                                              e;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 150,
                                                        width: 120,
                                                        decoration: BoxDecoration(

                                                          image: DecorationImage(
                                                              image: MemoryImage(
                                                                  imageResponse[a]),
                                                              fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                                Gap(2),
                                                Text(e)
                                              ],
                                            ),
                                          );
                                        }).toList())
                                      : Container(),
                                ),
                          Gap(30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(Get.width, 40),
                                backgroundColor: Colors.orange,
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                // Background color
                              ),
                              onPressed: buttonLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        buttonLoading = true;
                                      });
                                      int time =
                                          DateTime.now().millisecondsSinceEpoch;

                                      Reference ref = FirebaseStorage.instance.ref(
                                          "/${widget.competitionDetails["id"]}/$time");

                                      UploadTask uploadTask =
                                          selectedFilteredImageType != ""
                                              ? ref.putData(imageResponse[
                                                  effects.indexOf(
                                                      selectedFilteredImageType)])
                                              : ref
                                                  .putFile(postImage!.absolute);

                                      Future.value(uploadTask)
                                          .then((value) async {
                                        var newUrl = await ref.getDownloadURL();
                                        await FirebaseTable()
                                            .competitionsTable
                                            .doc(
                                                widget.competitionDetails["id"])
                                            .collection("Images")
                                            .doc(time.toString())
                                            .set({
                                          "id": time.toString(),
                                          "image": newUrl.toString()
                                        });

                                        showToast(
                                            message:
                                                "Post created successfully");
                                      });
                                    },
                              child: buttonLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Submit image")),
                        ],
                      ),
                    ),
                  );
                });
              });
        },
        child: const Icon(Icons.image),
      ),
      body: isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      height: Get.height * 0.4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        child: Image.network(
                          widget.competitionDetails["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            widget.competitionDetails["name"],
                            style: TextStyle(
                                color: isDark(context)
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 25),
                          ),
                          const Gap(10),
                          Text(
                            "Theme: ${widget.competitionDetails["type"]}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          const Gap(15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Description",
                              style: TextStyle(
                                  color: isDark(context)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            widget.competitionDetails["description"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          const Gap(15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Prize Distribution",
                              style: TextStyle(
                                  color: isDark(context)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "1st prize wins 50% of the total prize money: \$ ${(widget.competitionDetails["prize_money"] * 0.5).toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Text(
                            "2nd prize wins 30% of the total prize money: \$ ${(widget.competitionDetails["prize_money"] * 0.3).toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Text(
                            "3rd prize wins 20% of the total prize money: \$ ${(widget.competitionDetails["prize_money"] * 0.2).toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Get.height * 0.8,
                      color: Colors.blue,
                      child: GridView.builder(
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          // 3 images per row
                          crossAxisSpacing: 8.0,
                          // Space between images horizontally
                          mainAxisSpacing:
                              8.0, // Space between images vertically
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            items[index]["image"],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
