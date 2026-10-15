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

/// Layar 4: "Sekarang daftarkan diri Anda menjadi Anggota Nike."
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _first = TextEditingController();
  final TextEditingController _last = TextEditingController();
  final TextEditingController _day = TextEditingController();
  final TextEditingController _month = TextEditingController();
  final TextEditingController _year = TextEditingController();

  bool _marketing = false;
  bool _agree = false;
  bool _agreeError = false;
  int _seconds = AppConfig.resendCodeSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = AppConfig.resendCodeSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _first.dispose();
    _last.dispose();
    _day.dispose();
    _month.dispose();
    _year.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds -= 1);
      }
    });
  }

  void _resendCode() {
    if (_seconds > 0) return;
    // TODO(api): minta backend mengirim ulang kode verifikasi ke email.
    setState(() => _seconds = AppConfig.resendCodeSeconds);
    _startTimer();
  }

  String? _required(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;
  }

  String? _rangeValidator(String? value, int min, int max) {
    final int? n = int.tryParse((value ?? '').trim());
    if (n == null || n < min || n > max) return 'Tidak valid';
    return null;
  }

  void _submit() {
    final bool formOk = _formKey.currentState?.validate() ?? false;
    setState(() => _agreeError = !_agree);
    if (!formOk || !_agree) return;

    final int day = int.parse(_day.text.trim());
    final int month = int.parse(_month.text.trim());
    final int year = int.parse(_year.text.trim());
    final DateTime birth = DateTime(year, month, day);
    if (birth.day != day || birth.month != month) {
      // Tanggal tidak ada di kalender (mis. 31 Februari).
      _formKey.currentState?.validate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir tidak valid.')),
      );
      return;
    }

    session.firstName = _first.text.trim();
    session.lastName = _last.text.trim();
    session.birthDate = birth;
    session.marketingOptIn = _marketing;
    session.joinedAt = DateTime.now();
    // TODO(api): kirim kode + data pendaftaran ke backend, tampilkan error jika gagal.
    Navigator.of(context).pushNamed(AppRoutes.authSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = _seconds == 0;
    return BrowserFrame(
      onClose: () => Navigator.of(context).popUntil((Route<dynamic> r) => r.settings.name == AppRoutes.welcome),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(34, 30, 34, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const WebLogoRow(),
              const SizedBox(height: 30),
              const Text(
                'Sekarang daftarkan diri Anda menjadi Anggota Nike.',
                style: AppTextStyles.webHeading,
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.webBody,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Kami telah mengirimkan kode ke\n'),
                    TextSpan(text: '${session.email} '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Text(
                          'Edit',
                          style: AppTextStyles.webMuted.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              WebTextField(
                label: 'Kode*',
                controller: _code,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLength: 8,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                validator: _required,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: canResend ? AppColors.textPrimary : AppColors.iconInactive,
                  ),
                  onPressed: canResend ? _resendCode : null,
                ),
              ),
              const SizedBox(height: 6),
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
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: WebTextField(
                      label: 'Nama Depan*',
                      controller: _first,
                      textInputAction: TextInputAction.next,
                      validator: _required,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WebTextField(
                      label: 'Nama Belakang*',
                      controller: _last,
                      textInputAction: TextInputAction.next,
                      validator: _required,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Tanggal Lahir',
                  style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: WebTextField(
                      label: 'Hari*',
                      controller: _day,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 2,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      validator: (String? v) => _rangeValidator(v, 1, 31),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: WebTextField(
                      label: 'Bulan*',
                      controller: _month,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 2,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      validator: (String? v) => _rangeValidator(v, 1, 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: WebTextField(
                      label: 'Tahun*',
                      controller: _year,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      validator: (String? v) => _rangeValidator(v, 1900, DateTime.now().year),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Dapatkan Hadiah Anggota Nike pada hari ulang tahun Anda.',
                  style: AppTextStyles.webHelper,
                ),
              ),
              const SizedBox(height: 26),
              _CheckRow(
                value: _marketing,
                onChanged: (bool v) => setState(() => _marketing = v),
                child: const Text(
                  'Mendaftarlah untuk menerima email berisi info terbaru dari Nike tentang produk, penawaran, dan manfaat Anggota.',
                  style: AppTextStyles.webBody,
                ),
              ),
              const SizedBox(height: 18),
              _CheckRow(
                value: _agree,
                hasError: _agreeError,
                onChanged: (bool v) => setState(() {
                  _agree = v;
                  _agreeError = false;
                }),
                child: const Text.rich(
                  TextSpan(
                    style: AppTextStyles.webBody,
                    children: <InlineSpan>[
                      TextSpan(text: 'Saya menyetujui '),
                      TextSpan(text: 'Kebijakan Privasi', style: AppTextStyles.webLink),
                      TextSpan(text: ' dan '),
                      TextSpan(text: 'Ketentuan Penggunaan', style: AppTextStyles.webLink),
                      TextSpan(text: ' Nike.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: PillButton(
                  label: 'Buat Akun',
                  height: 42,
                  horizontalPadding: 22,
                  onPressed: _submit,
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

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
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
}
