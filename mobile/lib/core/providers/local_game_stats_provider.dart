import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/providers/user_provider.dart';

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
  LocalGameStatsNotifier(this._ref) : super(const LocalGameStats()) {
    _load();
  }

  final Ref _ref;
  bool _syncing = false;

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
    // Tətbiq başlayanda yığılmış pending statistikanı backend-ə göndər.
    unawaited(flushToBackend());
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
    // Backend-ə göndərməyi sınamağa cəhd et (uğursuz olarsa, queue-da qalır).
    unawaited(flushToBackend());
  }

  /// Lokal queue-da yığılan pending mükafatları backend-ə göndərir.
  /// Uğurda lokal sıfırlanır, profil refresh olur. Xəta halında saxlanılır.
  Future<bool> flushToBackend() async {
    if (_syncing) return false;
    final pending = state;
    if (pending.bonusXp == 0 &&
        pending.bonusCoins == 0 &&
        pending.extraWins == 0 &&
        pending.extraLosses == 0 &&
        pending.extraDraws == 0) {
      return true;
    }
    _syncing = true;
    try {
      final repo = _ref.read(userRepositoryProvider);
      await repo.applyReward(
        xp: pending.bonusXp,
        coins: pending.bonusCoins,
        wins: pending.extraWins,
        losses: pending.extraLosses,
        draws: pending.extraDraws,
      );
      // Sinxron uğurlu — pending-i sıfırla.
      state = const LocalGameStats();
      await _save();
      // Yeni profili gətir.
      _ref.invalidate(userProfileProvider);
      return true;
    } catch (_) {
      // Şəbəkə/auth xətası — queue-da qalsın, növbəti girişdə təkrar cəhd.
      return false;
    } finally {
      _syncing = false;
    }
  }

  Future<void> reset() async {
    state = const LocalGameStats();
    await _save();
  }
}

final localGameStatsProvider =
    StateNotifierProvider<LocalGameStatsNotifier, LocalGameStats>((ref) {
  return LocalGameStatsNotifier(ref);
});
