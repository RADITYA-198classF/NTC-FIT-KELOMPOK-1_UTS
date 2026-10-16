import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../widgets/browser_frame.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/web_text_field.dart';

/// Layar 3: "Masukkan email Anda untuk mendaftar atau masuk."
class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final String text = (value ?? '').trim();
    final bool valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    return valid ? null : 'Masukkan alamat email yang valid.';
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    session.email = _email.text.trim();
    // TODO(api): cek email ke backend. Email baru -> daftar, email lama -> masuk.
    Navigator.of(context).pushNamed(AppRoutes.authRegister);
  }

  @override
  Widget build(BuildContext context) {
    return BrowserFrame(
      onClose: () => Navigator.of(context).maybePop(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(34, 30, 34, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const WebLogoRow(),
              const SizedBox(height: 34),
              const Text(
                'Masukkan email Anda untuk mendaftar atau masuk.',
                style: AppTextStyles.webHeading,
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  const Text('Indonesia', style: AppTextStyles.webBody),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Ubah',
                      style: AppTextStyles.webMuted.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              WebTextField(
                label: 'Email*',
                controller: _email,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: _validate,
                onFieldSubmitted: (_) => _continue(),
              ),
              const SizedBox(height: 28),
              const Text.rich(
                TextSpan(
                  style: AppTextStyles.webMuted,
                  children: <InlineSpan>[
                    TextSpan(text: 'Dengan melanjutkan, saya menyetujui '),
                    TextSpan(text: 'Kebijakan Privasi', style: AppTextStyles.webLink),
                    TextSpan(text: ' dan '),
                    TextSpan(text: 'Ketentuan Penggunaan', style: AppTextStyles.webLink),
                    TextSpan(text: ' Nike.'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerRight,
                child: PillButton(
                  label: 'Lanjutkan',
                  height: 42,
                  horizontalPadding: 22,
                  onPressed: _continue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
