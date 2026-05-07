import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              _buildTournamentBanner(),
              _buildPlayModes(context),
              _buildDailyMissions(),
              _buildLeaderboard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar with level badge
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
                child: const Center(
                  child: Text('P', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                    child: const Text('23', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Name + XP bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PlayerOne', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 2450 / 3500,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 2),
                Text('2,450 / 3,500 XP', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Bell
          Stack(
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
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildCurrencyRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          _buildCurrencyBadge(Icons.monetization_on, '12,540', AppColors.gold),
          const SizedBox(width: 10),
          _buildCurrencyBadge(Icons.diamond, '350', AppColors.cyan),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 18),
          ),
        ],
      ).animate().fadeIn(delay: 150.ms),
    );
  }

  Widget _buildCurrencyBadge(IconData icon, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ],
      ),
    );
  }

  Widget _buildTournamentBanner() {
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
            // Decorative circles
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
            // Trophy
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: const Text('🏆', style: TextStyle(fontSize: 64))
                  .animate()
                  .scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DAILY', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, letterSpacing: 2, fontSize: 11)),
                  Text('TOURNAMENT', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontSize: 22, height: 1.1)),
                  const SizedBox(height: 2),
                  Text('Win big rewards!', style: AppTextStyles.bodySmall.copyWith(color: Colors.white60)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Starts in', style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontSize: 10)),
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
                          child: Text('JOIN NOW', style: AppTextStyles.labelLarge.copyWith(color: Colors.black, fontSize: 12)),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          _buildSectionHeader('PLAY MODES', 'See All', () {}),
          const SizedBox(height: 14),
          SizedBox(
            height: 130,
            child: Row(
              children: [
                Expanded(
                  child: _buildModeCard(
                    title: '1v1',
                    subtitle: 'Quick Battle',
                    emoji: '⚔️',
                    gradient: AppColors.gradientPrimary,
                    onTap: () => context.go('/battle'),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeCard(
                    title: 'SOLO',
                    subtitle: 'Practice',
                    emoji: '🤖',
                    gradient: AppColors.gradientBattle,
                    onTap: () => context.go('/quiz'),
                  ).animate().fadeIn(delay: 380.ms).slideY(begin: 0.2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeCard(
                    title: 'BATTLE\nROYALE',
                    subtitle: 'Last One Wins',
                    emoji: '👑',
                    gradient: AppColors.gradientBattleRoyale,
                    onTap: () => context.go('/tournaments'),
                  ).animate().fadeIn(delay: 460.ms).slideX(begin: 0.2),
                ),
              ],
            ),
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
            Text(emoji, style: const TextStyle(fontSize: 32)),
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

  Widget _buildDailyMissions() {
    final missions = [
      (Icons.track_changes_rounded, 'Play 3 matches', 2, 3, AppColors.pink, 200, false),
      (Icons.bolt, 'Win 1 match', 1, 1, AppColors.success, 150, true),
      (Icons.psychology_rounded, 'Answer 10 questions correctly', 7, 10, AppColors.cyan, 250, false),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          _buildSectionHeader('DAILY MISSIONS', 'See All', () {}),
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
              Text('LEADERBOARD', style: AppTextStyles.labelLarge.copyWith(letterSpacing: 1, fontSize: 13)),
              GestureDetector(
                onTap: () => context.go('/leaderboard'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text('View', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Top Players', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
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

