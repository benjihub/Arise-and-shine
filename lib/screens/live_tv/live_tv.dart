import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/screens/live_tv/program_guide/program_guide.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TVScreen extends StatefulWidget {
  const TVScreen({super.key});

  @override
  State<TVScreen> createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  late VideoPlayerController _controller;
  final RxBool _isBuffering = false.obs;

  var homeController = Get.find<HomeController>();
  var ministryController = Get.find<MinistryController>();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(ministryController.tvLink.value),
    )
      ..addListener(() {
        setState(() {
          _isBuffering.value = _controller.value.isBuffering;
        });
      })
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      }).catchError((error) {
        if (kDebugMode) {
          print('Video player error: $error');
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      homeController.isFullScreenMode.value =
          !homeController.isFullScreenMode.value;
    });

    if (homeController.isFullScreenMode.value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: homeController.isFullScreenMode.value ? false : true,
      onPopInvokedWithResult: (didPop, result) {
        homeController.isFullScreenMode.value ? _toggleFullScreen() : null;
      },
      child: Scaffold(
        backgroundColor:
            homeController.isFullScreenMode.value ? Colors.black : null,
        appBar: homeController.isFullScreenMode.value
            ? null
            : AppBar(
                title: "Arise & Shine TV".text.make(),
                centerTitle: true,
              ),
        body: SafeArea(
          child: SingleChildScrollView(
            // Add this wrapper
            child: Column(
              children: [
                // Video Section
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Video Player
                    SizedBox(
                      height: homeController.isFullScreenMode.value
                          ? context.screenHeight
                          : null,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Center(
                          child: _controller.value.isInitialized
                              ? GestureDetector(
                                  onTap: _togglePlayPause,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayer(_controller),
                                  ),
                                )
                              : loadingIndicator(color: goldenColor),
                        ),
                      ),
                    ),
                    // Custom Controls Overlay
                    if (_controller.value.isInitialized)
                      Obx(
                        () => Stack(
                          children: [
                            _isBuffering.value
                                ? Center(
                                    child: loadingIndicator(color: goldenColor),
                                  )
                                : const SizedBox.shrink(),
                            _buildControls(),
                          ],
                        ),
                      ),
                  ],
                ),
                // Program Lineup
                Visibility(
                  visible: !homeController.isFullScreenMode.value,
                  child: SizedBox(
                    // Replace Expanded with SizedBox
                    height:
                        context.screenHeight * 0.6, // Adjust height as needed
                    child: const ProgramLineup(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _controller.value.isPlaying ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Play/Pause Button
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
              onPressed: _togglePlayPause,
            ),
            // Progress Bar
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white24,
              ),
            ),
            // Bottom Bar with Full-Screen Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _formatDuration(_controller.value.position),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    homeController.isFullScreenMode.value
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFullScreen,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _formatDuration(_controller.value.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours != '00' ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
