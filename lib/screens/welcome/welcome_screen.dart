import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../widgets/ntc_logo.dart';
import '../../widgets/pill_button.dart';

/// Layar welcome dengan video sebagai latar belakang.
/// Tata letak logo, teks, dan tombol tetap sama.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final VideoPlayerController _videoController;
  bool _videoReady = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initializeBackgroundVideo();
  }

  Future<void> _initializeBackgroundVideo() async {
    _videoController = VideoPlayerController.asset(
      'assets/videos/workout_demo.mp4',
    );

    try {
      await _videoController.initialize();
      await _videoController.setLooping(true);
      // Video latar diputar tanpa suara agar tidak mengganggu halaman pembuka.
      await _videoController.setVolume(0);
      if (!mounted) return;
      setState(() => _videoReady = true);
      await _videoController.play();
    } catch (_) {
      if (mounted) setState(() => _videoFailed = true);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _openAuth(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.authEmail);
  }

  Widget _buildVideoBackground() {
    if (_videoFailed || !_videoReady) {
      return const ColoredBox(color: Color(0xFF3A1250));
    }

    final size = _videoController.value.size;
    if (size.width <= 0 || size.height <= 0) {
      return const ColoredBox(color: Color(0xFF3A1250));
    }

    // BoxFit.cover memenuhi layar seperti foto latar sebelumnya.
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: VideoPlayer(_videoController),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.immersiveOverlay,
      child: Scaffold(
        backgroundColor: const Color(0xFF3A1250),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildVideoBackground(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    AppColors.black40,
                    Color(0x00000000),
                    Color(0x00000000),
                    AppColors.black40,
                  ],
                  stops: <double>[0.0, 0.25, 0.65, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 34, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const NikeSwoosh(width: 62, color: AppColors.white),
                    const Spacer(),
                    const Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Nike Training Club\n',
                            style: TextStyle(color: AppColors.white),
                          ),
                          TextSpan(
                            text: 'Latihan kekuatan dimulai di sini. Berlatihlah bersama kami.',
                            style: TextStyle(color: AppColors.white60),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        height: 1.22,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: PillButton(
                            label: 'Bergabunglah',
                            style: PillButtonStyle.filledWhite,
                            height: 56,
                            onPressed: () => _openAuth(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PillButton(
                            label: 'Masuk',
                            style: PillButtonStyle.outlinedWhite,
                            height: 56,
                            onPressed: () => _openAuth(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
