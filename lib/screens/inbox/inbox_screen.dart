import 'package:flutter/material.dart';

import '../../core/app_text_styles.dart';

/// Halaman "Kotak Masuk" (layar 19): keadaan kosong.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Belum Ada Pesan', style: AppTextStyles.emptyTitle),
            SizedBox(height: 10),
            Text(
              'Pesan dan notifikasi dari Nike akan ditampilkan di sini.',
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyBody,
            ),
          ],
        ),
      ),
    );
  }
}
