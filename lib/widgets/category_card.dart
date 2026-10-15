import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/models.dart';
import 'app_image.dart';

/// Kartu kategori (HIIT, Kekuatan, Yoga, Siap untuk Gym, Pilates).
/// Dipakai di halaman Latihan (bisa diketuk) dan sebagai spanduk di halaman daftar.
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, this.onTap});

  final WorkoutCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 159,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AppImage(category.image, fallbackColor: category.fallbackColor),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x00000000), AppColors.black20],
                  stops: <double>[0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 22,
              bottom: 20,
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
            if (onTap != null)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
