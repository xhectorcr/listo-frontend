import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core colors - Modernized Orange
  static const Color primary = Color(0xFFFF512F); // Vibrant Sunset Orange
  static const Color primaryDark = Color(0xFFDD2476); // For gradient (Sunset to pink/red)
  static const Color secondary = Color(0xFF0F172A); // Slate 900 for premium contrast
  static const Color accent = Color(0xFFFF8A33); // Lighter orange tone
  
  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color glassSurface = Color(0xB3FFFFFF); // 70% opacity white for glass
  
  // Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // Interactive
  static const Color disabled = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFF1F5F9);
}
