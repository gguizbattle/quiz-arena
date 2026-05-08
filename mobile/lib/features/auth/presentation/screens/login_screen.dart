import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_arena/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/language_selector.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          _identifierCtrl.text.trim(),
          _passwordCtrl.text,
        );
    if (!mounted) return;
    final authState = ref.read(authProvider);
    authState.whenData((s) {
      if (s.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: const LanguageButton(),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text('G', style: TextStyle(color: Colors.white.withValues(alpha: 0.15), fontSize: 60, fontWeight: FontWeight.w900, height: 1)),
                          const Icon(Icons.bolt, color: Colors.white, size: 40),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 28),
                  Text(l10n.welcomeBack, style: AppTextStyles.displayMedium, textAlign: TextAlign.center)
                      .animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 6),
                  Text(l10n.tagline, style: AppTextStyles.bodySmall.copyWith(letterSpacing: 4, color: AppColors.textMuted), textAlign: TextAlign.center)
                      .animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 44),
                  _buildField(
                    controller: _identifierCtrl,
                    hint: l10n.usernameOrEmail,
                    icon: Icons.person_outline_rounded,
                    validator: (v) => v!.isEmpty ? l10n.fieldRequired : null,
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _passwordCtrl,
                    hint: l10n.password,
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) => v!.length < 6 ? l10n.minSixChars : null,
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: isLoading ? null : AppColors.gradientPrimary,
                          color: isLoading ? AppColors.surfaceLight : null,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(l10n.loginButton, style: AppTextStyles.labelLarge.copyWith(fontSize: 15, letterSpacing: 3)),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.dontHaveAccount, style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(l10n.registerLink, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: AppTextStyles.bodyLarge,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        suffixIcon: suffix,
      ),
    );
  }
}
