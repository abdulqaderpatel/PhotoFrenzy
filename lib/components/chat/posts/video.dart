
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String message;

  VideoCard({required this.videoUrl,this.message="fgjdlkgfjs gklfjgkls gjklsdf gjdfklsgjdklgdfjlkjgklfgjdkls"});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late CachedVideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Optional: Set video to loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,

      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              onTap: () {
                // Toggle play/pause on tap
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              },
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CachedVideoPlayer(_controller);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  if (!_controller.value.isPlaying) {
                    _controller.play();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                },
              ),
            ],
          ),
          ListTile(
            title: Text(this.widget.message), // Add title if needed
          ),
        ],
      ),
    );
  }
}