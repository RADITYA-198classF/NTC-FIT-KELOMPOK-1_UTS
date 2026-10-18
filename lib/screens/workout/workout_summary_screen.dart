import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../data/models.dart';
import '../../widgets/pill_button.dart';

/// Ringkasan setelah semua gerakan selesai. Riwayat sudah dicatat di sesi
/// dan tampil di Aktivitas > Riwayat. Layar ini tidak ada di referensi.
class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({
    super.key,
    required this.workout,
    required this.seconds,
  });

  final Workout workout;
  final int seconds;

  String _format(int totalSeconds) {
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _done(BuildContext context) {
    Navigator.of(context).popUntil(
      (Route<dynamic> route) =>
          route.settings.name == AppRoutes.main || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _done(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.darkOverlay,
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Text(
                    'LATIHAN SELESAI',
                    style: AppTextStyles.display.copyWith(fontSize: 44),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      color: AppColors.white60,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: <Widget>[
                      _Stat(label: 'Waktu total', value: _format(seconds)),
                      _Stat(
                        label: 'Gerakan',
                        value: '${workout.exercises.length}',
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: PillButton(
                      label: 'Selesai',
                      style: PillButtonStyle.filledWhite,
                      height: 56,
                      onPressed: () => _done(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.white60),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
