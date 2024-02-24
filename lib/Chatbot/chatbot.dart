import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photofrenzy/authentication/login.dart';


class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot'),
        ),
        body: const Center(
          child: UserMentionText(
            text: 'Hello, @abc! Mentioning @def here.',
          ),
        ),
      )
     ;
  }
}

class UserMentionText extends StatelessWidget {
  final String text;

  const UserMentionText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    final pattern = RegExp(r'(@\w+)');

    text.splitMapJoin(
      pattern,
      onMatch: (match) {
        final userId = match.group(0)?.substring(1); // Remove @ symbol
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Colors.blue, // Customize color as needed
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }));
              },
          ),
        );
        return '';
      },
      onNonMatch: (text) {
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.black, // Regular text color
            ),
          ),
        );
        return '';
      },
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Text('User Profile Page for ID: $userId'),
      ),
    );
  }
}