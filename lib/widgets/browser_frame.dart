import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../core/app_config.dart';
import '../core/app_theme.dart';
import 'ntc_logo.dart';

/// Bingkai halaman masuk/daftar yang meniru tampilan browser dalam aplikasi
/// pada referensi (bilah gelap: tutup, panah, alamat, bagikan, menu).
class BrowserFrame extends StatelessWidget {
  const BrowserFrame({super.key, required this.child, required this.onClose});

  final Widget child;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: <Widget>[
            Container(
              color: AppColors.webBar,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 52,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.white),
                        onPressed: onClose,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            AppConfig.authHostLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: AppColors.white,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: SafeArea(top: false, child: child)),
          ],
        ),
      ),
    );
  }
}

/// Baris logo di atas halaman web (swoosh).
class WebLogoRow extends StatelessWidget {
  const WebLogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: NikeSwoosh(width: 44),
    );
  }
}
