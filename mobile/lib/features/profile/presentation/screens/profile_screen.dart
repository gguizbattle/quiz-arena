import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildStatsGrid(),
                const SizedBox(height: 20),
                _buildAchievements(),
                const SizedBox(height: 20),
                _buildRecentMatches(),
                const SizedBox(height: 20),
                _buildSettings(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        border: Border(bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.2))),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20)],
                ),
                child: const Center(child: Text('P', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle, border: Border.all(color: AppColors.background, width: 2)),
                  child: const Icon(Icons.edit, size: 14, color: Colors.black),
                ),
              ),
            ],
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 14),
          Text('Player123', style: AppTextStyles.headlineMedium).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.rankGold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.rankGold.withValues(alpha: 0.4))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech, color: AppColors.rankGold, size: 14),
                    const SizedBox(width: 4),
                    Text('Gold II', style: AppTextStyles.bodySmall.copyWith(color: AppColors.rankGold, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat('Level 8', 'Level', AppColors.primaryLight),
              _buildHeaderStat('1,425', 'ELO', AppColors.rankGold),
              _buildHeaderStat('1,250', 'Coins', AppColors.accent),
            ],
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: [
          _buildStatCard('47', 'Total Wins', Icons.emoji_events, AppColors.success),
          _buildStatCard('12', 'Losses', Icons.close, AppColors.error),
          _buildStatCard('24,500', 'Total XP', Icons.star, AppColors.accent),
          _buildStatCard('80%', 'Win Rate', Icons.trending_up, AppColors.primary),
        ],
      ).animate().fadeIn(delay: 300.ms),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.headlineMedium.copyWith(color: color)),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      ('First Win', '🏆', true),
      ('10 Wins', '⚡', true),
      ('Speed Demon', '🚀', true),
      ('50 Wins', '👑', false),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final (name, emoji, unlocked) = achievements[i];
                return Container(
                  width: 78,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.card : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: unlocked ? AppColors.accent.withValues(alpha: 0.4) : const Color(0xFF2A2A40)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: TextStyle(fontSize: 26, color: unlocked ? null : Colors.transparent, shadows: unlocked ? null : const [Shadow(color: Colors.grey, blurRadius: 0)])),
                      const SizedBox(height: 4),
                      Text(name, style: AppTextStyles.bodySmall.copyWith(color: unlocked ? AppColors.textSecondary : AppColors.textMuted), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ).animate().fadeIn(delay: 400.ms),
    );
  }

  Widget _buildRecentMatches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Matches', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          ...['Win vs NightOwl99', 'Win vs QuizKing', 'Loss vs xXProQuizXx'].asMap().entries.map((e) {
            final isWin = e.value.startsWith('Win');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isWin ? AppColors.success.withValues(alpha: 0.3) : AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(isWin ? Icons.emoji_events : Icons.close, color: isWin ? AppColors.success : AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
                  Text(isWin ? '+25 ELO' : '-18 ELO', style: AppTextStyles.bodySmall.copyWith(color: isWin ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }),
        ],
      ).animate().fadeIn(delay: 500.ms),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          _buildSettingsTile(Icons.notifications_outlined, 'Notifications', () {}),
          _buildSettingsTile(Icons.language, 'Language', () {}),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
          _buildSettingsTile(Icons.logout, 'Logout', () => context.go('/login'), color: AppColors.error),
        ],
      ).animate().fadeIn(delay: 600.ms),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {Color color = AppColors.textPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2A2A40))),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: color))),
            Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }
}

