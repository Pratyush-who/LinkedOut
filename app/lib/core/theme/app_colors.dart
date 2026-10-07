import 'package:flutter/material.dart';

class AppColors {
  // Primary Dark Palette
  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF161A22);
  static const Color surfaceLight = Color(0xFF1E232E);
  static const Color surfaceElevated = Color(0xFF262C3A);
  
  // Clean Light Theme Options (if needed)
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Accent & Brand Colors
  static const Color primary = Color(0xFF7C3AED); // Modern Electric Violet
  static const Color primaryLight = Color(0xFFB398EB);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color secondary = Color(0xFF06B6D4); // Cyan

  // Trading & Financial Semantic Colors
  static const Color green = Color(0xFF10B981); // Profit Green
  static const Color greenLight = Color(0xFFD1FAE5);
  static const Color greenGlow = Color(0x3310B981);
  
  static const Color red = Color(0xFFEF4444); // Loss Red
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color redGlow = Color(0x33EF4444);

  static const Color warning = Color(0xFFF59E0B);
  static const Color purpleLight = Color(0xFFE2CCFF);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color offWhite = Color(0xFFF9F9F9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E232E), Color(0xFF161A22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGoldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
