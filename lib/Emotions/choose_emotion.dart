import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';

import '../global/theme_mode.dart';

class ChooseEmotion extends StatefulWidget {
  const ChooseEmotion({super.key});

  @override
  State<ChooseEmotion> createState() => _ChooseEmotionState();
}

class _ChooseEmotionState extends State<ChooseEmotion> {
  var emojis = [
    Emoji("happy", "😊"),
    Emoji("sad", "😔"),
    Emoji("fear", "😨"),
    Emoji("anger", "😠"),
    Emoji("disgust", "🤢"),
    Emoji("surprise", "😲")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("Choose Your Emotion"),
            Text(
              "You will see posts according to the emotion selected",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: emojis.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Theme.of(context).colorScheme.background,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  emojis[index].code,
                                  style: TextStyle(fontSize: 30),
                                ),
                                Text(
                                  emojis[index].name,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 150,
                      width: Get.width,
                     decoration: BoxDecoration( color: Colors.red,
                      image: DecorationImage(opacity: 0.75,
                        image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu97ixVlYnMizNnrUHMZ5-cwUzK507xFWgfQ&usqp=CAU"),
                        fit: BoxFit.cover,
                      ),
                    ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Confused about how you feel?",
                            style: TextStyle(color: Colors.white70,fontSize: 17),
                          ),
                          Text(
                            "Use the emotion detector",
                            style: TextStyle(
                                color: isDark(context)
                                    ? Colors.white
                                    : Colors.black,fontSize: 22),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
