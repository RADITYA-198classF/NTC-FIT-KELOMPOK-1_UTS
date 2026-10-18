import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_config.dart';
import '../../core/app_routes.dart';
import '../../core/app_text_styles.dart';
import '../../data/app_session.dart';
import '../../widgets/browser_frame.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/web_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _day = TextEditingController();
  final _month = TextEditingController();
  final _year = TextEditingController();
  bool _marketing = false,
      _agree = false,
      _agreeError = false,
      _loading = false;
  int _seconds = AppConfig.resendCodeSeconds;
  Timer? _timer;
  bool get _loginMode => session.emailExists;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in [_code, _first, _last, _day, _month, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resendCode() async {
    if (_seconds > 0) return;
    try {
      final code = await session.requestVerificationCode(session.email);
      if (mounted) {
        setState(() => _seconds = AppConfig.resendCodeSeconds);
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kode demo UTS: ${code ?? '-'}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;
  String? _range(String? v, int min, int max) {
    final n = int.tryParse((v ?? '').trim());
    return (n == null || n < min || n > max) ? 'Tidak valid' : null;
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (_loginMode) {
      if (_code.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan kode verifikasi.')),
        );
        return;
      }
      setState(() => _loading = true);
      try {
        await session.login(_code.text.trim());
        if (mounted) Navigator.of(context).pushNamed(AppRoutes.authSuccess);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$e')));
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }
    final formOk = _formKey.currentState?.validate() ?? false;
    setState(() => _agreeError = !_agree);
    if (!formOk || !_agree) return;
    final d = int.parse(_day.text),
        m = int.parse(_month.text),
        y = int.parse(_year.text);
    final birth = DateTime(y, m, d);
    if (birth.day != d || birth.month != m) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir tidak valid.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await session.register(
        code: _code.text.trim(),
        firstNameValue: _first.text.trim(),
        lastNameValue: _last.text.trim(),
        birth: birth,
        marketing: _marketing,
      );
      if (mounted) Navigator.of(context).pushNamed(AppRoutes.authSuccess);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _seconds == 0;
    return BrowserFrame(
      onClose: () =>
          Navigator.of(context)
              .popUntil((r) => r.settings.name == AppRoutes.welcome),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(34, 30, 34, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const WebLogoRow(),
              const SizedBox(height: 30),
              Text(
                _loginMode
                    ? 'Masukkan kode untuk masuk ke NTC Fit.'
                    : 'Sekarang daftarkan diri Anda menjadi Anggota NTC Fit.',
                style: AppTextStyles.webHeading,
              ),
              const SizedBox(height: 14),
              Text(
                'Kode telah dibuat untuk ${session.email}.',
                style: AppTextStyles.webBody,
              ),
              const SizedBox(height: 22),
              WebTextField(
                label: 'Kode*',
                controller: _code,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLength: 8,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: _required,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: canResend
                        ? AppColors.textPrimary
                        : AppColors.iconInactive,
                  ),
                  onPressed: canResend ? _resendCode : null,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: canResend
                    ? GestureDetector(
                        onTap: _resendCode,
                        child: Text(
                          'Kirim ulang kode',
                          style: AppTextStyles.webHelper.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        'Kirim ulang kode dalam $_seconds dtk',
                        style: AppTextStyles.webHelper,
                      ),
              ),
              if (!_loginMode) ...<Widget>[
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: WebTextField(
                        label: 'Nama Depan*',
                        controller: _first,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WebTextField(
                        label: 'Nama Belakang*',
                        controller: _last,
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Tanggal Lahir',
                  style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: WebTextField(
                        label: 'Hari*',
                        controller: _day,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) => _range(v, 1, 31),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: WebTextField(
                        label: 'Bulan*',
                        controller: _month,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) => _range(v, 1, 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: WebTextField(
                        label: 'Tahun*',
                        controller: _year,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) => _range(v, 1900, DateTime.now().year),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _CheckRow(
                  value: _marketing,
                  onChanged: (v) => setState(() => _marketing = v),
                  child: const Text(
                    'Terima email informasi terbaru dan manfaat anggota.',
                    style: AppTextStyles.webBody,
                  ),
                ),
                const SizedBox(height: 14),
                _CheckRow(
                  value: _agree,
                  hasError: _agreeError,
                  onChanged: (v) => setState(() {
                    _agree = v;
                    _agreeError = false;
                  }),
                  child: const Text(
                    'Saya menyetujui Kebijakan Privasi dan Ketentuan Penggunaan.',
                    style: AppTextStyles.webBody,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: PillButton(
                  label: _loading
                      ? 'Memproses...'
                      : (_loginMode ? 'Masuk' : 'Buat Akun'),
                  height: 42,
                  horizontalPadding: 22,
                  onPressed: _loading ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.value,
    required this.onChanged,
    required this.child,
    this.hasError = false,
  });
  final bool value, hasError;
  final ValueChanged<bool> onChanged;
  final Widget child;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: value ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : (value ? AppColors.black : AppColors.webBorder),
              width: 1.5,
            ),
          ),
          child: value
              ? const Icon(Icons.check, size: 16, color: AppColors.white)
              : null,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(child: child),
    ],
  );
}
