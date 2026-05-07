import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Electric Purple
  static const primary = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFF9D62F5);
  static const primaryDark = Color(0xFF5B21B6);

  // Accent - Neon Yellow
  static const accent = Color(0xFFFFD60A);
  static const accentOrange = Color(0xFFFF6B35);

  // Background
  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF12121A);
  static const surfaceLight = Color(0xFF1C1C28);
  static const card = Color(0xFF16162A);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0CC);
  static const textMuted = Color(0xFF6B6B8A);

  // Status
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Game Colors
  static const optionA = Color(0xFF3B82F6);
  static const optionB = Color(0xFF10B981);
  static const optionC = Color(0xFFF59E0B);
  static const optionD = Color(0xFFEF4444);

  static const correctAnswer = Color(0xFF10B981);
  static const wrongAnswer = Color(0xFFEF4444);

  // ELO / Rank Colors
  static const rankBronze = Color(0xFFCD7F32);
  static const rankSilver = Color(0xFFC0C0C0);
  static const rankGold = Color(0xFFFFD700);
  static const rankDiamond = Color(0xFF00E5FF);
  static const rankMaster = Color(0xFFFF4081);

  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAccent = LinearGradient(
    colors: [Color(0xFFFFD60A), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF12121A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientCard = LinearGradient(
    colors: [Color(0xFF1C1C2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
