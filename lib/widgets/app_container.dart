import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool useSafeArea;
  final double? maxWidth;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.useSafeArea = true,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      color: backgroundColor ?? AppColors.background,
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );

    if (useSafeArea) {
      return SafeArea(child: content);
    }

    return content;
  }
}
