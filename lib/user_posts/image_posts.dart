import 'package:flutter/material.dart';

class ImagePostsScreen extends StatefulWidget {
  const ImagePostsScreen({super.key});

  @override
  State<ImagePostsScreen> createState() => _ImagePostsScreenState();
}

class _ImagePostsScreenState extends State<ImagePostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(itemCount: 1000,itemBuilder: (context,index){
          return Text("$index");
        })
    );
  }
}
