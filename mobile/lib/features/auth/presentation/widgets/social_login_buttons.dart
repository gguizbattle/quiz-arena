import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gguiz_battle/app_localizations.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';

/// 3 sosial giriÅŸin paylaÅŸÄ±lan widget-i. Login + Register ekranlarÄ±nda istifadÉ™ olunur.
/// Ä°stifadÉ™Ã§i dÃ¼ymÉ™ni basanda mÃ¼vafiq provider axÄ±nÄ± baÅŸlayÄ±r, uÄŸurda /home-a yÃ¶nlÉ™ndirir.
class SocialLoginButtons extends ConsumerStatefulWidget {
  final String? googleServerClientId;
  const SocialLoginButtons({super.key, this.googleServerClientId});

  @override
  ConsumerState<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends ConsumerState<SocialLoginButtons> {
  bool _busy = false;

  Future<void> _run(Future<AuthErrorCode> Function() flow) async {
    if (_busy) return;
    setState(() => _busy = true);
    final code = await flow();
    if (!mounted) return;
    setState(() => _busy = false);
    if (code == AuthErrorCode.none) {
      context.go('/home');
      return;
    }
    if (code == AuthErrorCode.cancelled) return;
    final l10n = AppLocalizations.of(context)!;
    final message = switch (code) {
      AuthErrorCode.network => l10n.errorNetwork,
      AuthErrorCode.userExists => l10n.errorUserExists,
      AuthErrorCode.invalidCredentials => l10n.errorInvalidCredentials,
      _ => l10n.socialLoginFailed,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appleAvailable = Platform.isIOS || Platform.isMacOS;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Expanded(child: Divider(color: AppColors.surfaceLight)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(l10n.orContinueWith, style: AppTextStyles.bodySmall),
          ),
          const Expanded(child: Divider(color: AppColors.surfaceLight)),
        ]),
        const SizedBox(height: 16),
        _Button(
          icon: Icons.g_mobiledata_rounded,
          iconColor: Colors.white,
          background: const Color(0xFF1A1B2E),
          borderColor: const Color(0xFF2A2A40),
          label: l10n.continueWithGoogle,
          busy: _busy,
          onTap: () => _run(() => ref
              .read(authProvider.notifier)
              .signInWithGoogle(serverClientId: widget.googleServerClientId)),
        ),
        const SizedBox(height: 10),
        _Button(
          icon: Icons.facebook_rounded,
          iconColor: Colors.white,
          background: const Color(0xFF1877F2),
          label: l10n.continueWithFacebook,
          busy: _busy,
          onTap: () => _run(() => ref.read(authProvider.notifier).signInWithFacebook()),
        ),
        if (appleAvailable) ...[
          const SizedBox(height: 10),
          _Button(
            icon: Icons.apple_rounded,
            iconColor: Colors.white,
            background: Colors.black,
            label: l10n.continueWithApple,
            busy: _busy,
            onTap: () => _run(() => ref.read(authProvider.notifier).signInWithApple()),
          ),
        ],
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color background;
  final Color? borderColor;
  final String label;
  final bool busy;
  final VoidCallback onTap;
  const _Button({
    required this.icon,
    required this.iconColor,
    required this.background,
    this.borderColor,
    required this.label,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: busy ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
