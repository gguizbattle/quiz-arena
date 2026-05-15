// Generates `assets/icons/app_icon.png` and
// `assets/icons/app_icon_foreground.png`.
//
// Dizayn: heksaqon (gem) formalı multi-color gradient (cyan→purple→pink→orange),
// üstündə qızıl tac, mərkəzdə parlaq şimşək, 4 küncdə ulduz parıltıları.
// 3x super-sampling ilə hamar kənarlar.
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const int _outSize = 1024;
const int _ss = 3;
const int _renderSize = _outSize * _ss;

void main() {
  final fullIcon = _renderAndDownscale(withBackground: true);
  File('assets/icons/app_icon.png').writeAsBytesSync(img.encodePng(fullIcon));

  final fg = _renderAndDownscale(withBackground: false);
  File('assets/icons/app_icon_foreground.png').writeAsBytesSync(img.encodePng(fg));

  stdout.writeln('Generated 1024×1024 icons ($_ss× SSAA):');
  stdout.writeln('  assets/icons/app_icon.png');
  stdout.writeln('  assets/icons/app_icon_foreground.png');
}

img.Image _renderAndDownscale({required bool withBackground}) {
  final big = img.Image(width: _renderSize, height: _renderSize, numChannels: 4);
  img.fill(big, color: img.ColorRgba8(0, 0, 0, 0));

  if (withBackground) {
    _drawHexagonGem(big);
    _drawFacets(big);
    _drawNeonRim(big);
  }
  _drawCrown(big);
  _drawBolt(big);
  _drawCornerSparkles(big);
  return img.copyResize(big, width: _outSize, height: _outSize, interpolation: img.Interpolation.cubic);
}

// ───────────────────── HEXAGON GEM (4-COLOR GRADIENT) ─────────────────────

List<_P> _hexagonVertices(int w, double scale) {
  final cx = w / 2;
  final cy = w / 2;
  final r = w * 0.42 * scale;
  // "Flat-top" yox, "Pointy-top" heksaqon: 30° offset
  return List.generate(6, (i) {
    final angle = math.pi / 2 + i * math.pi / 3; // 90, 150, 210, 270, 330, 30
    return _P(cx + r * math.cos(angle), cy + r * math.sin(angle));
  });
}

void _drawHexagonGem(img.Image image) {
  final w = image.width;
  final verts = _hexagonVertices(w, 1.0);
  // Vertikal 4-color gradient
  // 0.0 cyan → 0.35 purple → 0.65 magenta → 1.0 orange-red
  final c0 = img.ColorRgb8(0x14, 0xE9, 0xFF);
  final c1 = img.ColorRgb8(0x6A, 0x35, 0xFF);
  final c2 = img.ColorRgb8(0xE0, 0x2E, 0xC4);
  final c3 = img.ColorRgb8(0xFF, 0x7A, 0x29);

  final minY = verts.map((p) => p.y).reduce(math.min);
  final maxY = verts.map((p) => p.y).reduce(math.max);

  for (var y = minY.floor(); y <= maxY.ceil(); y++) {
    final inters = _polyIntersections(verts, y.toDouble());
    if (inters.isEmpty) continue;
    inters.sort();
    for (var i = 0; i + 1 < inters.length; i += 2) {
      final x1 = inters[i].floor();
      final x2 = inters[i + 1].ceil();
      // Vertikal nöqtədə rəng
      final t = ((y - minY) / (maxY - minY)).clamp(0.0, 1.0);
      img.Color c;
      if (t < 0.33) {
        c = _lerp(c0, c1, t / 0.33);
      } else if (t < 0.66) {
        c = _lerp(c1, c2, (t - 0.33) / 0.33);
      } else {
        c = _lerp(c2, c3, (t - 0.66) / 0.34);
      }
      for (var x = x1; x <= x2; x++) {
        _blend(image, x, y, c);
      }
    }
  }
}

void _drawFacets(img.Image image) {
  final w = image.width;
  final verts = _hexagonVertices(w, 0.95);
  final cx = w / 2;
  final cy = w / 2;
  // Mərkəzdən hər künc nöqtəsinə zəif ağ xətlər (gem kəsim effekti)
  final facetColor = img.ColorRgba8(255, 255, 255, 70);
  for (final v in verts) {
    _drawLineAA(image, cx, cy, v.x, v.y, facetColor, w * 0.003);
  }
  // Üst yarımı işıqlandır
  final topHighlight = img.ColorRgba8(255, 255, 255, 35);
  _fillTrapezoid(
    image,
    verts[0],
    verts[1],
    _P(cx, cy),
    _P(cx, cy),
    topHighlight,
  );
  _fillTrapezoid(
    image,
    verts[0],
    verts[5],
    _P(cx, cy),
    _P(cx, cy),
    topHighlight,
  );
}

void _drawNeonRim(img.Image image) {
  final w = image.width;
  final verts = _hexagonVertices(w, 1.0);
  // 2 zolaq: parlaq qızıl xarici və daha yumşaq daxili
  final goldOuter = img.ColorRgb8(0xFF, 0xD4, 0x00);
  final whiteGlow = img.ColorRgba8(255, 255, 255, 120);
  // İlk: white inner stroke
  for (var i = 0; i < verts.length; i++) {
    final a = verts[i];
    final b = verts[(i + 1) % verts.length];
    _drawLineAA(image, a.x, a.y, b.x, b.y, whiteGlow, w * 0.018);
  }
  // Sonra: gold outer line, daha incə
  for (var i = 0; i < verts.length; i++) {
    final a = verts[i];
    final b = verts[(i + 1) % verts.length];
    _drawLineAA(image, a.x, a.y, b.x, b.y, goldOuter, w * 0.008);
  }
}

// ───────────────────── CROWN (top) ─────────────────────

void _drawCrown(img.Image image) {
  final w = image.width;
  final cx = w / 2;
  final cy = w * 0.16; // üst qismdə
  final s = w * 0.001; // miqyas
  final gold = img.ColorRgb8(0xFF, 0xD4, 0x00);
  final goldDark = img.ColorRgb8(0xC9, 0x9A, 0x00);

  // Tac əsası
  final baseY = cy + 60 * s;
  _fillRectAA(image, cx - 90 * s, baseY, cx + 90 * s, baseY + 22 * s, gold);
  _fillRectAA(image, cx - 95 * s, baseY + 22 * s, cx + 95 * s, baseY + 32 * s, goldDark);

  // 3 üçbucaq tac dişi: orta daha yüksək
  _fillPolygonAA(image, [
    _P(cx - 90 * s, baseY),
    _P(cx - 50 * s, cy - 30 * s),
    _P(cx - 10 * s, baseY),
  ], gold);
  _fillPolygonAA(image, [
    _P(cx - 10 * s, baseY),
    _P(cx, cy - 80 * s),
    _P(cx + 10 * s, baseY),
  ], gold);
  _fillPolygonAA(image, [
    _P(cx + 10 * s, baseY),
    _P(cx + 50 * s, cy - 30 * s),
    _P(cx + 90 * s, baseY),
  ], gold);

  // Tac dişlərinin başındakı kiçik dairələr (cəvahir)
  _fillCircleAA(image, (cx - 50 * s).round(), (cy - 30 * s).round(), (12 * s).round(), img.ColorRgb8(0xFF, 0x3E, 0xD1));
  _fillCircleAA(image, cx.round(), (cy - 80 * s).round(), (14 * s).round(), img.ColorRgb8(0x00, 0xE5, 0xFF));
  _fillCircleAA(image, (cx + 50 * s).round(), (cy - 30 * s).round(), (12 * s).round(), img.ColorRgb8(0xFF, 0x3E, 0xD1));
}

// ───────────────────── BOLT (center) ─────────────────────

void _drawBolt(img.Image image) {
  final w = image.width;
  final cx = w / 2;
  final cy = w / 2 + w * 0.04; // bir az aşağı
  final s = w * 0.001;

  // Sarı şimşək forma nöqtələri
  final pts = <_P>[
    _P(cx + 80 * s, cy - 320 * s),
    _P(cx - 130 * s, cy + 40 * s),
    _P(cx - 10 * s, cy + 40 * s),
    _P(cx - 80 * s, cy + 320 * s),
    _P(cx + 130 * s, cy - 40 * s),
    _P(cx + 10 * s, cy - 40 * s),
  ];

  // Glow halqası (yumşaq narıncı)
  _fillPolygonAA(image, _expandPolygon(pts, w * 0.028), img.ColorRgba8(0xFF, 0x8C, 0x00, 90));

  // Əsas dolğu — parlaq sarı
  _fillPolygonAA(image, pts, img.ColorRgb8(0xFF, 0xE0, 0x33));

  // Daxili ag işıq zolağı (parıltı)
  final highlight = <_P>[
    _P(cx + 70 * s, cy - 290 * s),
    _P(cx - 50 * s, cy + 0 * s),
    _P(cx - 20 * s, cy + 0 * s),
    _P(cx + 30 * s, cy - 130 * s),
  ];
  _fillPolygonAA(image, highlight, img.ColorRgba8(255, 255, 255, 200));

  // Sərt qara kontur
  _strokePolygon(image, pts, img.ColorRgb8(0x6B, 0x40, 0x00), w * 0.006);
}

// ───────────────────── CORNER SPARKLES ─────────────────────

void _drawCornerSparkles(img.Image image) {
  final w = image.width;
  final s = w * 0.001;
  final positions = [
    _P(w * 0.18, w * 0.40),
    _P(w * 0.82, w * 0.40),
    _P(w * 0.22, w * 0.78),
    _P(w * 0.78, w * 0.78),
  ];
  for (final p in positions) {
    _drawSparkle(image, p.x, p.y, 50 * s, img.ColorRgba8(255, 255, 255, 230));
  }
}

void _drawSparkle(img.Image image, double cx, double cy, double size, img.Color c) {
  // 4 nöqtəli ulduz: 2 ellips çarpaz
  final v = <_P>[
    _P(cx, cy - size),
    _P(cx + size * 0.18, cy - size * 0.18),
    _P(cx + size, cy),
    _P(cx + size * 0.18, cy + size * 0.18),
    _P(cx, cy + size),
    _P(cx - size * 0.18, cy + size * 0.18),
    _P(cx - size, cy),
    _P(cx - size * 0.18, cy - size * 0.18),
  ];
  _fillPolygonAA(image, v, c);
}

// ───────────────────── HELPERS ─────────────────────

class _P {
  final double x;
  final double y;
  _P(num x, num y)
      : x = x.toDouble(),
        y = y.toDouble();
}

List<double> _polyIntersections(List<_P> pts, double y) {
  final out = <double>[];
  for (var i = 0; i < pts.length; i++) {
    final a = pts[i];
    final b = pts[(i + 1) % pts.length];
    if ((a.y <= y && b.y > y) || (b.y <= y && a.y > y)) {
      final t = (y - a.y) / (b.y - a.y);
      out.add(a.x + t * (b.x - a.x));
    }
  }
  return out;
}

List<_P> _expandPolygon(List<_P> pts, double amount) {
  // Sadə approximate genişləndirmə: hər nöqtəni centroidan dışarı it
  double cx = 0, cy = 0;
  for (final p in pts) {
    cx += p.x;
    cy += p.y;
  }
  cx /= pts.length;
  cy /= pts.length;
  return pts.map((p) {
    final dx = p.x - cx;
    final dy = p.y - cy;
    final d = math.sqrt(dx * dx + dy * dy);
    if (d == 0) return p;
    return _P(p.x + dx / d * amount, p.y + dy / d * amount);
  }).toList();
}

img.Color _lerp(img.Color a, img.Color b, double t) {
  t = t.clamp(0.0, 1.0);
  final r = (a.r + (b.r - a.r) * t).round();
  final g = (a.g + (b.g - a.g) * t).round();
  final bl = (a.b + (b.b - a.b) * t).round();
  return img.ColorRgb8(r, g, bl);
}

void _blend(img.Image image, int x, int y, img.Color c) {
  if (x < 0 || x >= image.width || y < 0 || y >= image.height) return;
  final a = c.a / 255.0;
  if (a >= 1.0) {
    image.setPixel(x, y, c);
    return;
  }
  final cur = image.getPixel(x, y);
  final r = (cur.r * (1 - a) + c.r * a).round();
  final g = (cur.g * (1 - a) + c.g * a).round();
  final b = (cur.b * (1 - a) + c.b * a).round();
  final newA = math.max(cur.a.toInt(), c.a.toInt());
  image.setPixel(x, y, img.ColorRgba8(r, g, b, newA));
}

void _fillRectAA(img.Image image, num x1, num y1, num x2, num y2, img.Color c) {
  final xa = math.min(x1, x2).toInt();
  final ya = math.min(y1, y2).toInt();
  final xb = math.max(x1, x2).toInt();
  final yb = math.max(y1, y2).toInt();
  for (var y = ya; y <= yb; y++) {
    for (var x = xa; x <= xb; x++) {
      _blend(image, x, y, c);
    }
  }
}

void _fillCircleAA(img.Image image, int cx, int cy, int r, img.Color c) {
  final r2 = r * r;
  for (var y = cy - r - 1; y <= cy + r + 1; y++) {
    for (var x = cx - r - 1; x <= cx + r + 1; x++) {
      final dx = x - cx;
      final dy = y - cy;
      final d2 = dx * dx + dy * dy;
      if (d2 <= r2) {
        _blend(image, x, y, c);
      } else if (d2 <= (r + 1) * (r + 1)) {
        final d = math.sqrt(d2);
        final a = ((r + 1 - d) * c.a).round();
        _blend(image, x, y, img.ColorRgba8(c.r.toInt(), c.g.toInt(), c.b.toInt(), a.clamp(0, 255)));
      }
    }
  }
}

void _fillPolygonAA(img.Image image, List<_P> pts, img.Color c) {
  if (pts.length < 3) return;
  final minY = pts.map((p) => p.y).reduce(math.min).floor();
  final maxY = pts.map((p) => p.y).reduce(math.max).ceil();
  for (var y = minY; y <= maxY; y++) {
    final inters = _polyIntersections(pts, y.toDouble());
    inters.sort();
    for (var i = 0; i + 1 < inters.length; i += 2) {
      final x1 = inters[i].floor();
      final x2 = inters[i + 1].ceil();
      for (var x = x1; x <= x2; x++) {
        _blend(image, x, y, c);
      }
    }
  }
}

void _fillTrapezoid(img.Image image, _P a, _P b, _P c, _P d, img.Color color) {
  _fillPolygonAA(image, [a, b, c, d], color);
}

void _strokePolygon(img.Image image, List<_P> pts, img.Color c, double thickness) {
  for (var i = 0; i < pts.length; i++) {
    final a = pts[i];
    final b = pts[(i + 1) % pts.length];
    _drawLineAA(image, a.x, a.y, b.x, b.y, c, thickness);
  }
}

void _drawLineAA(img.Image image, double x0, double y0, double x1, double y1, img.Color c, double thickness) {
  final dx = x1 - x0;
  final dy = y1 - y0;
  final len = math.sqrt(dx * dx + dy * dy);
  final steps = (len * 2).ceil();
  final r = (thickness / 2).ceil();
  for (var i = 0; i <= steps; i++) {
    final t = i / steps;
    final x = (x0 + dx * t).round();
    final y = (y0 + dy * t).round();
    _fillCircleAA(image, x, y, r, c);
  }
}
