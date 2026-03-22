import 'package:flutter/material.dart';

class AppColors {
  // === Background layers ===
  static const scaffoldBg      = Color(0xFFF0F4F8); // Overall background: light blue-gray
  static const surfaceWhite    = Color(0xFFFFFFFF); // Card / input field surface
  static const surfaceGray     = Color(0xFFF8FAFC); // Secondary surface (original text area background)

  // === Primary color: blue (actions / optimized results) ===
  static const primary         = Color(0xFF2563EB);
  static const primaryLight    = Color(0xFFEFF6FF);
  static const primaryBorder   = Color(0xFFBFDBFE);
  static const primaryGradientStart = Color(0xFF1D4ED8);
  static const primaryGradientEnd   = Color(0xFF3B82F6);

  // === Accent color: sky blue (user bubbles) ===
  static const userBubble      = Color(0xFF0EA5E9); // sky-500, warm tone
  static const userBubbleLight = Color(0xFFE0F2FE);

  // === Translation area: purple ===
  static const translation     = Color(0xFF7C3AED);
  static const translationLight= Color(0xFFF5F3FF);
  static const translationBorder= Color(0xFFDDD6FE);

  // === Neutral ===
  static const originalText    = Color(0xFF64748B);
  static const originalBg     = Color(0xFFF8FAFC);
  static const originalBorder  = Color(0xFFE2E8F0);
  static const divider         = Color(0xFFE2E8F0);

  // === Semantic colors ===
  static const success    = Color(0xFF059669);
  static const successBg  = Color(0xFFECFDF5);
  static const error      = Color(0xFFDC2626);
  static const errorBg    = Color(0xFFFEF2F2);
  static const warning    = Color(0xFFF59E0B);
  static const warningBg  = Color(0xFFFFFBEB);

  // === Recording state ===
  static const recording     = Color(0xFFDC2626);
  static const recordingRing = Color(0xFFFEE2E2);

  // === Text hierarchy ===
  static const textPrimary   = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const textHint      = Color(0xFF94A3B8);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // === Favorite ===
  static const favorite      = Color(0xFFF59E0B);
}
