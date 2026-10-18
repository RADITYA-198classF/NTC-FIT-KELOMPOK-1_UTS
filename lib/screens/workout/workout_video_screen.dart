import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';

/// Pemutar video demonstrasi latihan yang disimpan sebagai aset lokal.
class WorkoutVideoScreen extends StatefulWidget {
  const WorkoutVideoScreen({super.key});

  @override
  State<WorkoutVideoScreen> createState() => _WorkoutVideoScreenState();
}

class _WorkoutVideoScreenState extends State<WorkoutVideoScreen> {
  late final VideoPlayerController _controller;
  Object? _initializationError;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/workout_demo.mp4');
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(false);
      if (mounted) setState(() {});
    } catch (error) {
      if (mounted) setState(() => _initializationError = error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _time(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightOverlay,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          title: const Text('Video Latihan'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _initializationError != null
                ? const Text(
                    'Video belum dapat diputar. Pastikan aset video sudah terpasang dan jalankan flutter pub get.',
                    textAlign: TextAlign.center,
                  )
                : !_controller.value.isInitialized
                ? const CircularProgressIndicator(color: AppColors.black)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  if (_controller.value.position >=
                                      _controller.value.duration) {
                                    _controller.seekTo(Duration.zero);
                                  }
                                  _controller.play();
                                }
                              });
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              colors: const VideoProgressColors(
                                playedColor: AppColors.black,
                                bufferedColor: AppColors.outline,
                                backgroundColor: AppColors.divider,
                              ),
                            ),
                          ),
                          Text(
                            '${_time(_controller.value.position)} / ${_time(_controller.value.duration)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Video demonstrasi latihan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
