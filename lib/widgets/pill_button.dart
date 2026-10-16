import 'package:flutter/material.dart';

import '../core/app_colors.dart';

enum PillButtonStyle { filledBlack, filledWhite, outlinedWhite, outlinedDark }

/// Tombol berbentuk kapsul yang dipakai di hampir semua layar.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = PillButtonStyle.filledBlack,
    this.height = 52,
    this.width,
    this.fontSize = 16,
    this.elevated = false,
    this.horizontalPadding = 28,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillButtonStyle style;
  final double height;
  final double? width;
  final double fontSize;
  final bool elevated;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    Color background = AppColors.black;
    Color foreground = AppColors.white;
    BorderSide side = BorderSide.none;

    if (style == PillButtonStyle.filledWhite) {
      background = AppColors.white;
      foreground = AppColors.black;
    } else if (style == PillButtonStyle.outlinedWhite) {
      background = Colors.transparent;
      foreground = AppColors.white;
      side = const BorderSide(color: AppColors.white, width: 1);
    } else if (style == PillButtonStyle.outlinedDark) {
      background = Colors.transparent;
      foreground = AppColors.textPrimary;
      side = const BorderSide(color: AppColors.outline, width: 1.5);
    }

    return Material(
      color: background,
      elevation: elevated ? 4 : 0,
      shadowColor: AppColors.black40,
      shape: StadiumBorder(side: side),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            widthFactor: width == null ? 1 : null,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
