import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photofrenzy/authentication/login.dart';
import 'package:photofrenzy/profiles/random_tagged_user_profile.dart';

import 'global/theme_mode.dart';

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
                fontSize: 15,
                color:Colors.blue,
                fontWeight:
                FontWeight
                    .bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return RandomTaggedUserProfile(username: match.group(0)!.substring(1));
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
            style: TextStyle(
                fontSize: 15,
                color: isDark(
                    context)
                    ? Colors.white
                    : Colors
                    .black,
                fontWeight:
                FontWeight
                    .w400)
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