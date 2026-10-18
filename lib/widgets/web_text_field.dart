import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';

/// Kolom isian bergaya halaman web (label mengambang, sudut 8, border hitam saat fokus).
class WebTextField extends StatelessWidget {
  const WebTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: AppColors.black,
      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        counterText: '',
        isDense: true,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: _border(AppColors.webBorder, 1),
        focusedBorder: _border(AppColors.black, 1.5),
        errorBorder: _border(AppColors.error, 1),
        focusedErrorBorder: _border(AppColors.error, 1.5),
        errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
      ),
    );
  }
}
