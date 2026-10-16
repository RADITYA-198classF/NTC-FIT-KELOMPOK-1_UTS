import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../data/app_session.dart';
import '../../data/models.dart';
import '../../widgets/option_pill.dart';

/// Layar 8 (3/3): "Berapa kali dalam seminggu Anda berlatih?"
class FrequencyScreen extends StatelessWidget {
  const FrequencyScreen({super.key});

  void _select(BuildContext context, WeeklyFrequency frequency) {
    session.weeklyFrequency = frequency;
    // TODO(api): simpan frekuensi latihan ke profil pengguna.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.loading,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: AppTheme.lightOverlay,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '3/3',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 120),
            const Text(
              'Berapa kali dalam seminggu Anda berlatih?',
              style: AppTextStyles.onboardingHeading,
            ),
            const SizedBox(height: 16),
            const Text(
              'Kami akan menggunakan ini untuk merekomendasikan latihan yang bisa Anda coba.',
              style: AppTextStyles.onboardingBody,
            ),
            const Spacer(),
            for (final WeeklyFrequency f in WeeklyFrequency.values) ...<Widget>[
              OptionPill(
                title: f.title,
                subtitle: f.subtitle,
                height: 78,
                onTap: () => _select(context, f),
              ),
              if (f != WeeklyFrequency.high) const SizedBox(height: 11),
            ],
          ],
        ),
      ),
    );
  }
}
