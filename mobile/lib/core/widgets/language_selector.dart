import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gguiz_battle/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Qeyd: əvvəlki versiyada bayraqlar regional-indicator emojiləri kimi
// saxlanırdı, fayl yanlış kodlaşma ilə yazıldıqda bozulub "qəribə
// simvollara" çevrilirdi. Həll: emoji yerinə təmiz rəngli badge istifadə
// edirik — hər platformada eyni görünür, font dəstəyindən asılı deyil.

void showLanguageSelector(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final currentLocale = ref.read(localeProvider);

  final languages = [
    ('az', l10n.azerbaijani),
    ('en', l10n.english),
    ('ru', l10n.russian),
    ('tr', l10n.turkish),
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
            final (code, name) = lang;
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
                    FlagBadge(code: code, size: 28),
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
    final code = locale.languageCode;

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
            FlagBadge(code: code, size: 20),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Ölkənin rəng sxemli rozeti (emoji əvəzi).
/// 28dp ölçüdə dil seçim siyahısında, 20dp ölçüdə header düyməsində istifadə olunur.
class FlagBadge extends StatelessWidget {
  final String code;
  final double size;
  const FlagBadge({super.key, required this.code, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final width = size * 1.35;
    return Container(
      width: width,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildFlag(code, size),
    );
  }

  Widget _buildFlag(String code, double h) {
    switch (code) {
      case 'az':
        // AZ: mavi / qırmızı (hilal+8-guşəli ulduz) / yaşıl
        return Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(child: Container(color: const Color(0xFF00B5E2))),
                Expanded(child: Container(color: const Color(0xFFEF3340))),
                Expanded(child: Container(color: const Color(0xFF509E2F))),
              ],
            ),
            CustomPaint(painter: _CrescentStarPainter(starPoints: 8)),
          ],
        );
      case 'en':
        // GB Union Jack
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFF012169)),
            CustomPaint(painter: _UnionJackPainter()),
          ],
        );
      case 'ru':
        // RU: ağ / mavi / qırmızı
        return Column(
          children: [
            Expanded(child: Container(color: Colors.white)),
            Expanded(child: Container(color: const Color(0xFF0033A0))),
            Expanded(child: Container(color: const Color(0xFFDA291C))),
          ],
        );
      case 'tr':
        // TR: qırmızı + ağ hilal + 5-guşəli ulduz
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFFE30A17)),
            CustomPaint(painter: _CrescentStarPainter(starPoints: 5, fullField: true)),
          ],
        );
      default:
        return Container(
          color: const Color(0xFF2A2A50),
          alignment: Alignment.center,
          child: Text(
            code.toUpperCase(),
            style: TextStyle(
              fontSize: h * 0.45,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        );
    }
  }
}

/// Hilal + ulduz çəkir (AZ orta qırmızı zolaq üçün və ya TR tam sahə üçün).
///
/// [fullField] true olduqda emblem tam ölçüdə (Türkiyə bayrağı kimi) çəkilir;
/// false olduqda yalnız bayrağın orta zolağında (Azərbaycan).
/// [starPoints] = 5 (TR) və ya 8 (AZ).
class _CrescentStarPainter extends CustomPainter {
  final int starPoints;
  final bool fullField;
  _CrescentStarPainter({required this.starPoints, this.fullField = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Emblem höndərbağı və mərkəzi
    final double bandTop = fullField ? 0 : h / 3.0;
    final double bandH = fullField ? h : h / 3.0;
    final double cx = fullField ? w * 0.42 : w * 0.5;
    final double cy = bandTop + bandH * 0.5;
    final double r = bandH * (fullField ? 0.34 : 0.42);

    final white = Paint()..color = Colors.white;
    final field = Paint()
      ..color = fullField ? const Color(0xFFE30A17) : const Color(0xFFEF3340);

    // Hilal: böyük ağ disk + kiçik üst-üstə (sağa offset) sahə rəngli disk
    canvas.drawCircle(Offset(cx, cy), r, white);
    canvas.drawCircle(
      Offset(cx + r * 0.30, cy),
      r * 0.85,
      field,
    );

    // Ulduz: sağda yerləşir, hilalın "açılan" tərəfi
    final double starCx = cx + r * (fullField ? 1.55 : 1.50);
    final double starR = r * 0.55;
    _drawStar(canvas, Offset(starCx, cy), starR, starPoints, white);
  }

  void _drawStar(Canvas canvas, Offset center, double outerR, int points, Paint paint) {
    final path = Path();
    final double innerR = outerR * (points == 5 ? 0.40 : 0.50);
    final double startAngle = -math.pi / 2; // yuxarı baxan üst guşə
    for (int i = 0; i < points * 2; i++) {
      final double angle = startAngle + i * math.pi / points;
      final double r = (i.isEven) ? outerR : innerR;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CrescentStarPainter oldDelegate) =>
      oldDelegate.starPoints != starPoints || oldDelegate.fullField != fullField;
}

class _UnionJackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const red = Color(0xFFC8102E);
    final whitePaint = Paint()..color = Colors.white;
    final redPaint = Paint()..color = red;

    // Diaqonal saltire (X)
    // Ağ saltire (geniş)
    final whiteSaltireStroke = Paint()
      ..color = Colors.white
      ..strokeWidth = h * 0.30
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(w, h), whiteSaltireStroke);
    canvas.drawLine(Offset(w, 0), Offset(0, h), whiteSaltireStroke);

    // Qırmızı saltire — offsetli olmalıdır (Sankt Patrik xaçı, sadələşdirilmiş)
    // İki üçbucaq formada hər saltire qolunda: üst/alt yarı qırmızı, qarşı yarı qırmızı yox
    final redSaltireStroke = Paint()
      ..color = red
      ..strokeWidth = h * 0.10
      ..style = PaintingStyle.stroke;
    // Offsetli qırmızı xəttlər — hər biri tam çapraz deyil, kiçik şift ilə
    final dx = w * 0.05;
    final dy = h * 0.05;
    // Sol-yuxarıdan sağ-aşağı: 2 hissə (alt offset, üst offset)
    canvas.drawLine(Offset(0, dy), Offset(w - dx, h), redSaltireStroke);
    canvas.drawLine(Offset(dx, 0), Offset(w, h - dy), redSaltireStroke);
    // Sağ-yuxarıdan sol-aşağı: 2 hissə
    canvas.drawLine(Offset(w, dy), Offset(dx, h), redSaltireStroke);
    canvas.drawLine(Offset(w - dx, 0), Offset(0, h - dy), redSaltireStroke);

    // Düz ağ xaç (cross of St. George fonu)
    canvas.drawRect(Rect.fromLTWH(0, h * 0.38, w, h * 0.24), whitePaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.38, 0, w * 0.24, h), whitePaint);
    // Düz qırmızı xaç (üstündə)
    canvas.drawRect(Rect.fromLTWH(0, h * 0.44, w, h * 0.12), redPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.44, 0, w * 0.12, h), redPaint);
  }

  @override
  bool shouldRepaint(covariant _UnionJackPainter oldDelegate) => false;
}
