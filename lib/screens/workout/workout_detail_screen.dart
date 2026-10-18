import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../data/app_session.dart';
import '../../data/models.dart';
import '../../widgets/app_image.dart';
import '../../widgets/pill_button.dart';
import 'workout_session_screen.dart';
import 'workout_video_screen.dart';

/// Detail latihan: foto, judul, info, deskripsi, langkah latihan (daftar
/// gerakan beserta repetisi/durasinya), dan tombol "Mulai Latihan".
/// Layar ini tidak ada di screenshot referensi; gayanya mengikuti layar lain.
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.workout});

  final Workout workout;

  void _start(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            WorkoutSessionScreen(workout: workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.immersiveOverlay,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AppImage(
                        workout.image,
                        alignment: Alignment.topCenter,
                        fallbackColor: const Color(0xFF4A4A4A),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              AppColors.black40,
                              Color(0x00000000),
                            ],
                            stops: <double>[0.0, 0.4],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        workout.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(color: AppColors.divider),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _InfoItem(label: 'Durasi', value: workout.duration),
                            _InfoItem(label: 'Level', value: workout.level),
                            _InfoItem(
                              label: 'Peralatan',
                              value: workout.equipment,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        workout.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Langkah Latihan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${workout.exercises.length} gerakan',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (int i = 0; i < workout.exercises.length; i++)
                        _ExerciseRow(
                          number: i + 1,
                          exercise: workout.exercises[i],
                          showDivider: i != workout.exercises.length - 1,
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: <Widget>[
                      _RoundIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: session.savedIds,
                        builder:
                            (
                              BuildContext context,
                              Set<String> saved,
                              Widget? _,
                            ) {
                              final bool isSaved = saved.contains(workout.id);
                              return _RoundIconButton(
                                icon: isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                onPressed: () =>
                                    session.toggleSaved(workout.id),
                              );
                            },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: PillButton(
                      label: 'Tonton Video Latihan',
                      style: PillButtonStyle.outlinedDark,
                      height: 48,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const WorkoutVideoScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: PillButton(
                      label: 'Mulai Latihan',
                      height: 52,
                      onPressed: workout.exercises.isEmpty
                          ? null
                          : () => _start(context),
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

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

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
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.number,
    required this.exercise,
    required this.showDivider,
  });

  final int number;
  final Exercise exercise;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      exercise.target,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.cue,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
