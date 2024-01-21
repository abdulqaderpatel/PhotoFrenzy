import 'package:flutter/material.dart';

class AddPostInCommunity extends StatefulWidget {
  final String community;

  const AddPostInCommunity({required this.community, super.key});

  @override
  State<AddPostInCommunity> createState() => _AddPostInCommunityState();
}

class _AddPostInCommunityState extends State<AddPostInCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
