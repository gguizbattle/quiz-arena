import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  bool _searching = false;

  void _startSearch() {
    setState(() => _searching = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _searching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('1v1 Battle', style: AppTextStyles.headlineLarge),
                  ],
                ).animate().fadeIn(),
                const SizedBox(height: 40),
                _buildArenaCard(),
                const SizedBox(height: 32),
                if (_searching) _buildSearching() else _buildPlayButton(),
                const SizedBox(height: 32),
                _buildStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArenaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 30)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPlayerCard('You', 1425, '👤', AppColors.primary),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentOrange),
                    ),
                    child: Text('VS', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.accentOrange)),
                  ),
                ],
              ),
              _buildPlayerCard('???', 0, '❓', AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.military_tech, color: AppColors.rankGold, size: 16),
                const SizedBox(width: 6),
                Text('ELO Ranked Match', style: AppTextStyles.bodySmall.copyWith(color: AppColors.rankGold)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildPlayerCard(String name, int elo, String emoji, Color color) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTextStyles.titleMedium),
        if (elo > 0) Text('$elo ELO', style: AppTextStyles.bodySmall.copyWith(color: color)),
      ],
    );
  }

  Widget _buildSearching() {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
        ).animate(onPlay: (c) => c.repeat()).rotate(duration: 1.seconds),
        const SizedBox(height: 16),
        Text('Finding opponent...', style: AppTextStyles.titleMedium)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: 800.ms),
        const SizedBox(height: 8),
        Text('Matching with similar ELO players', style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildPlayButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _startSearch,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.gradientAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sports_esports_rounded, color: Colors.black, size: 24),
                const SizedBox(width: 8),
                Text('FIND MATCH', style: AppTextStyles.labelLarge.copyWith(color: Colors.black, fontSize: 16, letterSpacing: 2)),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('47', 'Wins', Icons.emoji_events, AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('12', 'Losses', Icons.close, AppColors.error)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('80%', 'Win Rate', Icons.trending_up, AppColors.primary)),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: color)),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

