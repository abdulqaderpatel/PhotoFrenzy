import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/firebase_tables.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
        text: "Hello! I am Photon, your photography assistant",
        isUserMessage: false)
  ];

  void _sendMessage(String text) async {
    _controller.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/answer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_prompt': text}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String answer = jsonResponse['answer'];
      setState(() {
        _messages.insert(0, ChatMessage(text: answer, isUserMessage: false));
      });
    } else {
      setState(() {
        _messages.insert(0,
            ChatMessage(text: 'Failed to get response', isUserMessage: false));
      });
    }
  }

  var isLoading = false;

  var items = [];

  void getData() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .usersTable
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index].isUserMessage
                          ? _buildUserMessage(_messages[index])
                          : _buildBotMessage(_messages[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _sendMessage(_controller.text);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            margin: const EdgeInsets.only(left: 50.0, right: 10.0, bottom: 5.0),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: items[0]["profile_picture"] == ""
                ? const CircleAvatar(
                backgroundImage:
                AssetImage("assets/images/profile_picture.png"))
                : CircleAvatar(
              backgroundImage: NetworkImage(items[0]["profile_picture"]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            margin: const EdgeInsets.only(left: 10.0, right: 50.0, bottom: 5.0),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/robot.png"))

          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}
