import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../data/app_session.dart';
import '../../widgets/pill_button.dart';

/// Layar 6: "Selamat datang {nama}, Anda telah bergabung!" + tombol Memulai.
class MemberWelcomeScreen extends StatelessWidget {
  const MemberWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightOverlay,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.webBorder, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 40,
                    color: AppColors.webBorder,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Selamat datang ${session.firstName}, Anda telah bergabung!',
                  style: AppTextStyles.onboardingHeading,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Untuk memastikan pengalaman terbaik Anda bersama Nike Training Club, kami perlu mengenal Anda lebih baik.',
                  style: AppTextStyles.onboardingBody,
                ),
                const SizedBox(height: 46),
                SizedBox(
                  width: double.infinity,
                  child: PillButton(
                    label: 'Memulai',
                    height: 58,
                    elevated: true,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.gender),
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
