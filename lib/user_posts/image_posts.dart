import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/firebase_tables.dart';
import 'image_posts_list.dart';



class ImagePostsScreen extends StatefulWidget {
  final String id;
  const ImagePostsScreen({required this.id,super.key});

  @override
  State<ImagePostsScreen> createState() => _ImagePostsScreenState();
}

class _ImagePostsScreenState extends State<ImagePostsScreen> {

  List<Map<String, dynamic>> items = [];
  bool isLoading = false;

  void incrementCounter() async {
    setState(() {
      isLoading=true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id", isEqualTo: widget.id).where("type",isEqualTo: "image")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;
    });

    print(items);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    incrementCounter();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(child: CircularProgressIndicator(),):Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GridView.builder(
          itemCount: items.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ImagePostsListScreen(items, index);
                }));
              },
              child: Container(
                margin: const EdgeInsets.only(
                    top: 3, bottom: 3, left: 1.5, right: 1.5),
                child: Image.network(
                 items[index]
                  ["imageurl"], // Replace with the path to your image
                  fit: BoxFit
                      .fill, // Use BoxFit.fill to force the image to fill the container
                ),
              ),
            );
          }),
    );
  }
}