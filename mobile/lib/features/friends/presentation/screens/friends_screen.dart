import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_arena/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _friends = [
    ('NightOwl99', 1980, true, '🥈'),
    ('BrainMaster', 1875, true, '🥉'),
    ('QuizKing', 1820, false, '4'),
    ('SmartAlex', 1770, true, '5'),
    ('ThinkFast', 1720, false, '6'),
  ];

  final _requests = [
    ('SpeedDemon99', 1650),
    ('QuizWizard', 1580),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.friendsTitle, style: AppTextStyles.headlineLarge).animate().fadeIn(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(l10n.addButton, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A50)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.searchPlayersHint, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: l10n.friendsTab(_friends.length)),
                    Tab(text: l10n.requestsTab(_requests.length)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsList(l10n),
                  _buildRequestsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _friends.length,
      itemBuilder: (_, i) {
        final (name, elo, online, medal) = _friends[i];
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.surfaceLight,
                    child: Text(name[0], style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: online ? AppColors.success : AppColors.textMuted,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.card, width: 2),
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
                    Row(
                      children: [
                        Text(name, style: AppTextStyles.titleMedium),
                        const SizedBox(width: 6),
                        Text(medal, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: online ? AppColors.success : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(online ? l10n.onlineStatus : l10n.offlineStatus, style: AppTextStyles.bodySmall.copyWith(color: online ? AppColors.success : AppColors.textMuted)),
                        const SizedBox(width: 8),
                        const Icon(Icons.military_tech, color: AppColors.gold, size: 13),
                        const SizedBox(width: 3),
                        Text('$elo ELO', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                      ],
                    ),
                  ],
                ),
              ),
              if (online)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(l10n.challengeButton, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                )
              else
                const Icon(Icons.more_horiz, color: AppColors.textMuted),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 + i * 80)).slideX(begin: 0.1);
      },
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _requests.length,
      itemBuilder: (_, i) {
        final (name, elo) = _requests[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(name[0], style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMedium),
                    Row(
                      children: [
                        const Icon(Icons.military_tech, color: AppColors.gold, size: 13),
                        const SizedBox(width: 3),
                        Text('$elo ELO', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.15), shape: BoxShape.circle, border: Border.all(color: AppColors.error.withValues(alpha: 0.4))),
                      child: const Icon(Icons.close, color: AppColors.error, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), shape: BoxShape.circle, border: Border.all(color: AppColors.success.withValues(alpha: 0.4))),
                      child: const Icon(Icons.check, color: AppColors.success, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 + i * 100)).slideX(begin: 0.1);
      },
    );
  }
}
