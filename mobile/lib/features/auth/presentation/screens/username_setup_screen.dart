import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gguiz_battle/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/providers/user_provider.dart';

/// Supabase Auth ilə qeydiyyatdan keçən istifadəçi avtomatik username alır
/// (email-dən derive). Bu ekran ona öz adını seçmək imkanı verir — yalnız
/// `usernameSet == false` olduqda göstərilir.
class UsernameSetupScreen extends ConsumerStatefulWidget {
  const UsernameSetupScreen({super.key});

  @override
  ConsumerState<UsernameSetupScreen> createState() => _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends ConsumerState<UsernameSetupScreen> {
  final _form = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorText = null;
    });
    try {
      await ref.read(userRepositoryProvider).setUsername(_ctrl.text.trim());
      // Cache-i sıfırla ki, /home yenidən GET /users/me etsin
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.go('/home');
    } on DioException catch (e) {
      if (!mounted) return;
      final code = e.response?.statusCode;
      setState(() {
        _loading = false;
        if (code == 409) {
          _errorText = l10n.usernameSetupErrorTaken;
        } else if (code == 400) {
          _errorText = l10n.usernameSetupErrorFormat;
        } else {
          _errorText = l10n.usernameSetupSaveFailed;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorText = l10n.usernameSetupSaveFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  const SizedBox(height: 60),
                  Text(l10n.usernameSetupTitle, style: AppTextStyles.displayMedium)
                      .animate().fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(l10n.usernameSetupSubtitle, style: AppTextStyles.bodyMedium)
                      .animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 40),
                  if (_errorText != null) ...[
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
                              _errorText!,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 200.ms),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _ctrl,
                    style: AppTextStyles.bodyLarge,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.usernameSetupHint,
                      prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.textMuted, size: 20),
                    ),
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.length < 3) return l10n.usernameSetupErrorMinLen;
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(s)) return l10n.usernameSetupErrorFormat;
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: _loading ? null : AppColors.gradientPrimary,
                          color: _loading ? AppColors.surfaceLight : null,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(l10n.usernameSetupContinue, style: AppTextStyles.labelLarge.copyWith(fontSize: 14, letterSpacing: 2)),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
