import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalGameStats {
  final int bonusXp;
  final int bonusCoins;
  final int extraWins;
  final int extraLosses;
  final int extraDraws;

  const LocalGameStats({
    this.bonusXp = 0,
    this.bonusCoins = 0,
    this.extraWins = 0,
    this.extraLosses = 0,
    this.extraDraws = 0,
  });

  LocalGameStats copyWith({
    int? bonusXp,
    int? bonusCoins,
    int? extraWins,
    int? extraLosses,
    int? extraDraws,
  }) {
    return LocalGameStats(
      bonusXp: bonusXp ?? this.bonusXp,
      bonusCoins: bonusCoins ?? this.bonusCoins,
      extraWins: extraWins ?? this.extraWins,
      extraLosses: extraLosses ?? this.extraLosses,
      extraDraws: extraDraws ?? this.extraDraws,
    );
  }
}

enum GameOutcome { win, loss, draw, none }

class LocalGameStatsNotifier extends StateNotifier<LocalGameStats> {
  LocalGameStatsNotifier() : super(const LocalGameStats()) {
    _load();
  }

  static const _keyXp = 'local_bonus_xp';
  static const _keyCoins = 'local_bonus_coins';
  static const _keyWins = 'local_extra_wins';
  static const _keyLosses = 'local_extra_losses';
  static const _keyDraws = 'local_extra_draws';

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = LocalGameStats(
      bonusXp: p.getInt(_keyXp) ?? 0,
      bonusCoins: p.getInt(_keyCoins) ?? 0,
      extraWins: p.getInt(_keyWins) ?? 0,
      extraLosses: p.getInt(_keyLosses) ?? 0,
      extraDraws: p.getInt(_keyDraws) ?? 0,
    );
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_keyXp, state.bonusXp);
    await p.setInt(_keyCoins, state.bonusCoins);
    await p.setInt(_keyWins, state.extraWins);
    await p.setInt(_keyLosses, state.extraLosses);
    await p.setInt(_keyDraws, state.extraDraws);
  }

  Future<void> addReward({
    int xp = 0,
    int coins = 0,
    GameOutcome outcome = GameOutcome.none,
  }) async {
    state = state.copyWith(
      bonusXp: state.bonusXp + xp,
      bonusCoins: state.bonusCoins + coins,
      extraWins: outcome == GameOutcome.win ? state.extraWins + 1 : state.extraWins,
      extraLosses: outcome == GameOutcome.loss ? state.extraLosses + 1 : state.extraLosses,
      extraDraws: outcome == GameOutcome.draw ? state.extraDraws + 1 : state.extraDraws,
    );
    await _save();
  }

  Future<void> reset() async {
    state = const LocalGameStats();
    await _save();
  }
}

final localGameStatsProvider =
    StateNotifierProvider<LocalGameStatsNotifier, LocalGameStats>((ref) {
  return LocalGameStatsNotifier();
});
