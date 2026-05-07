import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tournaments = [
      ('Daily Championship', '🏆', 'Starts in 02:45', 256, 5000, AppColors.gradientTournament, true),
      ('Weekend Royale', '👑', 'Starts in 1d 08h', 512, 15000, AppColors.gradientBattleRoyale, false),
      ('Speed Quiz Blitz', '⚡', 'Live Now', 128, 3000, AppColors.gradientPrimary, true),
      ('Knowledge Masters', '🧠', 'Starts in 3d 12h', 64, 8000, AppColors.gradientCyan, false),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tournaments', style: AppTextStyles.headlineLarge).animate().fadeIn(),
                  const SizedBox(height: 4),
                  Text('Compete for glory and rewards', style: AppTextStyles.bodyMedium).animate().fadeIn(delay: 100.ms),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Filter tabs
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['All', 'Live', 'Upcoming', 'My Entries'].asMap().entries.map((e) {
                  final selected = e.key == 0;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : const Color(0xFF2A2A50)),
                    ),
                    alignment: Alignment.center,
                    child: Text(e.value, style: AppTextStyles.bodySmall.copyWith(color: selected ? Colors.white : AppColors.textMuted, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: tournaments.length,
                itemBuilder: (_, i) {
                  final (name, emoji, time, players, prize, gradient, live) = tournaments[i];
                  return _buildTournamentCard(name, emoji, time, players, prize, gradient, live, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentCard(String name, String emoji, String time, int players, int prize, LinearGradient gradient, bool live, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2A50)),
      ),
      child: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                if (live)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                Center(child: Text(emoji, style: const TextStyle(fontSize: 44))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: AppColors.textMuted, size: 13),
                          const SizedBox(width: 4),
                          Text(time, style: AppTextStyles.bodySmall),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_outline, color: AppColors.textMuted, size: 13),
                          const SizedBox(width: 4),
                          Text('$players players', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text('${(prize / 1000).toStringAsFixed(0)}k coins prize', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Join', style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 200 + index * 100)).slideY(begin: 0.1);
  }
}
