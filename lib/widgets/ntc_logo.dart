import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

/// Swoosh gambar vektor sederhana (pendekatan bentuk). Untuk hasil persis,
/// ganti dengan logo yang Anda berhak pakai (SVG/PNG) lewat assets.
class NikeSwoosh extends StatelessWidget {
  const NikeSwoosh({super.key, this.width = 62, this.color = AppColors.black});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.36,
      child: CustomPaint(painter: _SwooshPainter(color)),
    );
  }
}

class _SwooshPainter extends CustomPainter {
  _SwooshPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Path path = Path()
      ..moveTo(w, 0)
      ..cubicTo(w * 0.72, h * 0.40, w * 0.45, h * 0.78, w * 0.28, h * 0.92)
      ..cubicTo(w * 0.17, h * 1.00, w * 0.05, h * 0.96, w * 0.01, h * 0.74)
      ..cubicTo(w * 0.00, h * 0.56, w * 0.06, h * 0.44, w * 0.13, h * 0.34)
      ..cubicTo(w * 0.33, h * 0.64, w * 0.62, h * 0.40, w, 0)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _SwooshPainter oldDelegate) => oldDelegate.color != color;
}

/// Logo "NTC" untuk Splash. Memakai assets/images/ntc_logo.png bila ada,
/// jika tidak memakai swoosh + teks "NTC".
class NtcLogo extends StatelessWidget {
  const NtcLogo({super.key, this.width = 84});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ntc_logo.png',
      width: width,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NikeSwoosh(width: width),
              const SizedBox(height: 8),
              Text(
                'NTC',
                style: AppTextStyles.display.copyWith(
                  color: AppColors.black,
                  fontSize: 54,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
