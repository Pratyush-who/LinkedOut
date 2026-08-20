import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.black,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: AppColors.black,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: AppColors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: AppColors.black, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: AppColors.black, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ), // sharp corners for minimalist block
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        hintStyle: GoogleFonts.inter(color: AppColors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 2),
        ),
      ),
    );
  }
}
