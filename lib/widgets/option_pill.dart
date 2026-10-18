import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Pilihan berbentuk kapsul outline pada onboarding
/// (Wanita/Pria dan 0-1 / 2-4 / 5+ Latihan).
class OptionPill extends StatelessWidget {
  const OptionPill({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.height = 58,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.outline, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 28, right: 20),
          alignment: Alignment.centerLeft,
          child: subtitle == null
              ? Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
