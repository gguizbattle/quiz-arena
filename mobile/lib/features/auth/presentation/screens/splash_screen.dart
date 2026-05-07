import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background glow effects
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyan.withValues(alpha: 0.06),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GLIC Logo Icon
                _GlicLogo()
                    .animate()
                    .scale(duration: 700.ms, curve: Curves.elasticOut)
                    .fadeIn(duration: 500.ms),
                const SizedBox(height: 28),
                // App Name
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.cyan],
                  ).createShader(bounds),
                  child: Text(
                    'GLIC',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      letterSpacing: 10,
                      fontSize: 48,
                    ),
                  ),
                )
                    .animate()
                    .slideY(begin: 0.4, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 600.ms, delay: 300.ms),
                const SizedBox(height: 8),
                Text(
                  'KNOW . PLAY . WIN',
                  style: AppTextStyles.bodyMedium.copyWith(
                    letterSpacing: 4,
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 700.ms),
                const SizedBox(height: 80),
                // Loading dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(delay: Duration(milliseconds: 1000 + i * 150))
                        .fadeIn(duration: 400.ms)
                        .then()
                        .fadeOut(duration: 400.ms)
                        .animate(onPlay: (c) => c.repeat(reverse: true));
                  }),
                ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlicLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A2ADB), Color(0xFF7B5CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'G',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.15),
              fontSize: 90,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Positioned(
            right: 18,
            top: 18,
            child: Icon(Icons.bolt, color: Colors.white, size: 42),
          ),
        ],
      ),
    );
  }
}

