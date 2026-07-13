import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectiveDisabled = isDisabled || isLoading || onPressed == null;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: _getTextColor(effectiveDisabled),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: _getTextColor(effectiveDisabled)),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: _getTextColor(effectiveDisabled),
          ),
        ),
      ],
    );

    Widget button = SizedBox(
      height: 52,
      width: isFullWidth ? double.infinity : null,
      child: _buildMaterialButton(effectiveDisabled, buttonContent),
    );

    return button;
  }

  Widget _buildMaterialButton(bool effectiveDisabled, Widget child) {
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    );

    if (type == AppButtonType.text) {
      return TextButton(
        onPressed: effectiveDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          foregroundColor: AppColors.primary,
        ),
        child: child,
      );
    }

    if (type == AppButtonType.outline) {
      return OutlinedButton(
        onPressed: effectiveDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: BorderSide(
            color: effectiveDisabled ? AppColors.disabled : AppColors.border,
            width: 1.5,
          ),
          foregroundColor: AppColors.primary,
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: effectiveDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _getBackgroundColor(effectiveDisabled),
        foregroundColor: _getTextColor(effectiveDisabled),
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.textDisabled,
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shadowColor: Colors.transparent,
      ).copyWith(
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return 0;
            return 0; // minimal elevation
          },
        ),
      ),
      child: child,
    );
  }

  Color _getBackgroundColor(bool disabled) {
    if (disabled) return AppColors.disabled;
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.secondary;
      case AppButtonType.outline:
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool disabled) {
    if (disabled) return AppColors.textDisabled;
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        return AppColors.textInverse;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.primary;
    }
  }
}
