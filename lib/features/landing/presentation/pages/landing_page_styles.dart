import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadows.dart';
class LandingStyles {
  // =========================
  // COLORS
  // =========================
  static const Color primaryColor = AppColors.primary;
  static const Color scaffoldBackground = AppColors.background;
  static const Color darkBackground = AppColors.textPrimary;
  static const Color stepCardBackground = AppColors.surface;
  static const Color locationCardBackground = AppColors.surface;

  // =========================
  // TEXT STYLES
  // =========================
  
  // Navbar
  static TextStyle logoTextStyle = AppTextStyles.titleLarge.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.w800,
  );
  static TextStyle brandTextStyle = AppTextStyles.headlineSmall.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
  );
  static TextStyle loginButtonTextStyle = AppTextStyles.labelLarge.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  // Hero Section
  static TextStyle heroBadgeTextStyle = AppTextStyles.labelMedium.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );
  static TextStyle heroTitleMobileStyle = AppTextStyles.displaySmall.copyWith(
    height: 1.05,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );
  static TextStyle heroTitleDesktopStyle = AppTextStyles.displayLarge.copyWith(
    height: 1.05,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );
  static TextStyle heroDescMobileStyle = AppTextStyles.bodyLarge.copyWith(
    height: 1.7,
    color: AppColors.textSecondary,
  );
  static TextStyle heroDescDesktopStyle = AppTextStyles.titleMedium.copyWith(
    height: 1.7,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.normal,
  );
  static TextStyle heroButtonTextStyle = AppTextStyles.labelLarge.copyWith(
    fontWeight: FontWeight.bold,
  );
  
  // Stats
  static TextStyle heroStatValueStyle = AppTextStyles.headlineMedium.copyWith(
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );
  static TextStyle heroStatLabelStyle = AppTextStyles.labelMedium.copyWith(
    color: AppColors.textSecondary,
  );

  // Section Wrapper
  static TextStyle sectionTitleDarkStyle = AppTextStyles.displaySmall.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.w800,
  );
  static TextStyle sectionTitleLightStyle = AppTextStyles.displaySmall.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
  );
  static TextStyle sectionSubtitleDarkStyle = AppTextStyles.titleMedium.copyWith(
    color: AppColors.textDisabled,
    fontWeight: FontWeight.normal,
  );
  static TextStyle sectionSubtitleLightStyle = AppTextStyles.titleMedium.copyWith(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.normal,
  );

  // Benefit Card
  static TextStyle benefitCardTitleStyle = AppTextStyles.titleLarge.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Step Card
  static TextStyle stepCardStepStyle = AppTextStyles.headlineLarge.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.w800,
  );
  static TextStyle stepCardTitleStyle = AppTextStyles.titleLarge.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );
  static TextStyle stepCardDescStyle = AppTextStyles.bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );
  static TextStyle stepCardRichDescStyle = AppTextStyles.bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );
  static TextStyle stepCardLinkStyle = AppTextStyles.bodyMedium.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  // Product Card
  static TextStyle productCardTitleStyle = AppTextStyles.titleLarge.copyWith(
    fontWeight: FontWeight.w700,
  );
  static TextStyle productCardPriceStyle = AppTextStyles.titleLarge.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.bold,
  );

  // Discount Card
  static TextStyle discountCardTitleStyle = AppTextStyles.headlineMedium.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.w800,
  );
  static TextStyle discountCardDescStyle = AppTextStyles.titleMedium.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.normal,
  );

  // Tech Chip
  static TextStyle techChipStyle = AppTextStyles.labelMedium.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.w600,
  );

  // Big Stat
  static TextStyle bigStatValueStyle = AppTextStyles.displayMedium.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.w800,
  );
  static TextStyle bigStatLabelStyle = AppTextStyles.titleMedium.copyWith(
    color: AppColors.textSecondary,
  );

  // Location Card
  static TextStyle locationCardCityStyle = AppTextStyles.titleLarge.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  // Stat Item
  static TextStyle statItemValueStyle = AppTextStyles.headlineLarge.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.w800,
  );
  static TextStyle statItemLabelStyle = AppTextStyles.bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );

  // Footer
  static TextStyle footerLogoStyle = AppTextStyles.headlineMedium.copyWith(
    color: AppColors.textInverse,
    fontWeight: FontWeight.w800,
  );
  static TextStyle footerSubtitleStyle = AppTextStyles.bodyMedium.copyWith(
    color: AppColors.textDisabled,
  );
  static TextStyle footerItemStyle = AppTextStyles.bodyMedium.copyWith(
    color: AppColors.textDisabled,
  );

  // =========================
  // DECORATIONS
  // =========================
  
  static BoxDecoration navbarLogoDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: AppRadius.mediumRadius,
  );

  static BoxDecoration navbarBlurBorderDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(color: AppColors.border),
    ),
  );

  static const BoxDecoration heroBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.surface, AppColors.background],
    ),
  );

  static BoxDecoration heroBadgeDecoration = BoxDecoration(
    color: primaryColor.withOpacity(0.1),
    borderRadius: AppRadius.circularRadius,
  );

  static BoxDecoration heroImageBackgroundDecoration = BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [
        primaryColor.withOpacity(0.15),
        primaryColor.withOpacity(0.02),
      ],
    ),
  );

  static BoxDecoration heroImageFallbackDecoration = BoxDecoration(
    color: AppColors.disabled,
    borderRadius: BorderRadius.circular(35),
  );

  static BoxDecoration heroStatDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.extraLargeRadius,
    boxShadow: AppShadows.large,
  );

  static BoxDecoration benefitCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.extraLargeRadius,
    boxShadow: AppShadows.large,
  );

  static BoxDecoration stepCardDecoration = BoxDecoration(
    color: stepCardBackground,
    borderRadius: AppRadius.extraLargeRadius,
    boxShadow: AppShadows.small,
  );

  static BoxDecoration productCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.extraLargeRadius,
    boxShadow: AppShadows.large,
  );

  static BoxDecoration discountCardDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primary, AppColors.secondary],
    ),
    borderRadius: AppRadius.extraLargeRadius,
  );

  static BoxDecoration techChipDecoration = BoxDecoration(
    color: AppColors.surface.withOpacity(0.1),
    borderRadius: AppRadius.circularRadius,
  );

  static BoxDecoration locationCardDecoration = BoxDecoration(
    color: locationCardBackground,
    borderRadius: AppRadius.extraLargeRadius,
  );
  
  // =========================
  // BUTTON STYLES
  // =========================
  
  static ButtonStyle heroButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: AppColors.textInverse,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: 34,
      vertical: 22,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.largeRadius,
    ),
  );
}
