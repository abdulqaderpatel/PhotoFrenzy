import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/Emotions/emotion_categorized_posts.dart';

import '../global/theme_mode.dart';

class ChooseEmotion extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  const ChooseEmotion({required this.posts, super.key});

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
  void initState() {
    // TODO: implement initState
    print(widget.posts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
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
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: emojis.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return EmotionCategorizedPosts(
                                  posts: widget.posts,
                                  emotion: emojis[index].name);
                            }));
                          },
                          child: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    emojis[index].code,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    emojis[index].name,
                                    style: const TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 150,
                      width: Get.width,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          opacity: 0.75,
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu97ixVlYnMizNnrUHMZ5-cwUzK507xFWgfQ&usqp=CAU"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Confused about how you feel?",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 17),
                          ),
                          Text(
                            "Use the emotion detector",
                            style: TextStyle(
                                color: isDark(context)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22),
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
