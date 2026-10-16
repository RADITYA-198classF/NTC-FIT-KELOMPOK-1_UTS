import 'package:flutter/material.dart';

import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/workout_tile.dart';

/// Halaman "Latihan yang Disimpan" (layar 16). Kosong: ajakan menjelajah.
/// Jika ada latihan yang di-bookmark, tampil sebagai daftar (asumsi, tidak ada di referensi).
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: session.savedIds,
      builder: (BuildContext context, Set<String> saved, Widget? _) {
        final List<Workout> items =
            dummyWorkouts.where((Workout w) => saved.contains(w.id)).toList();

        if (items.isEmpty) {
          return Column(
            children: <Widget>[
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Tambah Latihan', style: AppTextStyles.emptyTitle),
                        SizedBox(height: 10),
                        Text(
                          'Simpan latihan favorit Anda untuk akses mudah kapan saja.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.emptyBody,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
                child: SizedBox(
                  width: double.infinity,
                  child: PillButton(
                    label: 'Jelajahi Latihan',
                    height: 50,
                    onPressed: () => onNavigate(0),
                  ),
                ),
              ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: <Widget>[
            for (final Workout w in items) WorkoutTile(workout: w),
          ],
        );
      },
    );
  }
}
