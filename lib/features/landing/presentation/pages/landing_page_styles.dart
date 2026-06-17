import 'package:flutter/material.dart';

class LandingStyles {
  // =========================
  // COLORS
  // =========================
  static const Color primaryColor = Color(0xFFFF5A1F);
  static const Color scaffoldBackground = Color(0xFFF8F9FA);
  static const Color darkBackground = Color(0xFF111111);
  static const Color stepCardBackground = Color(0xFF1A1A1A);
  static const Color locationCardBackground = Color(0xFF1A1A1A);

  // =========================
  // TEXT STYLES
  // =========================
  
  // Navbar
  static const TextStyle logoTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );
  static const TextStyle brandTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
  );
  static const TextStyle loginButtonTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  // Hero Section
  static const TextStyle heroBadgeTextStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    fontSize: 12,
  );
  static TextStyle heroTitleMobileStyle = const TextStyle(
    fontSize: 38,
    height: 1.05,
    fontWeight: FontWeight.w900,
    color: Color(0xFF111111),
  );
  static TextStyle heroTitleDesktopStyle = const TextStyle(
    fontSize: 64,
    height: 1.05,
    fontWeight: FontWeight.w900,
    color: Color(0xFF111111),
  );
  static TextStyle heroDescMobileStyle = TextStyle(
    fontSize: 16,
    height: 1.7,
    color: Colors.grey.shade700,
  );
  static TextStyle heroDescDesktopStyle = TextStyle(
    fontSize: 18,
    height: 1.7,
    color: Colors.grey.shade700,
  );
  static const TextStyle heroButtonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  
  // Stats
  static const TextStyle heroStatValueStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: Color(0xFF111111),
  );
  static TextStyle heroStatLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade700,
  );

  // Section Wrapper
  static TextStyle sectionTitleDarkStyle = const TextStyle(
    color: Colors.white,
    fontSize: 42,
    fontWeight: FontWeight.w800,
  );
  static TextStyle sectionTitleLightStyle = const TextStyle(
    color: Colors.black,
    fontSize: 42,
    fontWeight: FontWeight.w800,
  );
  static TextStyle sectionSubtitleDarkStyle = TextStyle(
    color: Colors.grey.shade400,
    fontSize: 18,
  );
  static TextStyle sectionSubtitleLightStyle = TextStyle(
    color: Colors.grey.shade700,
    fontSize: 18,
  );

  // Benefit Card
  static const TextStyle benefitCardTitleStyle = TextStyle(
    fontWeight: FontWeight.w700, 
    fontSize: 18,
  );

  // Step Card
  static const TextStyle stepCardStepStyle = TextStyle(
    color: primaryColor,
    fontSize: 30,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle stepCardTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
  static const TextStyle stepCardDescStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static TextStyle stepCardRichDescStyle = TextStyle(
    color: Colors.grey[400],
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: 'sans-serif'
  );
  static const TextStyle stepCardLinkStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  // Product Card
  static const TextStyle productCardTitleStyle = TextStyle(
    fontWeight: FontWeight.w700, 
    fontSize: 18,
  );
  static const TextStyle productCardPriceStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  // Discount Card
  static const TextStyle discountCardTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 28,
  );
  static const TextStyle discountCardDescStyle = TextStyle(
    color: Colors.white, 
    fontSize: 17,
  );

  // Tech Chip
  static const TextStyle techChipStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // Big Stat
  static const TextStyle bigStatValueStyle = TextStyle(
    color: primaryColor,
    fontSize: 52,
    fontWeight: FontWeight.w800,
  );
  static TextStyle bigStatLabelStyle = TextStyle(
    color: Colors.grey.shade700, 
    fontSize: 16,
  );

  // Location Card
  static const TextStyle locationCardCityStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );

  // Stat Item
  static const TextStyle statItemValueStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w800,
    fontSize: 32,
  );
  static TextStyle statItemLabelStyle = TextStyle(
    color: Colors.grey.shade700,
  );

  // Footer
  static const TextStyle footerLogoStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 30,
  );
  static TextStyle footerSubtitleStyle = TextStyle(
    color: Colors.grey.shade500,
  );
  static TextStyle footerItemStyle = TextStyle(
    color: Colors.grey.shade400,
  );

  // =========================
  // DECORATIONS
  // =========================
  
  static BoxDecoration navbarLogoDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.circular(14),
  );

  static BoxDecoration navbarBlurBorderDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
    ),
  );

  static const BoxDecoration heroBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFFFF4EF)],
    ),
  );

  static BoxDecoration heroBadgeDecoration = BoxDecoration(
    color: primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(100),
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
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(35),
  );

  static BoxDecoration heroStatDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration benefitCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 25,
        offset: const Offset(0, 15),
      ),
    ],
  );

  static BoxDecoration stepCardDecoration = BoxDecoration(
    color: stepCardBackground,
    borderRadius: BorderRadius.circular(25),
  );

  static BoxDecoration productCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 25,
        offset: const Offset(0, 15),
      ),
    ],
  );

  static BoxDecoration discountCardDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFFFF5A1F), Color(0xFFFF7A1F)],
    ),
    borderRadius: BorderRadius.circular(28),
  );

  static BoxDecoration techChipDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.06),
    borderRadius: BorderRadius.circular(50),
  );

  static BoxDecoration locationCardDecoration = BoxDecoration(
    color: locationCardBackground,
    borderRadius: BorderRadius.circular(28),
  );
  
  // =========================
  // BUTTON STYLES
  // =========================
  
  static ButtonStyle heroButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: 34,
      vertical: 22,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  );
}
