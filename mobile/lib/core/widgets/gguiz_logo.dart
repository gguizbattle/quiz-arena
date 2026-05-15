import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gguiz Battle brendi: heksaqon gem + qızıl tac + parlaq şimşək + 4 ulduz.
/// Launcher icon-u ilə eyni vizual dil.
class GguizLogo extends StatelessWidget {
  final double size;
  final bool showShadow;
  const GguizLogo({super.key, this.size = 110, this.showShadow = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GguizLogoPainter(showShadow: showShadow),
      ),
    );
  }
}

class _GguizLogoPainter extends CustomPainter {
  final bool showShadow;
  _GguizLogoPainter({required this.showShadow});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = w / 2;
    final cy = w / 2;
    final r = w * 0.42;

    // Heksagon nöqtələri (pointy-top)
    final hex = List.generate(6, (i) {
      final a = math.pi / 2 + i * math.pi / 3;
      return Offset(cx + r * math.cos(a), cy + r * math.sin(a));
    });
    final hexPath = Path()..addPolygon(hex, true);

    if (showShadow) {
      canvas.drawPath(
        hexPath,
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.06),
      );
    }

    // 4-color vertikal gradient: cyan → purple → magenta → orange
    canvas.drawPath(
      hexPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF14E9FF),
            Color(0xFF6A35FF),
            Color(0xFFE02EC4),
            Color(0xFFFF7A29),
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, w)),
    );

    // Üst yarımda ag highlight
    final topHi = Path()
      ..moveTo(hex[0].dx, hex[0].dy)
      ..lineTo(hex[1].dx, hex[1].dy)
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(
      topHi,
      Paint()..color = Colors.white.withValues(alpha: 0.12),
    );
    final topHi2 = Path()
      ..moveTo(hex[0].dx, hex[0].dy)
      ..lineTo(hex[5].dx, hex[5].dy)
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(
      topHi2,
      Paint()..color = Colors.white.withValues(alpha: 0.12),
    );

    // Facet xətləri (mərkəzdən hər künc)
    final facetPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = w * 0.004
      ..style = PaintingStyle.stroke;
    for (final v in hex) {
      canvas.drawLine(Offset(cx, cy), v, facetPaint);
    }

    // Ag inner rim
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.020,
    );
    // Qızıl outer line
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = const Color(0xFFFFD400)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.010,
    );

    _drawCrown(canvas, w);
    _drawBolt(canvas, w);
    _drawSparkles(canvas, w);
  }

  void _drawCrown(Canvas canvas, double w) {
    final cx = w / 2;
    final cy = w * 0.16;
    final s = w * 0.001;
    final gold = Paint()..color = const Color(0xFFFFD400);
    final goldDark = Paint()..color = const Color(0xFFC99A00);

    final baseY = cy + 60 * s;
    canvas.drawRect(Rect.fromLTWH(cx - 90 * s, baseY, 180 * s, 22 * s), gold);
    canvas.drawRect(Rect.fromLTWH(cx - 95 * s, baseY + 22 * s, 190 * s, 10 * s), goldDark);

    // 3 üçbucaq
    final p1 = Path()
      ..moveTo(cx - 90 * s, baseY)
      ..lineTo(cx - 50 * s, cy - 30 * s)
      ..lineTo(cx - 10 * s, baseY)
      ..close();
    canvas.drawPath(p1, gold);
    final p2 = Path()
      ..moveTo(cx - 10 * s, baseY)
      ..lineTo(cx, cy - 80 * s)
      ..lineTo(cx + 10 * s, baseY)
      ..close();
    canvas.drawPath(p2, gold);
    final p3 = Path()
      ..moveTo(cx + 10 * s, baseY)
      ..lineTo(cx + 50 * s, cy - 30 * s)
      ..lineTo(cx + 90 * s, baseY)
      ..close();
    canvas.drawPath(p3, gold);

    // Cəvahir nöqtələri
    canvas.drawCircle(Offset(cx - 50 * s, cy - 30 * s), 12 * s, Paint()..color = const Color(0xFFFF3ED1));
    canvas.drawCircle(Offset(cx, cy - 80 * s), 14 * s, Paint()..color = const Color(0xFF00E5FF));
    canvas.drawCircle(Offset(cx + 50 * s, cy - 30 * s), 12 * s, Paint()..color = const Color(0xFFFF3ED1));
  }

  void _drawBolt(Canvas canvas, double w) {
    final cx = w / 2;
    final cy = w / 2 + w * 0.04;
    final s = w * 0.001;
    final pts = [
      Offset(cx + 80 * s, cy - 320 * s),
      Offset(cx - 130 * s, cy + 40 * s),
      Offset(cx - 10 * s, cy + 40 * s),
      Offset(cx - 80 * s, cy + 320 * s),
      Offset(cx + 130 * s, cy - 40 * s),
      Offset(cx + 10 * s, cy - 40 * s),
    ];
    final path = Path()..addPolygon(pts, true);

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF8C00).withValues(alpha: 0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.025),
    );
    // Əsas sarı dolğu
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFE033));
    // Ağ işıq zolağı
    final hi = Path()
      ..addPolygon([
        Offset(cx + 70 * s, cy - 290 * s),
        Offset(cx - 50 * s, cy + 0 * s),
        Offset(cx - 20 * s, cy + 0 * s),
        Offset(cx + 30 * s, cy - 130 * s),
      ], true);
    canvas.drawPath(hi, Paint()..color = Colors.white.withValues(alpha: 0.8));
    // Kontur
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF6B4000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.006,
    );
  }

  void _drawSparkles(Canvas canvas, double w) {
    final s = w * 0.001;
    final positions = [
      Offset(w * 0.18, w * 0.40),
      Offset(w * 0.82, w * 0.40),
      Offset(w * 0.22, w * 0.78),
      Offset(w * 0.78, w * 0.78),
    ];
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    for (final p in positions) {
      final size = 50 * s;
      final star = Path()
        ..moveTo(p.dx, p.dy - size)
        ..lineTo(p.dx + size * 0.18, p.dy - size * 0.18)
        ..lineTo(p.dx + size, p.dy)
        ..lineTo(p.dx + size * 0.18, p.dy + size * 0.18)
        ..lineTo(p.dx, p.dy + size)
        ..lineTo(p.dx - size * 0.18, p.dy + size * 0.18)
        ..lineTo(p.dx - size, p.dy)
        ..lineTo(p.dx - size * 0.18, p.dy - size * 0.18)
        ..close();
      canvas.drawPath(star, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GguizLogoPainter oldDelegate) =>
      oldDelegate.showShadow != showShadow;
}
