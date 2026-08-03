import 'package:arise_and_shine/components/video_list.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSermonDetails extends StatefulWidget {
  final dynamic videoData;
  final List<dynamic> videos;
  const VideoSermonDetails(
      {super.key, required this.videoData, required this.videos});

  @override
  State<VideoSermonDetails> createState() => _VideoSermonDetailsState();
}

class _VideoSermonDetailsState extends State<VideoSermonDetails> {
  late YoutubePlayerController _youtubeController;
  RxBool hideAppBar = false.obs;

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    final rawId = widget.videoData['link'] ?? widget.videoData['videoId'] ?? '';
    final videoId =
        YoutubePlayer.convertUrlToId(rawId.toString()) ?? rawId.toString();

    // Initialize the YouTube Player Controller
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _youtubeController.addListener(() {
      if (_youtubeController.value.isFullScreen) {
        hideAppBar(true);
        // When in full-screen mode, hide the system UI (network bars, time, etc.)
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      } else {
        hideAppBar(false);

        // When exiting full-screen mode, restore the system UI
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: hideAppBar.value == true
            ? null
            : AppBar(
                title: Text(
                  widget.videoData['title'],
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
            progressColors: const ProgressBarColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
            ),
            onReady: () {
              debugPrint('YouTube Player is ready.');
            },
          ),
          builder: (context, player) {
            return SafeArea(
              child: Column(
                children: [
                  // Video Player Section
                  player,
                  10.heightBox,
                  Expanded(
                      child: VideoList(
                    videoTitleToEliminate: widget.videoData['title'],
                    videos: widget.videos,
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
