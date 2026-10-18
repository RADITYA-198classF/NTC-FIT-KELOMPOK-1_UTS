import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../data/app_session.dart';
import '../data/models.dart';
import '../screens/workout/workout_detail_screen.dart';
import 'app_image.dart';

/// Baris latihan: thumbnail 90x90, judul, meta, durasi, dan ikon simpan.
class WorkoutTile extends StatelessWidget {
  const WorkoutTile({super.key, required this.workout, this.onTap});

  final Workout workout;

  /// Bila kosong, mengetuk baris membuka halaman detail latihan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: session.savedIds,
      builder: (BuildContext context, Set<String> saved, Widget? _) {
        final bool isSaved = saved.contains(workout.id);
        return InkWell(
          onTap:
              onTap ??
              () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        WorkoutDetailScreen(workout: workout),
                  ),
                );
              },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 90,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        AppImage(
                          workout.image,
                          fallbackColor: const Color(0xFF4A4A4A),
                        ),
                        if (workout.isNew)
                          const Positioned(
                            left: 4,
                            bottom: 4,
                            child: _NewBadge(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(workout.title, style: AppTextStyles.workoutTitle),
                      const SizedBox(height: 2),
                      Text(workout.meta, style: AppTextStyles.workoutMeta),
                      Text(workout.duration, style: AppTextStyles.workoutMeta),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  splashRadius: 20,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => session.toggleSaved(workout.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Baru',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.badgeRed,
        ),
      ),
    );
  }
}

/// Label "Baru" kecil yang dipakai juga di Pengaturan (baris Mitra).
class NewTag extends StatelessWidget {
  const NewTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Text(
        'Baru',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.badgeRed,
        ),
      ),
    );
  }
}
