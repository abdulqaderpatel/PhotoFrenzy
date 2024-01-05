

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class ReceiverText extends StatefulWidget {
  final String message;
  final String time;
  final Color bubbleColor;
  final Color textColor;
  const ReceiverText(
      {required this.message,
        required this.time,
        required this.bubbleColor,
        required this.textColor,
        super.key});

  @override
  State<ReceiverText> createState() => _ReceiverTextState();
}

class _ReceiverTextState extends State<ReceiverText> {




@override
  Widget build(BuildContext context) {
  var millisecondValue =int.parse(widget.time); // Replace this with your millisecond value


  var date = DateTime.fromMillisecondsSinceEpoch(millisecondValue);

var formatter=DateFormat("hh:mm:a").format(date);
  return Row(
    mainAxisAlignment: MainAxisAlignment.start, // Align messages to the right
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: widget.bubbleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
                minWidth: 50, maxWidth: Get.width * 0.75, minHeight: 45),
            margin: const EdgeInsets.only(),
            child: Text(
              widget.message,
              style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Text(
              formatter.toString(),
              style: const TextStyle(
                  fontSize: 12.0, color: Colors.grey,fontWeight: FontWeight.w600), // Timestamp style
            ),
          ),
          const Gap(20)
        ],
      ),
    ],
  );
  }
}