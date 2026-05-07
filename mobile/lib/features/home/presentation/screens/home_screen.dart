import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStatRow(),
                const SizedBox(height: 28),
                _buildSectionTitle('Quick Play'),
                const SizedBox(height: 14),
                _buildQuickPlayCards(context),
                const SizedBox(height: 28),
                _buildSectionTitle('Daily Challenge'),
                const SizedBox(height: 14),
                _buildDailyChallenge(),
                const SizedBox(height: 28),
                _buildSectionTitle('Top Players'),
                const SizedBox(height: 14),
                _buildTopPlayers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning,', style: AppTextStyles.bodyMedium),
            Text('Player123', style: AppTextStyles.headlineLarge),
          ],
        ).animate().fadeIn().slideX(begin: -0.2),
        Row(
          children: [
            _buildCoinBadge(),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: const Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ).animate().fadeIn().slideX(begin: 0.2),
      ],
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: AppColors.accent, size: 16),
          const SizedBox(width: 4),
          Text('1,250', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('1,425', 'ELO', Icons.military_tech, AppColors.rankGold),
          _buildDivider(),
          _buildStat('47', 'Wins', Icons.emoji_events, AppColors.success),
          _buildDivider(),
          _buildStat('Level 8', 'Rank', Icons.star, AppColors.primaryLight),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: color)),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: AppColors.surfaceLight);
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.titleLarge);
  }

  Widget _buildQuickPlayCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGameCard(
            title: 'Solo Quiz',
            subtitle: 'Practice alone',
            icon: Icons.quiz_rounded,
            gradient: AppColors.gradientPrimary,
            onTap: () => context.go('/quiz'),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGameCard(
            title: '1v1 Battle',
            subtitle: 'Challenge players',
            icon: Icons.sports_esports_rounded,
            gradient: AppColors.gradientAccent,
            textColor: Colors.black,
            onTap: () => context.go('/battle'),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2),
        ),
      ],
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: textColor, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium.copyWith(color: textColor)),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: textColor.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.gradientAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.black, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Challenge', style: AppTextStyles.titleMedium),
                Text('10 questions • Mixed • 500 coins', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.gradientAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Play', style: AppTextStyles.labelLarge.copyWith(color: Colors.black)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2);
  }

  Widget _buildTopPlayers() {
    final players = [
      ('xXProQuizXx', 2100, '🥇'),
      ('NightOwl99', 1980, '🥈'),
      ('BrainMaster', 1875, '🥉'),
    ];
    return Column(
      children: players.asMap().entries.map((e) {
        final (name, elo, medal) = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A40)),
          ),
          child: Row(
            children: [
              Text(medal, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: AppTextStyles.titleMedium)),
              Row(
                children: [
                  const Icon(Icons.military_tech, color: AppColors.rankGold, size: 16),
                  const SizedBox(width: 4),
                  Text('$elo', style: AppTextStyles.labelLarge.copyWith(color: AppColors.rankGold)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 600 + e.key * 100)).slideX(begin: 0.1);
      }).toList(),
    );
  }
}
