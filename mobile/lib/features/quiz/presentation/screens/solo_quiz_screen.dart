import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SoloQuizScreen extends StatefulWidget {
  const SoloQuizScreen({super.key});

  @override
  State<SoloQuizScreen> createState() => _SoloQuizScreenState();
}

class _SoloQuizScreenState extends State<SoloQuizScreen> with TickerProviderStateMixin {
  final _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'correct': 2,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correct': 1,
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
      'correct': 1,
    },
  ];

  int _currentQ = 0;
  int _score = 0;
  int _timeLeft = 15;
  int? _selectedAnswer;
  bool _answered = false;
  Timer? _timer;

  late AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _startTimer();
  }

  void _startTimer() {
    _progressCtrl.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 1) {
        t.cancel();
        _nextQuestion();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    _timer?.cancel();
    _progressCtrl.stop();
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentQ]['correct']) _score++;
    });
    Future.delayed(const Duration(milliseconds: 1200), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentQ < _questions.length - 1) {
      setState(() {
        _currentQ++;
        _selectedAnswer = null;
        _answered = false;
        _timeLeft = 15;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isDismissible: false,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Quiz Complete!', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 16),
            Text('$_score/${_questions.length}', style: AppTextStyles.scoreText.copyWith(color: AppColors.accent)),
            const SizedBox(height: 8),
            Text('+ ${_score * 100} XP   + ${_score * 50} Coins', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressCtrl.dispose();
    super.dispose();
  }

  Color _optionColor(int index) {
    if (!_answered) return AppColors.surfaceLight;
    final correct = _questions[_currentQ]['correct'] as int;
    if (index == correct) return AppColors.correctAnswer.withValues(alpha: 0.25);
    if (index == _selectedAnswer) return AppColors.wrongAnswer.withValues(alpha: 0.25);
    return AppColors.surfaceLight;
  }

  Color _optionBorder(int index) {
    if (!_answered) return const Color(0xFF2A2A40);
    final correct = _questions[_currentQ]['correct'] as int;
    if (index == correct) return AppColors.correctAnswer;
    if (index == _selectedAnswer) return AppColors.wrongAnswer;
    return const Color(0xFF2A2A40);
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQ];
    final options = q['options'] as List<String>;
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
                _buildTopBar(context),
                const SizedBox(height: 20),
                _buildProgressBar(),
                const SizedBox(height: 28),
                _buildQuestionCard(q['question'] as String),
                const SizedBox(height: 24),
                ...options.asMap().entries.map((e) =>
                  _buildOption(e.key, e.value, optionLabels[e.key], optionColors[e.key])
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
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

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Score: $_score', style: AppTextStyles.bodyMedium),
            Text('+${_score * 100} XP', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (_currentQ + 1) / _questions.length,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
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
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Text(question, style: AppTextStyles.questionText),
    ).animate(key: ValueKey(_currentQ)).fadeIn().slideY(begin: -0.1);
  }

  Widget _buildOption(int index, String text, String label, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _optionColor(index),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _optionBorder(index), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: labelColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text(label, style: AppTextStyles.labelLarge.copyWith(color: labelColor))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(text, style: AppTextStyles.optionText)),
              if (_answered && index == _questions[_currentQ]['correct'])
                const Icon(Icons.check_circle, color: AppColors.correctAnswer, size: 20),
              if (_answered && index == _selectedAnswer && index != _questions[_currentQ]['correct'])
                const Icon(Icons.cancel, color: AppColors.wrongAnswer, size: 20),
            ],
          ),
        ),
      ),
    ).animate(key: ValueKey('$_currentQ-$index')).fadeIn(delay: Duration(milliseconds: 100 + index * 80)).slideX(begin: 0.1);
  }
}

