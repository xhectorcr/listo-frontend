import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppDialog {
  AppDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.largeRadius,
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (cancelText != null) ...[
                  AppButton(
                    text: cancelText,
                    type: AppButtonType.outline,
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                AppButton(
                  text: confirmText,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) onConfirm();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
