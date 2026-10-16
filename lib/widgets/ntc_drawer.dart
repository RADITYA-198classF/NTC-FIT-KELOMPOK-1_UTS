import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/app_session.dart';

/// Menu samping (drawer). Indeks 0-5 sama dengan urutan halaman di MainShell.
class NtcDrawer extends StatelessWidget {
  const NtcDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.onOpenProfile,
    required this.onOpenSettings,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;

  static const List<_DrawerItem> _items = <_DrawerItem>[
    _DrawerItem('Latihan', Icons.timer_outlined),
    _DrawerItem('Program', Icons.assignment_turned_in_outlined),
    _DrawerItem('Rumah', Icons.home_outlined),
    _DrawerItem('Latihan yang Disimpan', Icons.bookmark_border),
    _DrawerItem('Aktivitas', Icons.bar_chart),
    _DrawerItem('Kotak Masuk', Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 254,
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: onOpenProfile,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 29,
                      backgroundColor: Color(0xFFE6E6E6),
                      child: Icon(Icons.person, size: 46, color: Color(0xFFBDBDBD)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      session.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.divider),
            const SizedBox(height: 4),
            for (int i = 0; i < _items.length; i++)
              _DrawerTile(
                label: _items[i].label,
                icon: _items[i].icon,
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              ),
            const SizedBox(height: 4),
            const Divider(height: 1, thickness: 1, color: AppColors.divider),
            const SizedBox(height: 4),
            _DrawerTile(
              label: 'Pengaturan',
              icon: Icons.settings_outlined,
              selected: false,
              onTap: onOpenSettings,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  const _DrawerItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.textPrimary : AppColors.iconInactive;
    return Material(
      color: selected ? AppColors.surface : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 22),
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
