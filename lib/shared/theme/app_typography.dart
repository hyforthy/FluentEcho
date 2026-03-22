import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const appBarTitle = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 18, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );

  static const resultBody = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 17, height: 1.65,
    fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );

  static const cardLabel = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 11, fontWeight: FontWeight.w600,
    letterSpacing: 0.8, color: AppColors.textSecondary,
  );

  static const inputBody = TextStyle(
    fontSize: 16, height: 1.55, color: AppColors.textPrimary,
  );

  static const noteTitle = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 15, height: 1.5, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const noteSubtitle = TextStyle(
    fontSize: 13, height: 1.4, color: AppColors.textSecondary,
  );

  static const sectionHeader = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12, fontWeight: FontWeight.w600,
    letterSpacing: 1.0, color: AppColors.textSecondary,
  );

  static const inputHint = TextStyle(
    fontSize: 16, height: 1.55, color: AppColors.textHint,
  );
}
