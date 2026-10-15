import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/ntc_logo.dart';
import '../../widgets/pill_button.dart';

/// Layar 2: Welcome dengan latar foto/video workout.
/// Bergabunglah dan Masuk sama-sama menuju halaman email.
/// Untuk video latar, lihat README bagian "Video latar Welcome".
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openAuth(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.authEmail);
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
            const AppImage(
              'assets/images/welcome_bg.jpg',
              alignment: Alignment.topCenter,
              fallbackColor: Color(0xFF4A1A5C),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[AppColors.black40, Color(0x00000000), Color(0x00000000), AppColors.black40],
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
