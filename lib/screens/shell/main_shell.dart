import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../widgets/ntc_drawer.dart';
import '../activity/activity_screen.dart';
import '../home/rumah_screen.dart';
import '../inbox/inbox_screen.dart';
import '../latihan/latihan_screen.dart';
import '../program/program_screen.dart';
import '../saved/saved_screen.dart';

/// Kerangka halaman utama: bilah atas + drawer + 6 halaman.
/// Urutan indeks: 0 Latihan, 1 Program, 2 Rumah, 3 Latihan yang Disimpan,
/// 4 Aktivitas, 5 Kotak Masuk. Pengaturan dan Profil dibuka sebagai halaman terpisah.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  static const List<String> _titles = <String>[
    'Latihan',
    'Program',
    'Rumah',
    'Latihan yang Disimpan',
    'Aktivitas',
    'Kotak Masuk',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _index;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  void _openProfile() {
    Navigator.of(context).pushNamed(AppRoutes.profile);
  }

  PreferredSizeWidget _buildAppBar() {
    final bool dark = _index == 1;
    final Color foreground = dark ? AppColors.white : AppColors.textPrimary;

    return AppBar(
      backgroundColor: dark ? AppColors.darkAppBar : AppColors.white,
      foregroundColor: foreground,
      elevation: dark ? 0 : 3,
      systemOverlayStyle: dark ? AppTheme.darkOverlay : AppTheme.lightOverlay,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(
        _titles[_index],
        style: AppTextStyles.appBarTitle.copyWith(color: foreground),
      ),
      actions: <Widget>[
        if (_index == 2)
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            onPressed: _openProfile,
          ),
        if (_index == 4)
          IconButton(
            icon: const Icon(Icons.add),
            // TODO: tambah aktivitas manual (layar belum ada di referensi).
            onPressed: () {},
          ),
      ],
      bottom: _index == 4
          ? TabBar(
              controller: _tabController,
              indicatorColor: AppColors.black,
              indicatorWeight: 2,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.iconInactive,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: const <Widget>[
                Tab(text: 'Riwayat'),
                Tab(text: 'Prestasi'),
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      LatihanScreen(onNavigate: _select),
      const ProgramScreen(),
      RumahScreen(onNavigate: _select),
      SavedScreen(onNavigate: _select),
      ActivityScreen(tabController: _tabController, onNavigate: _select),
      const InboxScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      drawer: NtcDrawer(
        selectedIndex: _index,
        onSelect: (int i) {
          Navigator.of(context).pop();
          _select(i);
        },
        onOpenProfile: () {
          Navigator.of(context).pop();
          _openProfile();
        },
        onOpenSettings: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(AppRoutes.settings);
        },
      ),
      body: IndexedStack(index: _index, children: pages),
    );
  }
}
