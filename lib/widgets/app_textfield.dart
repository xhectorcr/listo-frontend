import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        counterText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly ? AppColors.background : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
        helperStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
