import 'package:flutter/material.dart';

/// Gambar aset yang tidak membuat aplikasi error bila file belum ada:
/// otomatis memakai warna pengganti dengan ukuran yang sama.
/// Letakkan gambar di assets/images/ (lihat DAFTAR_ASET.md).
class AppImage extends StatelessWidget {
  const AppImage(
    this.asset, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.fallbackColor = const Color(0xFF3A3A3A),
  });

  final String asset;
  final BoxFit fit;
  final Alignment alignment;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return ColoredBox(color: fallbackColor);
      },
    );
  }
}
