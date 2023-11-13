import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SenderText extends StatefulWidget {
  final String message;
  final Color textColor;
  final Color bubbleColor;
  const SenderText(
      {required this.message,
        required this.textColor,
        required this.bubbleColor,
        super.key});

  @override
  State<SenderText> createState() => _SenderTextState();
}

class _SenderTextState extends State<SenderText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
          color: widget.bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
          minWidth: 50, maxWidth: Get.width * 0.75, minHeight: 45),
      margin: const EdgeInsets.only(bottom: 20),
      child: Text(
        widget.message,
        style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w400),
      ),
    );
  }
}