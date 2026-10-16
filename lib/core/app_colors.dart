import 'package:flutter/material.dart';

/// Semua warna diambil dari sampel piksel screenshot referensi.
class AppColors {
  AppColors._();

  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);

  // Permukaan
  static const Color surface = Color(0xFFF7F7F7); // status bar, kolom cari
  static const Color card = Color(0xFFF5F5F5); // kartu abu, pemisah grup
  static const Color homeBackground = Color(0xFFFAFAFA); // halaman Rumah
  static const Color avatar = Color(0xFFD8D8D8);

  // Teks & ikon
  static const Color textPrimary = Color(0xFF101010);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF979797);
  static const Color iconInactive = Color(0xFF8C8C8C);

  // Garis
  static const Color divider = Color(0xFFE5E5E5);
  static const Color outline = Color(0xFFBDBDBD);
  static const Color webBorder = Color(0xFF7B7B7B);

  // Tema gelap (Program, Prestasi, bilah browser)
  static const Color webBar = Color(0xFF111111);
  static const Color darkAppBar = Color(0xFF222222);
  static const Color darkCard = Color(0xFF333333);
  static const Color darkStatus = Color(0xFF111111);
  static const Color achievementDark = Color(0xFF1D1D1D);

  // Aksen
  static const Color badgeRed = Color(0xFFD43F21); // label "Baru"
  static const Color error = Color(0xFFD43F21);
  static const Color trophyGrey = Color(0xFFE3E3E3);

  // Putih/hitam transparan (tanpa withOpacity agar kompatibel semua versi Flutter)
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white35 = Color(0x59FFFFFF);
  static const Color black20 = Color(0x33000000);
  static const Color black40 = Color(0x66000000);
  static const Color black60 = Color(0x99000000);
  static const Color black90 = Color(0xE6000000);
}
