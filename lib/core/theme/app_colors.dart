import 'package:flutter/material.dart';

/// Official CareerPulse Color Palette
/// Strictly adhering to the specified design requirements.
class AppColors {
  AppColors._();

  // Official primary palette
  static const Color darkNavy = Color(0xFF172C43);
  static const Color deepBlue = Color(0xFF245B86);
  static const Color primaryBlue = Color(0xFF078AC4);
  static const Color teal = Color(0xFF12A69B);
  static const Color lightBlueBackground = Color(0xFFF2F7FC);
  static const Color white = Color(0xFFFFFFFF);

  // Typography colors
  static const Color primaryText = Color(0xFF1C2D40);
  static const Color secondaryText = Color(0xFF46576A);
  static const Color mutedText = Color(0xFF7A8B9E);

  // Borders & Dividers
  static const Color border = Color(0xFFE0E8F0);
  static const Color cardBorder = Color(0xFFD6E2ED);

  // Functional / Status colors
  static const Color success = Color(0xFF12A69B);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBackground = Color(0xFFFEE2E2);
  static const Color matchedBackground = Color(0xFFE6F7F5);
  static const Color partialBackground = Color(0xFFFEF9C3);
  static const Color gapBackground = Color(0xFFFEE2E2);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryBlue, teal],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFEAF4FC), Color(0xFFE6F7F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
