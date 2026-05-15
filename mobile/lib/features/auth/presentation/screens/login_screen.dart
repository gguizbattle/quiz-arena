import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gguiz_battle/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/gguiz_logo.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../providers/auth_provider.dart';
import '../widgets/social_login_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;
  AuthErrorCode? _errorCode;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _errorCode = null);
    await ref.read(authProvider.notifier).login(
          _idCtrl.text.trim(),
          _pwCtrl.text,
        );
    if (!mounted) return;
    final state = ref.read(authProvider);
    state.whenData((s) {
      if (s.status == AuthStatus.authenticated) {
        context.go('/home');
      } else if (s.errorCode != AuthErrorCode.none) {
        setState(() => _errorCode = s.errorCode);
      }
    });
  }

  String _errorText(AppLocalizations l10n, AuthErrorCode code) {
    return switch (code) {
      AuthErrorCode.invalidCredentials => l10n.errorInvalidCredentials,
      AuthErrorCode.userExists => l10n.errorUserExists,
      AuthErrorCode.network => l10n.errorNetwork,
      AuthErrorCode.generic || AuthErrorCode.cancelled || AuthErrorCode.none => l10n.errorGeneric,
    };
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
                  const Center(
                    child: GguizLogo(size: 96),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Text(
                    l10n.welcomeBack,
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                  const SizedBox(height: 4),
                  Text(
                    l10n.tagline,
                    style: AppTextStyles.bodySmall.copyWith(
                      letterSpacing: 4,
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 32),
                  if (_errorCode != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorText(l10n, _errorCode!),
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _errorCode = null),
                            child: const Icon(Icons.close_rounded, color: AppColors.error, size: 18),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 200.ms),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _idCtrl,
                    style: AppTextStyles.bodyLarge,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: l10n.usernameOrEmail,
                      prefixIcon: const Icon(Icons.person_outline_rounded,
                          color: AppColors.textMuted, size: 20),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.1),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _pwCtrl,
                    obscureText: _obscure,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? l10n.minSixChars : null,
                  ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.1),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
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
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  l10n.loginButton,
                                  style: AppTextStyles.labelLarge.copyWith(fontSize: 14, letterSpacing: 2),
                                ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.dontHaveAccount, style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          l10n.registerLink,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 650.ms),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFF2A2A50))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l10n.orContinueWith,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFF2A2A50))),
                    ],
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 18),
                  const SocialLoginButtons().animate().fadeIn(delay: 750.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
