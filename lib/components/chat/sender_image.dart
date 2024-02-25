import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class SenderImage extends StatefulWidget {
  final String time;
  final String message;
  final String imageurl;
  final Color textColor;
  final Color bubbleColor;

  const SenderImage(
      {required this.time,
        required this.message,
        required this.imageurl,
        required this.textColor,
        required this.bubbleColor,
        super.key});

  @override
  State<SenderImage> createState() => _SenderImageState();
}

class _SenderImageState extends State<SenderImage> {
  @override
  Widget build(BuildContext context) {
    var millisecondValue =
    int.parse(widget.time); // Replace this with your millisecond value

    var date = DateTime.fromMillisecondsSinceEpoch(millisecondValue);

    var formatter = DateFormat("hh:mm:a").format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align messages to the right
      children: [
        Column(
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
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
                Image.network(widget.imageurl),
                Text(
                  widget.message,
                  style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w400),
                ),
                Gap(10),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    formatter.toString(),
                    style: const TextStyle(
                        fontSize: 12.0, color: Colors.grey,fontWeight: FontWeight.w600), // Timestamp style
                  ),
                ),


              ],)
            ),
          ],
        ),

      ],
    );
  }
}
