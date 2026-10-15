import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Nama keluarga font untuk judul kondensed tebal (mis. "WORKOUTS THAT DO IT ALL").
/// Font asli Nike tidak boleh didistribusikan. Alternatif gratis (OFL):
/// Anton atau Oswald dari fonts.google.com. Daftarkan di pubspec.yaml dengan
/// family "NTCDisplay" (lihat README). Jika belum didaftarkan, Flutter memakai
/// font bawaan sehingga aplikasi tetap berjalan.
class AppFonts {
  AppFonts._();

  static const String display = 'NTCDisplay';
}

class AppTextStyles {
  AppTextStyles._();

  // Bilah aplikasi
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Judul bagian ("Mode Hibrid", "Jelajahi menurut Kategori", "Latihan Anda")
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Onboarding native
  static const TextStyle onboardingHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.18,
    color: AppColors.textPrimary,
  );
  static const TextStyle onboardingBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Halaman web (masuk/daftar)
  static const TextStyle webHeading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    height: 1.14,
    color: AppColors.textPrimary,
  );
  static const TextStyle webBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.textPrimary,
  );
  static const TextStyle webMuted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );
  static const TextStyle webLink = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
    decoration: TextDecoration.underline,
  );
  static const TextStyle webHelper = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Judul tampilan kondensed (Rumah, Aktivitas, Splash)
  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 0.98,
  );

  // Daftar latihan
  static const TextStyle workoutTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  static const TextStyle workoutMeta = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // Keadaan kosong
  static const TextStyle emptyTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle emptyBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );
}
