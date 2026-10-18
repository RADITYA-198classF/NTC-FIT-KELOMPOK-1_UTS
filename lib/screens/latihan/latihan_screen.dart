import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/category_card.dart';
import '../../widgets/workout_tile.dart';
import '../../widgets/your_workout_icons.dart';
import '../workout/workout_list_screen.dart';

/// Tampilan latihan NTC Fit. Daftar latihan bersumber dari AppSession,
/// yang memuat data REST API ketika proses onboarding selesai.
class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _isSearching => _query.trim().isNotEmpty;

  bool _matches(Workout workout) {
    final String keyword = _query.trim().toLowerCase();
    return workout.title.toLowerCase().contains(keyword) ||
        workout.focus.toLowerCase().contains(keyword) ||
        workout.categories.any(
          (String category) => category.toLowerCase().contains(keyword),
        );
  }

  void _openList({required String title, WorkoutCategory? category}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            WorkoutListScreen(title: title, category: category),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: _search,
          onChanged: (String text) => setState(() => _query = text),
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.black,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: 'Cari',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _search.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults(List<Workout> workouts) {
    final List<Workout> results = workouts.where(_matches).toList();
    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text('Hasil pencarian', style: AppTextStyles.sectionTitle),
      ),
      if (results.isEmpty)
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Tidak ada latihan yang cocok.',
            style: AppTextStyles.emptyBody,
          ),
        )
      else
        for (final Workout workout in results)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: WorkoutTile(workout: workout),
          ),
    ];
  }

  List<Widget> _buildBrowse(List<Workout> workouts) {
    final List<Workout> hybrid = workouts
        .where(
          (Workout workout) => <String>['w1', 'w2', 'w3'].contains(workout.id),
        )
        .toList();

    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Text('Mode Hibrid', style: AppTextStyles.sectionTitle),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Text(
          'Kombinasi HIIT dan latihan kekuatan untuk meningkatkan '
          'daya tahan, kecepatan, dan kekuatan.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.42,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      for (final Workout workout in hybrid)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WorkoutTile(workout: workout),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => _openList(title: 'Semua latihan'),
            child: const Text('Lihat semua'),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
        child: Text(
          'Jelajahi menurut Kategori',
          style: AppTextStyles.sectionTitle,
        ),
      ),
      for (final WorkoutCategory category in dummyCategories)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: CategoryCard(
            category: category,
            onTap: () => _openList(title: category.name, category: category),
          ),
        ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Text('Latihan Anda', style: AppTextStyles.sectionTitle),
      ),
      SizedBox(
        height: 190,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, right: 8),
          children: <Widget>[
            ValueListenableBuilder<Set<String>>(
              valueListenable: session.savedIds,
              builder:
                  (BuildContext context, Set<String> saved, Widget? child) =>
                      _YourWorkoutCard(
                        kind: YourWorkoutIconKind.saved,
                        title: 'Disimpan',
                        count: saved.length,
                        onTap: () => widget.onNavigate(3),
                      ),
            ),
            _YourWorkoutCard(
              kind: YourWorkoutIconKind.all,
              title: 'Semua latihan',
              count: workouts.length,
              onTap: () => _openList(title: 'Semua latihan'),
            ),
            ValueListenableBuilder<int>(
              valueListenable: session.completedCount,
              builder: (BuildContext context, int completed, Widget? child) =>
                  _YourWorkoutCard(
                    kind: YourWorkoutIconKind.done,
                    title: 'Selesai',
                    count: completed,
                    onTap: () => widget.onNavigate(4),
                  ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Workout>>(
      valueListenable: session.workouts,
      builder: (BuildContext context, List<Workout> workouts, Widget? child) =>
          ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: <Widget>[
              _buildSearchField(),
              ...(_isSearching
                  ? _buildSearchResults(workouts)
                  : _buildBrowse(workouts)),
            ],
          ),
    );
  }
}

class _YourWorkoutCard extends StatelessWidget {
  const _YourWorkoutCard({
    required this.kind,
    required this.title,
    required this.count,
    required this.onTap,
  });

  final YourWorkoutIconKind kind;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 135,
                height: 135,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: YourWorkoutIcon(kind: kind)),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text('$count workouts', style: AppTextStyles.workoutMeta),
            ],
          ),
        ),
      ),
    );
  }
}
