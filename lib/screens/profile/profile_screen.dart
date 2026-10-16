import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/app_session.dart';
import '../../data/dummy_data.dart';
import '../../widgets/pill_button.dart';

/// Halaman "Profil" (layar 22).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime joined = session.joinedAt;
    final String memberSince =
        'Anggota Sejak ${indonesianMonths[joined.month - 1]} ${joined.year}';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 28),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.avatar,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_camera_outlined, size: 38, color: Color(0xFFF2F2F2)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              session.fullName,
              style: const TextStyle(fontSize: 20, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: PillButton(
              label: 'Edit Profil',
              style: PillButtonStyle.outlinedDark,
              height: 44,
              horizontalPadding: 22,
              // TODO: layar Edit Profil belum ada di referensi.
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 40),
          Container(
            height: 62,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.divider),
              ),
            ),
            child: InkWell(
              // TODO: layar Akses (kode QR) belum ada di referensi.
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.qr_code, size: 24, color: AppColors.textPrimary),
                  SizedBox(height: 4),
                  Text(
                    'Akses',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            color: AppColors.divider,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
            child: Text(
              'Teman',
              style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: PillButton(
                label: 'Tambahkan Teman',
                style: PillButtonStyle.outlinedDark,
                height: 45,
                // TODO: layar Tambahkan Teman belum ada di referensi.
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            height: 44,
            color: AppColors.card,
            alignment: Alignment.center,
            child: Text(
              memberSince,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
