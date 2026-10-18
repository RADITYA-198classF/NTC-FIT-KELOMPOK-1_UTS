import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../data/app_session.dart';
import '../../widgets/workout_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  Future<void> _confirmAndLeave(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required bool delete,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: Text(
              confirmLabel,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      if (delete) {
        await session.deleteAccount();
      } else {
        await session.logout();
      }
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.welcome, (r) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('API gagal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Pengaturan',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _SettingsRow(label: 'Email', value: session.email),
        const _SettingsRow(label: 'Nomor Ponsel'),
        const _SettingsRow(label: 'Tentang Anda'),
        const _SettingsRow(label: 'Unit Pengukuran'),
        const _Gap(),
        const _SettingsRow(label: 'Pengaturan Latihan'),
        const _SettingsRow(label: 'Mitra', showNewTag: true),
        const _Gap(),
        const _SettingsRow(label: 'Preferensi Notifikasi'),
        const _SettingsRow(label: 'Privasi'),
        const _SettingsRow(label: 'Visibilitas Profil'),
        const _Gap(),
        _SettingsRow(
          label: 'Hapus Akun',
          onTap: () => _confirmAndLeave(
            context,
            title: 'Hapus Akun',
            message: 'Akun dan data tersimpan akan dihapus dari database. Lanjutkan?',
            confirmLabel: 'Hapus',
            delete: true,
          ),
        ),
        const _Gap(),
        _SettingsRow(
          label: 'Keluar',
          onTap: () => _confirmAndLeave(
            context,
            title: 'Keluar',
            message: 'Apakah Anda yakin ingin keluar?',
            confirmLabel: 'Keluar',
            delete: false,
          ),
        ),
      ],
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    this.value,
    this.showNewTag = false,
    this.onTap,
  });
  final String label;
  final String? value;
  final bool showNewTag;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap ?? () {},
    child: Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          if (showNewTag) ...<Widget>[
            const SizedBox(width: 14),
            const NewTag(),
          ],
          const Spacer(),
          if (value != null)
            Flexible(
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _Gap extends StatelessWidget {
  const _Gap();
  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 26, child: ColoredBox(color: AppColors.card));
}
