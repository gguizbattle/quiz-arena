import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      ('xXProQuizXx', 2100, 142, '🥇'),
      ('NightOwl99', 1980, 127, '🥈'),
      ('BrainMaster', 1875, 98, '🥉'),
      ('QuizKing', 1820, 89, '4'),
      ('SmartAlex', 1770, 76, '5'),
      ('ThinkFast', 1720, 71, '6'),
      ('QuizWiz', 1680, 65, '7'),
      ('Player123', 1425, 47, '8'),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Leaderboard', style: AppTextStyles.headlineLarge).animate().fadeIn(),
                    const SizedBox(height: 20),
                    _buildTopThree(players.take(3).toList()),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: players.length - 3,
                  itemBuilder: (_, i) {
                    final p = players[i + 3];
                    final isMe = p.$1 == 'Player123';
                    return _buildRow(p.$4, p.$1, p.$2, p.$3, isMe, i);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopThree(List players) {
    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodium(players[1].$1, players[1].$2, '🥈', 110, AppColors.rankSilver),
          const SizedBox(width: 8),
          _buildPodium(players[0].$1, players[0].$2, '🥇', 150, AppColors.rankGold),
          const SizedBox(width: 8),
          _buildPodium(players[2].$1, players[2].$2, '🥉', 90, AppColors.rankBronze),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildPodium(String name, int elo, String medal, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(medal, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.bodySmall.copyWith(color: color), overflow: TextOverflow.ellipsis),
        Text('$elo', style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: height * 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withOpacity(0.6), color.withOpacity(0.2)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String rank, String name, int elo, int wins, bool isMe, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withOpacity(0.15) : AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isMe ? AppColors.primary : const Color(0xFF2A2A40)),
      ),
      child: Row(
        children: [
          SizedBox(width: 28, child: Text(rank, style: AppTextStyles.titleMedium, textAlign: TextAlign.center)),
          const SizedBox(width: 12),
          CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceLight, child: Text(name[0], style: const TextStyle(color: AppColors.textPrimary))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name${isMe ? ' (You)' : ''}', style: AppTextStyles.titleMedium.copyWith(color: isMe ? AppColors.primaryLight : AppColors.textPrimary)),
                Text('$wins wins', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.military_tech, color: AppColors.rankGold, size: 16),
              const SizedBox(width: 4),
              Text('$elo', style: AppTextStyles.labelLarge.copyWith(color: AppColors.rankGold)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 + index * 80)).slideX(begin: 0.1);
  }
}
