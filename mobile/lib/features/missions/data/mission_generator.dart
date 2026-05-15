import 'dart:math';
import 'daily_mission.dart';

/// Səviyyəyə uyğun mission seti yaradır.
/// Hər gün 3 mission: 2x XP, 1x coin (coin az verir).
class MissionGenerator {
  MissionGenerator(this.level, {int? seed}) : _rnd = Random(seed);

  final int level;
  final Random _rnd;

  /// Çətinlik tier-i: 1-5 easy, 6-15 medium, 16+ hard.
  /// Tier target və mükafat çarpanını təyin edir.
  int get _tier {
    if (level <= 5) return 0;
    if (level <= 15) return 1;
    return 2;
  }

  /// Target ranges per tier (min, max).
  static const _playRanges = [(2, 4), (4, 7), (6, 10)];
  static const _winRanges = [(1, 2), (2, 4), (3, 6)];
  static const _correctRanges = [(8, 15), (15, 25), (20, 35)];
  static const _fastRanges = [(3, 5), (5, 9), (8, 14)];
  static const _streakRanges = [(2, 2), (2, 3), (3, 4)];

  /// XP reward — tier-ə görə artır.
  static const _xpBase = [120, 180, 260];
  /// Coin reward — KASIB (XP-nin ~1/4-i).
  static const _coinBase = [25, 40, 65];

  int _xpFor(MissionType type) {
    final base = _xpBase[_tier];
    return switch (type) {
      MissionType.playMatch => base,
      MissionType.winMatch => (base * 1.3).round(),
      MissionType.answerCorrect => base,
      MissionType.fastAnswer => (base * 1.2).round(),
      MissionType.winStreak => (base * 1.5).round(),
    };
  }

  int _coinsFor(MissionType type) {
    final base = _coinBase[_tier];
    return switch (type) {
      MissionType.playMatch => base,
      MissionType.winMatch => (base * 1.2).round(),
      MissionType.answerCorrect => base,
      MissionType.fastAnswer => (base * 1.3).round(),
      MissionType.winStreak => (base * 1.5).round(),
    };
  }

  int _pickInRange((int, int) range) {
    final (lo, hi) = range;
    if (lo == hi) return lo;
    return lo + _rnd.nextInt(hi - lo + 1);
  }

  int _targetFor(MissionType type) {
    final r = switch (type) {
      MissionType.playMatch => _playRanges[_tier],
      MissionType.winMatch => _winRanges[_tier],
      MissionType.answerCorrect => _correctRanges[_tier],
      MissionType.fastAnswer => _fastRanges[_tier],
      MissionType.winStreak => _streakRanges[_tier],
    };
    return _pickInRange(r);
  }

  DailyMission _build(MissionType type, MissionReward reward) {
    final target = _targetFor(type);
    final amount = reward == MissionReward.xp ? _xpFor(type) : _coinsFor(type);
    return DailyMission(
      id: '${type.name}_$target',
      type: type,
      target: target,
      progress: 0,
      reward: reward,
      rewardAmount: amount,
      claimed: false,
    );
  }

  /// 3 mission qaytarır: 2 XP + 1 coin.
  List<DailyMission> generate() {
    final allTypes = MissionType.values.toList()..shuffle(_rnd);
    final picked = allTypes.take(3).toList();

    // Coin mükafatı təsadüfi 1 nəfərə düşür.
    final coinIndex = _rnd.nextInt(3);

    return List.generate(3, (i) {
      final reward = i == coinIndex ? MissionReward.coins : MissionReward.xp;
      return _build(picked[i], reward);
    });
  }
}
