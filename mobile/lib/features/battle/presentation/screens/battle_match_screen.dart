import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gguiz_battle/app_localizations.dart';
import '../../../../core/data/quiz_questions.dart';
import '../../../../core/providers/local_game_stats_provider.dart';
import '../../../home/data/user_repository.dart';
import '../../../home/providers/user_provider.dart';
import '../../../missions/data/daily_mission.dart';
import '../../../missions/providers/daily_missions_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/battle_socket_service.dart';
import '../widgets/level_up_overlay.dart';

class BattleMatchArgs {
  final String matchId;
  final String userId;
  final String username;
  final List<int> questionIndices;
  final String opponentName;
  final int opponentElo;
  final BattleSocketService socket;

  BattleMatchArgs({
    required this.matchId,
    required this.userId,
    required this.username,
    required this.questionIndices,
    required this.opponentName,
    required this.opponentElo,
    required this.socket,
  });
}

class BattleMatchScreen extends ConsumerStatefulWidget {
  final BattleMatchArgs args;
  const BattleMatchScreen({super.key, required this.args});

  @override
  ConsumerState<BattleMatchScreen> createState() => _BattleMatchScreenState();
}

class _BattleMatchScreenState extends ConsumerState<BattleMatchScreen> {
  static const _totalTime = 15;

  late final List<QuizQuestion> _questions;
  String _locale = 'az';
  int _currentQ = 0;
  int _myScore = 0;
  int _opponentScore = 0;
  int _myCorrect = 0;
  int _timeLeft = _totalTime;
  int? _myAnswer;
  bool _answered = false;
  bool _opponentAnswered = false;
  bool _showResult = false;
  Map<String, dynamic>? _matchResult;
  Timer? _timer;
  DateTime? _questionStart;

  @override
  void initState() {
    super.initState();
    _questions = pickQuestionsByIndices(widget.args.questionIndices);

    widget.args.socket.onAnswerReceived(_onOpponentAnswer);
    widget.args.socket.onMatchResult(_onMatchResult);
    widget.args.socket.onOpponentDisconnected(_onOpponentDisconnected);

    _startRound();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context).languageCode;
  }

  void _startRound() {
    setState(() {
      _answered = false;
      _opponentAnswered = false;
      _myAnswer = null;
      _timeLeft = _totalTime;
    });
    _questionStart = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 1) {
        t.cancel();
        if (!_answered) _submitAnswer(-1);
        Future.delayed(const Duration(milliseconds: 1500), _nextOrComplete);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    _timer?.cancel();
    _submitAnswer(index);
    Future.delayed(const Duration(milliseconds: 1500), _nextOrComplete);
  }

  void _submitAnswer(int index) {
    final correct = _questions[_currentQ].correct;
    final isCorrect = index == correct;
    final timeMs = DateTime.now().difference(_questionStart!).inMilliseconds;
    setState(() {
      _myAnswer = index;
      _answered = true;
      if (isCorrect) {
        _myCorrect++;
        // Tez cavab daha çox xal: 100 + remainingTime*10 (rəqibin xalı ilə eyni formula)
        final remaining = ((15000 - timeMs) / 1000).clamp(0, 15).round();
        _myScore += 100 + remaining * 10;
      }
    });
    if (isCorrect) {
      final notifier = ref.read(dailyMissionsProvider.notifier);
      notifier.incrementProgress(MissionType.answerCorrect, 1);
      // 5 saniyÉ™ É™rzindÉ™ cavab: timeMs < 5000
      if (timeMs < 5000) notifier.incrementProgress(MissionType.fastAnswer, 1);
    }
    widget.args.socket.submitAnswer(
      matchId: widget.args.matchId,
      questionIndex: _currentQ,
      answer: index >= 0 ? String.fromCharCode(65 + index) : '',
      isCorrect: isCorrect,
      timeMs: timeMs,
    );
  }

  void _onOpponentAnswer(Map<String, dynamic> data) {
    if (data['questionIndex'] != _currentQ) return;
    // Backend səhvən geri echo etsə öz cavabımızı opponent kimi saymayaq.
    final fromSocketId = data['socketId'] as String?;
    if (fromSocketId != null && fromSocketId == widget.args.socket.socketId) return;
    setState(() {
      _opponentAnswered = true;
      if (data['isCorrect'] == true) {
        final timeMs = data['timeMs'] as int? ?? 15000;
        final remaining = ((15000 - timeMs) / 1000).clamp(0, 15).round();
        _opponentScore += 100 + remaining * 10;
      }
    });
  }

  void _nextOrComplete() {
    if (!mounted) return;
    if (_currentQ < _questions.length - 1) {
      setState(() => _currentQ++);
      _startRound();
    } else {
      widget.args.socket.completeMatch(
        matchId: widget.args.matchId,
        userId: widget.args.userId,
        score: _myScore,
        correctAnswers: _myCorrect,
      );
    }
  }

  bool _resultProcessed = false;

  void _onMatchResult(Map<String, dynamic> data) {
    if (!mounted) return;
    if (_resultProcessed) return; // server təkrar göndərsə də yalnız 1 dəfə
    _resultProcessed = true;
    final myReward = (data['rewards'] as Map?)?[widget.args.userId];
    int? leveledFrom;
    int? leveledTo;
    if (myReward != null) {
      final xp = (myReward['xp'] as num).toInt();
      final coins = (myReward['coins'] as num).toInt();
      final winnerId = data['winnerId'] as String?;
      final outcome = winnerId == null
          ? GameOutcome.draw
          : (winnerId == widget.args.userId ? GameOutcome.win : GameOutcome.loss);

      final profile = ref.read(userProfileProvider).valueOrNull;
      final bonusXp = ref.read(localGameStatsProvider).bonusXp;
      final oldTotalXp = (profile?.xp ?? 0) + bonusXp;
      final oldLevel = UserProfile.levelFromXp(oldTotalXp);

      ref.read(localGameStatsProvider.notifier).addReward(
            xp: xp,
            coins: coins,
            outcome: outcome,
          );
      final missions = ref.read(dailyMissionsProvider.notifier);
      missions.incrementProgress(MissionType.playMatch, 1);
      if (outcome == GameOutcome.win) {
        missions.incrementProgress(MissionType.winMatch, 1);
      }
      missions.updateStreak(outcome == GameOutcome.win);

      final newLevel = UserProfile.levelFromXp(oldTotalXp + xp);
      if (newLevel > oldLevel) {
        leveledFrom = oldLevel;
        leveledTo = newLevel;
      }
    }
    setState(() {
      _matchResult = data;
      _showResult = true;
    });
    if (leveledFrom != null && leveledTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showLevelUpOverlay(context, oldLevel: leveledFrom!, newLevel: leveledTo!);
        }
      });
    }
  }

  void _onOpponentDisconnected() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.opponentDisconnectedMessage), backgroundColor: AppColors.error),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.args.socket.clearListeners();
    widget.args.socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_showResult) return _buildResultScreen(l10n);

    final q = _questions[_currentQ];
    final options = q.optionsFor(_locale);
    final optionLabels = ['A', 'B', 'C', 'D'];
    final optionColors = [AppColors.optionA, AppColors.optionB, AppColors.optionC, AppColors.optionD];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTopBar(l10n),
                const SizedBox(height: 14),
                _buildScoreRow(l10n),
                const SizedBox(height: 16),
                _buildQuestionCard(q.questionFor(_locale)),
                const SizedBox(height: 16),
                _buildOpponentStatus(l10n),
                const SizedBox(height: 14),
                ...options.asMap().entries.map((e) =>
                    _buildOption(e.key, e.value, optionLabels[e.key], optionColors[e.key])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(20)),
          child: Text('${_currentQ + 1}/${_questions.length}', style: AppTextStyles.labelLarge),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _timeLeft <= 5 ? AppColors.error.withValues(alpha: 0.2) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _timeLeft <= 5 ? AppColors.error : Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: _timeLeft <= 5 ? AppColors.error : AppColors.accent, size: 16),
              const SizedBox(width: 4),
              Text('$_timeLeft', style: AppTextStyles.timerText.copyWith(
                fontSize: 16,
                color: _timeLeft <= 5 ? AppColors.error : AppColors.accent,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(widget.args.username, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('$_myScore', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentOrange),
            ),
            child: Text('VS', style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentOrange)),
          ),
          Expanded(
            child: Column(
              children: [
                Text(widget.args.opponentName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('$_opponentScore', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.error)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradientCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(question, style: AppTextStyles.questionText),
    ).animate(key: ValueKey(_currentQ)).fadeIn().slideY(begin: -0.1);
  }

  Widget _buildOpponentStatus(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _opponentAnswered ? AppColors.success.withValues(alpha: 0.1) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _opponentAnswered ? AppColors.success : const Color(0xFF2A2A50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('👤', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            _opponentAnswered ? '${widget.args.opponentName} ${l10n.opponentAnswered}' : '${widget.args.opponentName} ${l10n.opponentThinking}',
            style: AppTextStyles.bodySmall.copyWith(
              color: _opponentAnswered ? AppColors.success : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text, String label, Color labelColor) {
    Color bg = AppColors.surfaceLight;
    Color border = const Color(0xFF2A2A40);
    if (_answered) {
      final correct = _questions[_currentQ].correct;
      if (index == correct) {
        bg = AppColors.correctAnswer.withValues(alpha: 0.25);
        border = AppColors.correctAnswer;
      } else if (index == _myAnswer) {
        bg = AppColors.wrongAnswer.withValues(alpha: 0.25);
        border = AppColors.wrongAnswer;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: labelColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text(label, style: AppTextStyles.labelLarge.copyWith(color: labelColor))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: AppTextStyles.optionText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l10n) {
    final r = _matchResult ?? {};
    final winnerId = r['winnerId'] as String?;
    final isWin = winnerId == widget.args.userId;
    final isDraw = r['isDraw'] == true || winnerId == null;
    final reward = (r['rewards'] as Map?)?[widget.args.userId];
    final newElo = (r['newElo'] as Map?)?[widget.args.userId];
    final eloChange = (r['eloChange'] as Map?)?[widget.args.userId];
    final xp = (reward?['xp'] as num?)?.toInt() ?? 0;
    final coins = (reward?['coins'] as num?)?.toInt() ?? 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDraw ? '🤝' : (isWin ? '🏆' : '💔'),
                  style: const TextStyle(fontSize: 84),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                Text(
                  isDraw ? l10n.drawResult : (isWin ? l10n.youWon : l10n.youLost),
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: isDraw ? AppColors.accent : (isWin ? AppColors.success : AppColors.error),
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _stat(widget.args.username, '$_myScore', AppColors.primary)),
                      Container(width: 1, height: 50, color: const Color(0xFF2A2A40)),
                      Expanded(child: _stat(widget.args.opponentName, '$_opponentScore', AppColors.error)),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 16),
                if (newElo != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.rankGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.rankGold.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'ELO: $newElo (${(eloChange as num) >= 0 ? '+' : ''}$eloChange)',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.rankGold, fontWeight: FontWeight.w700),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _badge(l10n.xpEarned(xp), AppColors.accent),
                    const SizedBox(width: 12),
                    _badge(l10n.coinsEarned(coins), AppColors.gold),
                  ],
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(l10n.doneButton, style: AppTextStyles.labelLarge.copyWith(fontSize: 15, letterSpacing: 2)),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}
