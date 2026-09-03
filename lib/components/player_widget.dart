import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;
  final dynamic audioData;

  const AudioPlayerScreen({
    required this.audioUrl,
    super.key,
    this.audioData,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.audioUrl);
      await _player.play();
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioData['name'] ?? 'Audio'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PlayerWidget(player: _player, audioData: widget.audioData),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  final AudioPlayer player;
  final dynamic audioData;

  const PlayerWidget({
    required this.player,
    this.audioData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data;

        if (duration == null) {
          return Center(child: loadingIndicator(color: primaryColor));
        }

        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;

            return Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  child: NetworkImageWithLoader(audioData['image']),
                ),
                const SizedBox(height: 20),
                Text(
                  audioData['name'] ?? 'Audio',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  audioData['description'] ?? '',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Slider(
                  activeColor: primaryColor,
                  inactiveColor: primaryColor.withValues(alpha: 0.3),
                  value: position.inMilliseconds / duration.inMilliseconds,
                  onChanged: (value) {
                    final newPosition = Duration(
                        milliseconds:
                            (value * duration.inMilliseconds).round());
                    player.seek(newPosition);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position)),
                      Text(_formatDuration(duration)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final isPlaying = playerState?.playing ?? false;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.stop_circle_outlined),
                          onPressed: () => player.stop(),
                          iconSize: 40,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 28,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                isPlaying ? player.pause() : player.play(),
                            iconSize: 32,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
