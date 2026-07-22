import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Brand typography: Baloo 2 for chunky rounded headings, Nunito for
/// legible body/data text (expiry dates and quantities must stay unmistakable).
class AppTextTheme {
  AppTextTheme._();

  static TextTheme build() {
    final base = TextTheme(
      displaySmall: GoogleFonts.baloo2(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      headlineMedium: GoogleFonts.baloo2(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      headlineSmall: GoogleFonts.baloo2(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      titleLarge: GoogleFonts.baloo2(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.charcoal,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.charcoal,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.neutralGrey,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
    );
    return base;
  }
}
