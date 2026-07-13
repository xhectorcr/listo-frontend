import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool hasShadow;
  final bool hasBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.hasShadow = true,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: AppRadius.largeRadius,
        border: hasBorder ? Border.all(color: AppColors.border, width: 1) : null,
        boxShadow: hasShadow ? AppShadows.small : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.largeRadius,
          child: cardContent,
        ),
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
