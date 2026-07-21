import 'package:flutter/material.dart';

/// ExpiryVault brand palette, taken directly from the brand board.
/// Kept as a single source of truth so screens never hardcode hex values.
class AppColors {
  AppColors._();

  static const Color vaultBlue = Color(0xFF4A7FC9);
  static const Color freshGreen = Color(0xFF5FAE58);
  static const Color sunshineYellow = Color(0xFFF4C542);
  static const Color tomatoRed = Color(0xFFE85C4A);
  static const Color grapePurple = Color(0xFF8B6FC9);
  static const Color peach = Color(0xFFF2A488);
  static const Color cream = Color(0xFFFDF8EF);
  static const Color charcoal = Color(0xFF2B2B2B);

  // Status tints (light backgrounds behind status badges/cards).
  static const Color freshBg = Color(0xFFEAF3DE);
  static const Color freshText = Color(0xFF27500A);

  static const Color expiringBg = Color(0xFFFAEEDA);
  static const Color expiringText = Color(0xFF633806);

  static const Color expiredBg = Color(0xFFFCEBEB);
  static const Color expiredText = Color(0xFF791F1F);

  static const Color neutralGrey = Color(0xFF5F5E5A);
  static const Color divider = Color(0xFFD3D1C7);
}
