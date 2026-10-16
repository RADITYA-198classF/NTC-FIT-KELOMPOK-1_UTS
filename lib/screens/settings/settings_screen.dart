import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../data/app_session.dart';
import '../../widgets/workout_tile.dart';

/// Halaman "Pengaturan" (layar 20-21). Baris tanpa tujuan belum punya layar
/// di referensi, jadi sementara hanya menampilkan efek sentuh.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAndLeave(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal', style: TextStyle(color: AppColors.textPrimary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel, style: const TextStyle(color: AppColors.textPrimary)),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;
    // TODO(api): logout / hapus akun lewat backend.
    session.reset();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
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
          const _SettingsRow(label: 'Pengguna yang Diblokir'),
          const _SettingsRow(label: 'Info Latihan'),
          const _Gap(),
          const _SettingsRow(label: 'Negara/Wilayah'),
          const _SettingsRow(label: 'Bahasa'),
          const _SettingsRow(label: 'Pengaturan Belanja'),
          const _Gap(),
          const _SettingsRow(label: 'Tentang Versi Ini'),
          const _SettingsRow(label: 'Syarat Penggunaan'),
          const _SettingsRow(label: 'Kebijakan Privasi'),
          const _SettingsRow(label: 'Pertanyaan Umum Aplikasi'),
          const _SettingsRow(label: 'Hubungi Kami'),
          const _SettingsRow(label: 'Pengakuan'),
          const _Gap(),
          _SettingsRow(
            label: 'Hapus Akun',
            onTap: () => _confirmAndLeave(
              context,
              title: 'Hapus Akun',
              message: 'Akun Anda akan dihapus. Lanjutkan?',
              confirmLabel: 'Hapus',
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
            ),
          ),
        ],
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return InkWell(
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
                  style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 26, child: ColoredBox(color: AppColors.card));
  }
}
