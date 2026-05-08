import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_arena/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
          _usernameCtrl.text.trim(),
          _emailCtrl.text.trim(),
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
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
                    onPressed: () => context.go('/login'),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.createAccountTitle, style: AppTextStyles.displayMedium)
                      .animate().fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 6),
                  Text(l10n.joinBattleArena, style: AppTextStyles.bodyMedium)
                      .animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 36),
                  _buildField(
                    controller: _usernameCtrl,
                    hint: l10n.usernameField,
                    icon: Icons.alternate_email_rounded,
                    validator: (v) {
                      if (v!.isEmpty) return l10n.fieldRequired;
                      if (v.length < 3) return l10n.minThreeChars;
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) return l10n.usernameFormatError;
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _emailCtrl,
                    hint: l10n.emailField,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) return l10n.fieldRequired;
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return l10n.invalidEmail;
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _passwordCtrl,
                    hint: l10n.passwordWithMin,
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) => v!.length < 6 ? l10n.minSixChars : null,
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _register,
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
                              : Text(l10n.createAccountButton, style: AppTextStyles.labelLarge.copyWith(fontSize: 14, letterSpacing: 2)),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount, style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(l10n.loginLink, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
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
