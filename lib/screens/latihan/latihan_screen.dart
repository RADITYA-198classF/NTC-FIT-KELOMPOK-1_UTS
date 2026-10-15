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

/// Halaman "Latihan" (layar 10-12): pencarian, Mode Hibrid, kategori, Latihan Anda.
///
/// Mengetuk latihan membuka detail latihan. Mengetuk kategori (HIIT, Kekuatan,
/// Yoga, Siap untuk Gym, Pilates), "Lihat semua", atau "Semua latihan" membuka
/// daftar latihan. Kolom cari memfilter latihan langsung di halaman ini.
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

  bool _matches(Workout w) {
    final String q = _query.trim().toLowerCase();
    return w.title.toLowerCase().contains(q) ||
        w.focus.toLowerCase().contains(q) ||
        w.categories.any((String c) => c.toLowerCase().contains(q));
  }

  void _clearSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  void _openList({required String title, WorkoutCategory? category}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => WorkoutListScreen(title: title, category: category),
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
          onChanged: (String v) => setState(() => _query = v),
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.black,
          style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: 'Cari',
            hintStyle: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            isDense: true,
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
            suffixIcon: _isSearching
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: _clearSearch,
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBrowse() {
    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Text('Mode Hibrid', style: AppTextStyles.sectionTitle),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Text(
          'Tema untuk bulan April ini adalah kelincahan. Untuk merayakan peluncuran Nike Free Metcon 7, kami menyajikan kombinasi HIIT dan pliometrik dinamis untuk meningkatkan detak jantung Anda dan mendorong kecepatan serta kekuatan Anda. Kencangkan tali sepatu, ayo kita mulai.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.42,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      for (final Workout w in dummyHybridWorkouts)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WorkoutTile(workout: w),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openList(title: 'Semua latihan'),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
        child: Text('Jelajahi menurut Kategori', style: AppTextStyles.sectionTitle),
      ),
      for (final WorkoutCategory c in dummyCategories)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: CategoryCard(
            category: c,
            onTap: () => _openList(title: c.name, category: c),
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
              builder: (BuildContext context, Set<String> saved, Widget? _) {
                return _YourWorkoutCard(
                  kind: YourWorkoutIconKind.saved,
                  title: 'Disimpan',
                  count: saved.length,
                  onTap: () => widget.onNavigate(3),
                );
              },
            ),
            _YourWorkoutCard(
              kind: YourWorkoutIconKind.all,
              title: 'Semua latihan',
              count: dummyWorkouts.length,
              onTap: () => _openList(title: 'Semua latihan'),
            ),
            ValueListenableBuilder<int>(
              valueListenable: session.completedCount,
              builder: (BuildContext context, int done, Widget? _) {
                return _YourWorkoutCard(
                  kind: YourWorkoutIconKind.done,
                  title: 'Selesai',
                  count: done,
                  onTap: () => widget.onNavigate(4),
                );
              },
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildSearchResults() {
    final List<Workout> results = dummyWorkouts.where(_matches).toList();
    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text('Hasil pencarian', style: AppTextStyles.sectionTitle),
      ),
      if (results.isEmpty)
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Tidak ada latihan yang cocok.', style: AppTextStyles.emptyBody),
        )
      else
        for (final Workout w in results)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: WorkoutTile(workout: w),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: <Widget>[
        _buildSearchField(),
        ...(_isSearching ? _buildSearchResults() : _buildBrowse()),
      ],
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
