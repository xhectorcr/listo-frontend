import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.headlineSmall,
      ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
