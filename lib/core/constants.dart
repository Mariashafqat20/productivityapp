import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB); // Royal Blue (Master Prompt)
  static const Color secondary = Color(0xFF3F37C9);
  static const Color accent = Color(0xFF4895EF);
  static const Color neutral = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF212529);
  static const Color textLight = Color(0xFF6C757D);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFFE9ECEF);
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2A9D8F);
}

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.textLight,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
