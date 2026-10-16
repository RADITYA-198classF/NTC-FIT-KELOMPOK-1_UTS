import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/models.dart';

/// Lencana trofi abu-abu (belum diraih). Bentuk sementara: belah ketupat atau lingkaran.
class TrophyBadge extends StatelessWidget {
  const TrophyBadge({super.key, required this.trophy, this.size = 60});

  final Trophy trophy;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget shape;
    if (trophy.shape == TrophyShape.diamond) {
      shape = Transform.rotate(
        angle: 0.7853981634,
        child: Container(
          width: size * 0.72,
          height: size * 0.72,
          decoration: BoxDecoration(
            color: AppColors.trophyGrey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      shape = Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.trophyGrey,
          shape: BoxShape.circle,
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          shape,
          Icon(trophy.icon, size: size * 0.42, color: AppColors.white),
        ],
      ),
    );
  }
}
