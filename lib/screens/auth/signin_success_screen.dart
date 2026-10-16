import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/browser_frame.dart';
import '../../widgets/pill_button.dart';

/// Layar 5: "Anda berhasil masuk." lalu tombol Lanjutkan.
class SigninSuccessScreen extends StatelessWidget {
  const SigninSuccessScreen({super.key});

  void _continue(BuildContext context) {
    // Menutup "browser" dan kembali ke aplikasi: lanjut ke sambutan anggota.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.memberWelcome,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrowserFrame(
      onClose: () => _continue(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(34, 30, 34, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const WebLogoRow(),
            const SizedBox(height: 34),
            const Text('Anda berhasil masuk.', style: AppTextStyles.webHeading),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: PillButton(
                label: 'Lanjutkan',
                height: 42,
                horizontalPadding: 22,
                onPressed: () => _continue(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
