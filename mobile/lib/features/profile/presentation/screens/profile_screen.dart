import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gguiz_battle/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/local_game_stats_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../home/data/user_repository.dart';
import '../../../home/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);
    final localStats = ref.watch(localGameStatsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.errorMessage(e.toString()), style: AppTextStyles.bodyMedium)),
            data: (profile) {
              final totalCoins = profile.coins + localStats.bonusCoins;
              final totalXp = profile.xp + localStats.bonusXp;
              final totalWins = profile.wins + localStats.extraWins;
              final totalLosses = profile.losses + localStats.extraLosses;
              final totalGames = totalWins + totalLosses;
              final winRate = totalGames == 0 ? 0.0 : totalWins / totalGames;
              final effectiveLevel = UserProfile.levelFromXp(totalXp);
              return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, ref, l10n, profile.username, effectiveLevel, totalXp, profile.elo, totalCoins),
                  _buildStatsGrid(l10n, totalWins, totalLosses, totalXp, winRate),
                  const SizedBox(height: 20),
                  _buildAchievements(l10n),
                  const SizedBox(height: 20),
                  _buildRecentMatches(l10n),
                  const SizedBox(height: 20),
                  _buildSettings(context, ref, l10n),
                  const SizedBox(height: 30),
                ],
              ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AppLocalizations l10n, String username, int level, int totalXp, int elo, int coins) {
    String rankLabel(int elo) {
      if (elo >= 2000) return l10n.rankDiamond;
      if (elo >= 1600) return l10n.rankPlatinum;
      if (elo >= 1400) return l10n.rankGoldII;
      if (elo >= 1200) return l10n.rankSilver;
      return l10n.rankBronze;
    }

    final isMaxLevel = level >= UserProfile.maxLevel;
    final progress = UserProfile.progressForXp(totalXp);
    final xpInLevel = UserProfile.xpInLevel(totalXp);
    final xpNeeded = UserProfile.xpToAdvance(level);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        border: Border(bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.2))),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: isMaxLevel ? AppColors.gold : AppColors.primary, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20)],
                ),
                child: Center(
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: isMaxLevel ? AppColors.gold : AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: Text(
                      isMaxLevel ? '$level ${l10n.maxLevelBadge}' : 'Lv. $level',
                      style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 14),
          Text(username, style: AppTextStyles.headlineMedium).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.rankGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.rankGold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech, color: AppColors.rankGold, size: 14),
                    const SizedBox(width: 4),
                    Text(rankLabel(elo), style: AppTextStyles.bodySmall.copyWith(color: AppColors.rankGold, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat(
                isMaxLevel ? 'Lv. $level ${l10n.maxLevelBadge}' : 'Lv. $level',
                l10n.levelLabel,
                isMaxLevel ? AppColors.gold : AppColors.primaryLight,
              ),
              _buildHeaderStat('$elo', l10n.eloLabel, AppColors.rankGold),
              _buildHeaderStat('$coins', l10n.coinsLabel, AppColors.accent),
            ],
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                isMaxLevel ? AppColors.gold : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isMaxLevel
                ? '$totalXp XP'
                : '$xpInLevel / $xpNeeded XP',
            style: AppTextStyles.bodySmall,
          ),
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

  Widget _buildStatsGrid(AppLocalizations l10n, int wins, int losses, int xp, double winRate) {
    final winPct = '${(winRate * 100).toStringAsFixed(0)}%';
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
          _buildStatCard('$wins', l10n.totalWins, Icons.emoji_events, AppColors.success),
          _buildStatCard('$losses', l10n.losses, Icons.close, AppColors.error),
          _buildStatCard('$xp', l10n.totalXP, Icons.star, AppColors.accent),
          _buildStatCard(winPct, l10n.winRate, Icons.trending_up, AppColors.primary),
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

  Widget _buildAchievements(AppLocalizations l10n) {
    final achievements = [
      (l10n.achievementFirstWin, '🏆', true),
      (l10n.achievementTenWins, '⚡', false),
      (l10n.achievementSpeedDemon, '🚀', false),
      (l10n.achievementFiftyWins, '👑', false),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.achievementsTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final (name, emoji, unlocked) = achievements[i];
                return Container(
                  width: 78,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.card : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: unlocked ? AppColors.accent.withValues(alpha: 0.4) : const Color(0xFF2A2A40)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emoji,
                        style: TextStyle(
                          fontSize: 24,
                          color: unlocked ? null : Colors.transparent,
                          shadows: unlocked ? null : const [Shadow(color: Colors.grey, blurRadius: 0)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          name,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: unlocked ? AppColors.textSecondary : AppColors.textMuted,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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

  Widget _buildRecentMatches(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.recentMatchesTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A2A40)),
            ),
            child: Center(
              child: Text(l10n.matchHistorySoon, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 500.ms),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settingsTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          _buildSettingsTile(Icons.notifications_outlined, l10n.notificationsLabel, () {}),
          _buildSettingsTile(Icons.language, l10n.languageLabel, () => showLanguageSelector(context, ref)),
          _buildSettingsTile(Icons.privacy_tip_outlined, l10n.privacyPolicyLabel, () {}),
          _buildSettingsTile(
            Icons.logout,
            l10n.logoutLabel,
            () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            color: AppColors.error,
          ),
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
