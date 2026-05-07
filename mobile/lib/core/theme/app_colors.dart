import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // GLIC Primary - Electric Purple
  static const primary = Color(0xFF7B5CFF);
  static const primaryLight = Color(0xFF9B82FF);
  static const primaryDark = Color(0xFF5A3ED9);

  // GLIC Neon Accents
  static const cyan = Color(0xFF00E5FF);
  static const pink = Color(0xFFFF3ED1);
  static const gold = Color(0xFFFFD400);

  // Alias for existing usage
  static const accent = Color(0xFFFFD400);
  static const accentOrange = Color(0xFFFF8C00);

  // Background
  static const background = Color(0xFF0D0E13);
  static const surface = Color(0xFF131520);
  static const surfaceLight = Color(0xFF1E2030);
  static const card = Color(0xFF1A1B2E);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B8D1);
  static const textMuted = Color(0xFF6B7090);

  // Status
  static const success = Color(0xFF00E096);
  static const error = Color(0xFFFF4560);
  static const warning = Color(0xFFFFD400);
  static const info = Color(0xFF00E5FF);

  // Game Option Colors
  static const optionA = Color(0xFF7B5CFF);
  static const optionB = Color(0xFF00E5FF);
  static const optionC = Color(0xFFFF3ED1);
  static const optionD = Color(0xFFFFD400);

  static const correctAnswer = Color(0xFF00E096);
  static const wrongAnswer = Color(0xFFFF4560);

  // Rank Colors
  static const rankBronze = Color(0xFFCD7F32);
  static const rankSilver = Color(0xFFC0C0C0);
  static const rankGold = Color(0xFFFFD400);
  static const rankDiamond = Color(0xFF00E5FF);
  static const rankMaster = Color(0xFFFF3ED1);

  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF7B5CFF), Color(0xFF4A2ADB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientCyan = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0099AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientPink = LinearGradient(
    colors: [Color(0xFFFF3ED1), Color(0xFFAA0088)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientGold = LinearGradient(
    colors: [Color(0xFFFFD400), Color(0xFFCC8800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAccent = LinearGradient(
    colors: [Color(0xFFFFD400), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF0D0E13), Color(0xFF131520)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientCard = LinearGradient(
    colors: [Color(0xFF1E2040), Color(0xFF141628)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientTournament = LinearGradient(
    colors: [Color(0xFF3A1FA8), Color(0xFF7B5CFF), Color(0xFF4A1AC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBattleRoyale = LinearGradient(
    colors: [Color(0xFF8B6000), Color(0xFFFFD400)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBattle = LinearGradient(
    colors: [Color(0xFF1A2040), Color(0xFF2A3060)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
