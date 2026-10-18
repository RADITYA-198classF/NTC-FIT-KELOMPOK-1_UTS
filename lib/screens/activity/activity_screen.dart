import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/app_image.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/trophy_badge.dart';

/// Halaman "Aktivitas" (layar 17-18). TabBar (Riwayat, Prestasi) berada di
/// AppBar milik MainShell dan dikendalikan oleh [tabController].
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({
    super.key,
    required this.tabController,
    required this.onNavigate,
  });

  final TabController tabController;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        _HistoryTab(onFindWorkout: () => onNavigate(0)),
        _AchievementsTab(onFindWorkout: () => onNavigate(0)),
      ],
    );
  }
}

/// Riwayat: daftar sesi yang selesai; bila belum ada, tampilan ajakan (referensi).
class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.onFindWorkout});

  final VoidCallback onFindWorkout;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutRecord>>(
      valueListenable: session.history,
      builder: (BuildContext context, List<WorkoutRecord> records, Widget? _) {
        if (records.isEmpty) return _HistoryEmpty(onFindWorkout: onFindWorkout);
        return _HistoryList(records: records);
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.records});

  final List<WorkoutRecord> records;

  String _format(int totalSeconds) {
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: records.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      itemBuilder: (BuildContext context, int index) {
        final WorkoutRecord r = records[index];
        final DateTime d = r.completedAt;
        final String date =
            '${d.day} ${indonesianMonths[d.month - 1]} ${d.year}';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(r.title, style: AppTextStyles.workoutTitle),
                    const SizedBox(height: 2),
                    Text(
                      '$date · ${_format(r.seconds)} · ${r.exerciseCount} gerakan',
                      style: AppTextStyles.workoutMeta,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty({required this.onFindWorkout});

  final VoidCallback onFindWorkout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const AppImage(
          'assets/images/group_running.jpg',
          alignment: Alignment.topCenter,
          fallbackColor: Color(0xFF2A2A2A),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.black20,
                AppColors.black60,
                AppColors.black90,
              ],
              stops: <double>[0.0, 0.5, 1.0],
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 160, 16, 24),
          child: Column(
            children: <Widget>[
              Text(
                'PASTIKAN LATIHAN\nBERJALAN SESUAI RENCANA',
                textAlign: TextAlign.center,
                style: AppTextStyles.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Latihan Anda dicatat di sini. Klik plus untuk menambahkan aktivitas yang Anda lakukan di luar aplikasi.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.3,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 52),
              PillButton(
                label: 'Cari Latihan',
                style: PillButtonStyle.outlinedWhite,
                height: 42,
                horizontalPadding: 30,
                onPressed: onFindWorkout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AchievementsTab extends StatelessWidget {
  const _AchievementsTab({required this.onFindWorkout});

  final VoidCallback onFindWorkout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 348,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const AppImage(
                'assets/images/metcon_barbell.jpg',
                fallbackColor: AppColors.achievementDark,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 82, 24, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'BERLATIH DAN\nKUMPULKAN',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(fontSize: 40),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Anda berhasil, rayakan sekarang. Dengan latihan, kini Anda bisa mendapatkan trofi, penghargaan, dan streak.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.3,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 28),
                    PillButton(
                      label: 'Cari Latihan',
                      style: PillButtonStyle.outlinedWhite,
                      height: 42,
                      horizontalPadding: 30,
                      onPressed: onFindWorkout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Semua Prestasi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.textPrimary),
                // TODO: filter prestasi (layar belum ada di referensi).
                onPressed: () {},
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
          child: Text(
            'Trofi',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.82,
            mainAxisSpacing: 8,
            children: <Widget>[
              for (final Trophy t in dummyTrophies) _TrophyCell(trophy: t),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrophyCell extends StatelessWidget {
  const _TrophyCell({required this.trophy});

  final Trophy trophy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TrophyBadge(trophy: trophy),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            trophy.name,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
