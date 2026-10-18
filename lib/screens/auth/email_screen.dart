import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../widgets/browser_frame.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/web_text_field.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});
  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final t = (value ?? '').trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
        ? null
        : 'Masukkan alamat email yang valid.';
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false) || _loading) return;
    setState(() => _loading = true);
    try {
      final code = await session.requestVerificationCode(_email.text.trim());
      if (!mounted) return;
      if (code != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Kode demo UTS: $code')));
      }
      Navigator.of(context).pushNamed(AppRoutes.authRegister);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('API gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => BrowserFrame(
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
                Text(
                  'Ubah',
                  style: AppTextStyles.webMuted.copyWith(
                    decoration: TextDecoration.underline,
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
            const Text(
              'Untuk demo lokal, kode verifikasi diberikan oleh backend.',
              style: AppTextStyles.webMuted,
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: PillButton(
                label: _loading ? 'Memuat...' : 'Lanjutkan',
                height: 42,
                horizontalPadding: 22,
                onPressed: _loading ? null : _continue,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
