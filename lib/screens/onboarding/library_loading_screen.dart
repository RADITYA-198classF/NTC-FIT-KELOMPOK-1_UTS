import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../widgets/app_image.dart';

/// Layar 9: "Silakan tunggu selagi kami memuat pustaka latihan" di atas foto.
/// Setelah selesai masuk ke halaman utama (tab Latihan).
class LibraryLoadingScreen extends StatefulWidget {
  const LibraryLoadingScreen({super.key});

  @override
  State<LibraryLoadingScreen> createState() => _LibraryLoadingScreenState();
}

class _LibraryLoadingScreenState extends State<LibraryLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed && mounted) {
          // TODO(api): ganti dengan pemuatan pustaka latihan dari backend.
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.immersiveOverlay,
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const AppImage(
              'assets/images/group_workout.jpg',
              alignment: Alignment.topCenter,
              fallbackColor: Color(0xFF3A3A3A),
            ),
            const ColoredBox(color: AppColors.black40),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: 170,
                    child: Text(
                      'Silakan tunggu selagi kami memuat pustaka latihan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return SizedBox(
                        width: 100,
                        height: 2,
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: AppColors.white35,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
