import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatelessWidget {
  final String url;
  const VideoPlayerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.network(url);

    final chewie = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(child: Chewie(controller: chewie)),
    );
  }
}
