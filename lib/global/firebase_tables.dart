import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
class  FirebaseTable extends StatelessWidget {

  final usersTable=FirebaseFirestore.instance.collection("Users");
  final postsTable=FirebaseFirestore.instance.collection("Posts");
  final commentsTable=FirebaseFirestore.instance.collection("Comments");
  final repliesTable=FirebaseFirestore.instance.collection("Replies");

  FirebaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}