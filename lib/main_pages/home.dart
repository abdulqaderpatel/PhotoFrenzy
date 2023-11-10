import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: SafeArea(child: Image.network("https://firebasestorage.googleapis.com/v0/b/photofrenzy123.appspot.com/o/S3pYTTYIIuhUNFE9yLUXNiGeJIl1%2F1699616412715?alt=media&token=b26e0899-d3bb-49e7-af11-3aca3c96db21")));
  }
}
