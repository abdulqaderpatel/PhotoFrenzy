// import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/Emotions/emotion_categorized_posts.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../global/theme_mode.dart';

class EmotionDetector extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  EmotionDetector({required this.posts});

  @override
  _EmotionDetectorState createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;

  var v = "";

  var isImageSelected = false;

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {}
  }

  Future<void> getImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {}
  }

  Future detectimage(File image) async {
    setState(() {
      isImageSelected = false;
    });
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    late var value;
    setState(() {
      v = recognitions![0]["label"].substring(2);
      value = recognitions[0]["confidence"];
    });

    for (int i = 1; i < recognitions!.length; i++) {
      if (recognitions[i]["confidence"] > value) {
        setState(() {
          v = recognitions[i].substring(2);
        });
      }
    }

    setState(() {
      isImageSelected = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isImageSelected=false;
    });
    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EmotionCategorizedPosts(posts: widget.posts, emotion: v);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          children: [
            Text('Emotion Detector'),
            Text(
              "Upload a picture and we will determine your mood!",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImageFromCamera,
              child: const Text('Pick Image from Camera'),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isImageSelected)
              Column(
                children: [
                  Text(
                    "Looks like your mood is $v",
                    style: TextStyle(fontSize: 18,
                        color: isDark(context) ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    "Redirecting to posts..",
                    style: TextStyle(fontSize: 18,
                        color: isDark(context) ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 2,),

                  const CircularProgressIndicator()
                ],
              )
          ],
        ),
      ),
    );
  }
}
