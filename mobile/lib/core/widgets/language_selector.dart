import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_arena/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

void showLanguageSelector(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final currentLocale = ref.read(localeProvider);

  final languages = [
    ('az', l10n.azerbaijani, '🇦🇿'),
    ('en', l10n.english, '🇬🇧'),
    ('ru', l10n.russian, '🇷🇺'),
    ('tr', l10n.turkish, '🇹🇷'),
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(l10n.languageSelectorTitle, style: AppTextStyles.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          ...languages.map((lang) {
            final (code, name, flag) = lang;
            final isSelected = currentLocale.languageCode == code;
            return GestureDetector(
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(Locale(code));
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFF2A2A40),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

/// Small language button widget — use in any screen header
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key, this.color = AppColors.textSecondary});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final flags = {'az': '🇦🇿', 'en': '🇬🇧', 'ru': '🇷🇺', 'tr': '🇹🇷'};
    final flag = flags[locale.languageCode] ?? '🇦🇿';

    return GestureDetector(
      onTap: () => showLanguageSelector(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2A50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
