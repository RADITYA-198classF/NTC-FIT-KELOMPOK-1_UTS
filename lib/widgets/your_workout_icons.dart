import 'package:flutter/material.dart';

/// Ikon sementara untuk kartu "Latihan Anda" (Disimpan, Semua latihan, Selesai).
/// Ganti dengan aset ikon asli bila ada.
enum YourWorkoutIconKind { saved, all, done }

class YourWorkoutIcon extends StatelessWidget {
  const YourWorkoutIcon({super.key, required this.kind});

  final YourWorkoutIconKind kind;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(56, 56),
      painter: _YourWorkoutPainter(kind),
    );
  }
}

class _YourWorkoutPainter extends CustomPainter {
  _YourWorkoutPainter(this.kind);

  final YourWorkoutIconKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint paint = Paint()..isAntiAlias = true;

    switch (kind) {
      case YourWorkoutIconKind.saved:
        paint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF3F7BFF),
            Color(0xFFB44DFF),
            Color(0xFFFF4D8D),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
        final Path path = Path()
          ..moveTo(w * 0.10, 0)
          ..lineTo(w * 0.45, 0)
          ..lineTo(w * 0.90, h * 0.55)
          ..lineTo(w * 0.90, h)
          ..lineTo(w * 0.55, h)
          ..lineTo(w * 0.10, h * 0.45)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case YourWorkoutIconKind.all:
        final double r = w * 0.34;
        final Rect left = Rect.fromCircle(
          center: Offset(w * 0.36, h * 0.5),
          radius: r,
        );
        final Rect right = Rect.fromCircle(
          center: Offset(w * 0.64, h * 0.5),
          radius: r,
        );
        paint.color = const Color(0xFF4BB8F2);
        canvas.drawOval(left, paint);
        paint.color = const Color(0xFFEC5877);
        canvas.drawOval(right, paint);
        canvas.save();
        canvas.clipPath(Path()..addOval(left));
        paint.color = const Color(0xFF8F3D86);
        canvas.drawOval(right, paint);
        canvas.restore();
        break;
      case YourWorkoutIconKind.done:
        paint.shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFFF5C7C), Color(0xFFFF8A5C)],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
        final Path diamond = Path()
          ..moveTo(w * 0.5, 0)
          ..lineTo(w, h * 0.5)
          ..lineTo(w * 0.5, h)
          ..lineTo(0, h * 0.5)
          ..close();
        canvas.drawPath(diamond, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _YourWorkoutPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
