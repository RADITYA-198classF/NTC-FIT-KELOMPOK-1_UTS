import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../data/app_session.dart';
import '../../data/models.dart';
import '../../widgets/option_pill.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});
  Future<void> _select(BuildContext context, Gender g) async {
    try {
      await session.saveGender(g);
      if (context.mounted) Navigator.of(context).pushNamed(AppRoutes.frequency);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
        '2/3',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Sesuaikan rekomendasi perlengkapan latihan untuk Anda.',
            style: AppTextStyles.onboardingHeading,
          ),
          const SizedBox(height: 16),
          const Text(
            'Kami akan merekomendasikan berbagai perlengkapan latihan sepanjang perjalanan kebugaran Anda.',
            style: AppTextStyles.onboardingBody,
          ),
          const SizedBox(height: 30),
          OptionPill(
            title: Gender.female.label,
            onTap: () => _select(context, Gender.female),
          ),
          const SizedBox(height: 11),
          OptionPill(
            title: Gender.male.label,
            onTap: () => _select(context, Gender.male),
          ),
        ],
      ),
    ),
  );
}
