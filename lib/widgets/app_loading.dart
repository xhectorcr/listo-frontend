import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoading({
    super.key,
    this.color,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}
