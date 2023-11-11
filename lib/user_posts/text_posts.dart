import 'package:flutter/material.dart';

class TextPostsScreen extends StatefulWidget {
  const TextPostsScreen({super.key});

  @override
  State<TextPostsScreen> createState() => _TextPostsScreenState();
}

class _TextPostsScreenState extends State<TextPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: 1000,itemBuilder: (context,index){
        return Text("$index");
      })
    );
  }
}
