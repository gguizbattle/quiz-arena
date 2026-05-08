import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_arena/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/local_game_stats_provider.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 2, minutes: 45, seconds: 12);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  double _computeLevelProgress(int totalXp, int level) {
    final lower = (level - 1) * 1000;
    final upper = level * 1000;
    final span = upper - lower;
    if (span == 0) return 0;
    return ((totalXp - lower) / span).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCurrencyRow(),
              _buildTournamentBanner(context),
              _buildPlayModes(context),
              _buildDailyMissions(context),
              _buildLeaderboard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final profileAsync = ref.watch(userProfileProvider);
    final localStats = ref.watch(localGameStatsProvider);

    return profileAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: SizedBox(height: 60, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      profile.username[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${profile.level}',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.username, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _computeLevelProgress(profile.xp + localStats.bonusXp, profile.level),
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(profile.xp + localStats.bonusXp).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / ${profile.xpForNextLevel.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} XP',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _showNotificationsSheet(AppLocalizations.of(context)!),
              child: Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 22),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }

  Widget _buildCurrencyRow() {
    final profileAsync = ref.watch(userProfileProvider);
    final localStats = ref.watch(localGameStatsProvider);
    final l10n = AppLocalizations.of(context)!;
    final coins = (profileAsync.valueOrNull?.coins ?? 0) + localStats.bonusCoins;
    final xp = (profileAsync.valueOrNull?.xp ?? 0) + localStats.bonusXp;
    final coinsText = coins.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    final xpText = xp.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          _buildCurrencyBadge(
            icon: Icons.monetization_on,
            amount: coinsText,
            color: AppColors.gold,
            onTapBadge: () => _showBalanceSheet(
              icon: Icons.monetization_on,
              title: l10n.coinBalanceTitle,
              amount: coinsText,
              color: AppColors.gold,
              l10n: l10n,
            ),
            onTapPlus: () => context.go('/shop'),
          ),
          const SizedBox(width: 10),
          _buildCurrencyBadge(
            icon: Icons.star,
            amount: xpText,
            color: AppColors.accent,
            onTapBadge: () => _showBalanceSheet(
              icon: Icons.star,
              title: l10n.xpBalanceTitle,
              amount: xpText,
              color: AppColors.accent,
              l10n: l10n,
            ),
            onTapPlus: () => context.go('/shop'),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.go('/shop'),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 150.ms),
    );
  }

  void _showNotificationsSheet(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.notifications_off_outlined, size: 56, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(l10n.notificationsTitle, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              l10n.noNotifications,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(sheetCtx).pop(),
              child: Text(
                l10n.closeAction,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBalanceSheet({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
    required AppLocalizations l10n,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              amount,
              style: AppTextStyles.headlineLarge.copyWith(color: color, fontSize: 36),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(sheetCtx).pop();
                  context.go('/shop');
                },
                icon: const Icon(Icons.storefront_rounded, size: 20),
                label: Text(l10n.goToShop, style: AppTextStyles.labelLarge),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(sheetCtx).pop(),
              child: Text(
                l10n.closeAction,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyBadge({
    required IconData icon,
    required String amount,
    required Color color,
    required VoidCallback onTapBadge,
    required VoidCallback onTapPlus,
  }) {
    return GestureDetector(
      onTap: onTapBadge,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 4, 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 4),
            Text(amount, style: AppTextStyles.labelLarge.copyWith(color: color, fontSize: 13)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onTapPlus,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: color, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          gradient: AppColors.gradientTournament,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: const Text('🏆', style: TextStyle(fontSize: 64))
                  .animate()
                  .scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.daily, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, letterSpacing: 2, fontSize: 11)),
                  Text(l10n.tournament, style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontSize: 22, height: 1.1)),
                  Text(l10n.winBigRewards, style: AppTextStyles.bodySmall.copyWith(color: Colors.white60)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.startsIn, style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontSize: 10)),
                          Text(
                            '${_pad(_remaining.inHours)}:${_pad(_remaining.inMinutes % 60)}:${_pad(_remaining.inSeconds % 60)}',
                            style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 2),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => context.go('/tournaments'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(l10n.joinNow, style: AppTextStyles.labelLarge.copyWith(color: Colors.black, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildPlayModes(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          _buildSectionHeader(l10n.playModes, l10n.seeAll, () {}),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  title: '1v1',
                  subtitle: l10n.quickBattle,
                  emoji: '⚔️',
                  gradient: AppColors.gradientPrimary,
                  onTap: () => context.push('/battle'),
                ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildModeCard(
                  title: l10n.botBattle,
                  subtitle: l10n.botBattleSubtitle,
                  emoji: '🤖',
                  gradient: AppColors.gradientCyan,
                  onTap: () => context.push('/bot-battle'),
                ).animate().fadeIn(delay: 360.ms).slideY(begin: 0.2),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  title: l10n.soloPlay,
                  subtitle: l10n.soloSubtitle,
                  emoji: '🧠',
                  gradient: AppColors.gradientBattle,
                  onTap: () => context.push('/quiz'),
                ).animate().fadeIn(delay: 420.ms).slideX(begin: -0.2),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildModeCard(
                  title: l10n.battleRoyaleTitle,
                  subtitle: l10n.lastOneWins,
                  emoji: '👑',
                  gradient: AppColors.gradientBattleRoyale,
                  onTap: () => context.go('/tournaments'),
                ).animate().fadeIn(delay: 480.ms).slideX(begin: 0.2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required String emoji,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: gradient.colors.first.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 12, height: 1.2),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: Colors.white60, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMissions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final missions = [
      (Icons.track_changes_rounded, l10n.mission1, 2, 3, AppColors.pink, 200, false),
      (Icons.bolt, l10n.mission2, 1, 1, AppColors.success, 150, true),
      (Icons.psychology_rounded, l10n.mission3, 7, 10, AppColors.cyan, 250, false),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          _buildSectionHeader(l10n.dailyMissions, l10n.seeAll, () {}),
          const SizedBox(height: 14),
          ...missions.asMap().entries.map((e) {
            final (icon, name, current, total, color, coins, done) = e.value;
            return _buildMissionRow(icon, name, current, total, color, coins, done, e.key)
                .animate()
                .fadeIn(delay: Duration(milliseconds: 300 + e.key * 100))
                .slideX(begin: 0.1);
          }),
        ],
      ),
    );
  }

  Widget _buildMissionRow(IconData icon, String name, int current, int total, Color color, int coins, bool done, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A50)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontSize: 13)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: current / total,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 3),
                Text('$current / $total', style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: AppColors.gold, size: 14),
                  const SizedBox(width: 3),
                  Text('$coins', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.success : Colors.transparent,
                  border: Border.all(color: done ? AppColors.success : AppColors.textMuted, width: 1.5),
                ),
                child: done ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final players = [
      ('QuizMaster', 12540, '🥇', 1),
      ('BrainKing', 11230, '🥈', 2),
      ('SmartAzer', 10980, '🥉', 3),
      ('LogicPro', 9870, '4', 4),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.leaderboard.toUpperCase(), style: AppTextStyles.labelLarge.copyWith(letterSpacing: 1, fontSize: 13)),
              GestureDetector(
                onTap: () => context.go('/leaderboard'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(l10n.view, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.topPlayers, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          Row(
            children: players.asMap().entries.map((e) {
              final (name, coins, medal, rank) = e.value;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: e.key < players.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF2A2A50)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.surfaceLight,
                            child: Text(name[0], style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Positioned(
                            bottom: -4,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(medal, style: const TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.monetization_on, color: AppColors.gold, size: 11),
                          const SizedBox(width: 2),
                          Text('${(coins / 1000).toStringAsFixed(1)}k', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 400 + e.key * 80)).slideY(begin: 0.2),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.labelLarge.copyWith(letterSpacing: 1, fontSize: 13)),
        GestureDetector(
          onTap: onAction,
          child: Row(
            children: [
              Text(actionText, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, color: AppColors.primaryLight, size: 10),
            ],
          ),
        ),
      ],
    );
  }
}
