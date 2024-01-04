import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:icarm/config/setting/style.dart';

class VideoHomeWidget extends StatelessWidget {
  const VideoHomeWidget({
    super.key,
    required this.loading,
    required VideoPlayerController controller,
  }) : _controller = controller;

  final bool loading;
  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: (loading)
          ? Center(
              child: CircularProgressIndicator(
                color: ColorStyle.primaryColor.withOpacity(0.2),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: -16,
                      offset: Offset(0, -1))
                ],
              ),
              child: _controller.value.isInitialized
                  ? ClipRRect(
                      child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black12, BlendMode.darken),
                          child: VideoPlayer(_controller)),
                      borderRadius: BorderRadius.circular(30))
                  : Container(),
            ),
    );
  }
}
