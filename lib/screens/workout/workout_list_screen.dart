import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/category_card.dart';
import '../../widgets/workout_tile.dart';

/// Daftar latihan untuk satu kategori (HIIT, Kekuatan, Yoga, Siap untuk Gym,
/// Pilates) atau semua latihan bila [category] kosong. Mengetuk baris membuka
/// detail latihan. Layar ini tidak ada di screenshot referensi.
class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key, required this.title, this.category});

  final String title;
  final WorkoutCategory? category;

  @override
  Widget build(BuildContext context) {
    final WorkoutCategory? cat = category;
    final List<Workout> workouts = cat == null
        ? dummyWorkouts
        : dummyWorkouts.where((Workout w) => w.categories.contains(cat.name)).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(title, style: AppTextStyles.appBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: <Widget>[
          if (cat != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: CategoryCard(category: cat),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Text('${workouts.length} workouts', style: AppTextStyles.workoutMeta),
          ),
          if (workouts.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text('Belum ada latihan.', style: AppTextStyles.emptyBody),
            )
          else
            for (final Workout w in workouts)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: WorkoutTile(workout: w),
              ),
        ],
      ),
    );
  }
}
