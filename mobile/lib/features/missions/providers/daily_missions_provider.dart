import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/daily_mission.dart';
import '../data/mission_generator.dart';

class DailyMissionsState {
  final List<DailyMission> missions;
  final DateTime? lastGenerated; // gün başlanğıcı (local)
  final int currentStreak;       // ardıcıl qələbə sayı

  const DailyMissionsState({
    this.missions = const [],
    this.lastGenerated,
    this.currentStreak = 0,
  });

  DailyMissionsState copyWith({
    List<DailyMission>? missions,
    DateTime? lastGenerated,
    int? currentStreak,
  }) =>
      DailyMissionsState(
        missions: missions ?? this.missions,
        lastGenerated: lastGenerated ?? this.lastGenerated,
        currentStreak: currentStreak ?? this.currentStreak,
      );

  /// Növbəti yenilənməyə qədər qalan müddət.
  Duration timeUntilRefresh(DateTime now) {
    final nextMidnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return nextMidnight.difference(now);
  }
}

class DailyMissionsNotifier extends StateNotifier<DailyMissionsState> {
  DailyMissionsNotifier() : super(const DailyMissionsState()) {
    _load();
  }

  static const _keyMissions = 'daily_missions_v1';
  static const _keyDate = 'daily_missions_date';
  static const _keyLevel = 'daily_missions_level';
  static const _keyStreak = 'win_streak';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> _load() async {
    final p = await _prefs;
    final dateStr = p.getString(_keyDate);
    final raw = p.getString(_keyMissions);
    final streak = p.getInt(_keyStreak) ?? 0;

    if (raw != null && dateStr != null) {
      try {
        state = DailyMissionsState(
          missions: DailyMission.decodeList(raw),
          lastGenerated: DateTime.parse(dateStr),
          currentStreak: streak,
        );
      } catch (_) {
        // Korrupt data — yenidən generate ediləcək
      }
    } else {
      state = state.copyWith(currentStreak: streak);
    }
  }

  Future<void> _save() async {
    final p = await _prefs;
    await p.setString(_keyMissions, DailyMission.encodeList(state.missions));
    if (state.lastGenerated != null) {
      await p.setString(_keyDate, state.lastGenerated!.toIso8601String());
    }
    await p.setInt(_keyStreak, state.currentStreak);
  }

  /// Bugün üçün missionlar yoxdursa və ya 24 saat keçibsə yenidən generate et.
  /// Səviyyə də saxlanılır ki, level-up zamanı çətinlik artsın.
  Future<void> ensureFresh(int level) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final p = await _prefs;
    final storedLevel = p.getInt(_keyLevel) ?? 0;

    final needsNew = state.lastGenerated == null ||
        state.missions.isEmpty ||
        state.lastGenerated!.isBefore(today) ||
        storedLevel != level;

    if (!needsNew) return;

    final gen = MissionGenerator(level, seed: today.millisecondsSinceEpoch);
    state = state.copyWith(
      missions: gen.generate(),
      lastGenerated: today,
    );
    await p.setInt(_keyLevel, level);
    await _save();
  }

  /// Progress artırır. `fastAnswer` üçün count = düz cavab sayı (≤ 5 san).
  Future<void> incrementProgress(MissionType type, int count) async {
    if (count <= 0) return;
    final updated = state.missions.map((m) {
      if (m.type != type || m.isCompleted) return m;
      final newProgress = (m.progress + count).clamp(0, m.target);
      return m.copyWith(progress: newProgress);
    }).toList();
    state = state.copyWith(missions: updated);
    await _save();
  }

  /// Win streak-i set et. winStreak missionunu da progress kimi yenilə.
  Future<void> updateStreak(bool won) async {
    final newStreak = won ? state.currentStreak + 1 : 0;
    final updated = state.missions.map((m) {
      if (m.type != MissionType.winStreak || m.isCompleted) return m;
      final newProgress = newStreak.clamp(0, m.target);
      return m.copyWith(progress: newProgress > m.progress ? newProgress : m.progress);
    }).toList();
    state = state.copyWith(missions: updated, currentStreak: newStreak);
    await _save();
  }

  /// Mükafatı tələb et — claimed=true qoyur, qaytarır (reward, amount).
  Future<(MissionReward, int)?> claim(String id) async {
    final idx = state.missions.indexWhere((m) => m.id == id);
    if (idx < 0) return null;
    final m = state.missions[idx];
    if (!m.isCompleted || m.claimed) return null;
    final updated = [...state.missions];
    updated[idx] = m.copyWith(claimed: true);
    state = state.copyWith(missions: updated);
    await _save();
    return (m.reward, m.rewardAmount);
  }
}

final dailyMissionsProvider =
    StateNotifierProvider<DailyMissionsNotifier, DailyMissionsState>((ref) {
  return DailyMissionsNotifier();
});
