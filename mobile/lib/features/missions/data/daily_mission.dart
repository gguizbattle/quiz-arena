import 'dart:convert';

/// Hər mission template-i hansı oyun hadisəsinə bağlıdır.
enum MissionType {
  playMatch,       // istənilən oyun (1v1, bot, solo) oyna
  winMatch,        // 1v1 və ya bot qələbəsi
  answerCorrect,   // düz cavab ver
  fastAnswer,      // 5 saniyə ərzində düz cavab
  winStreak,       // ardıcıl qələbə (current streak >= target)
}

enum MissionReward { xp, coins }

class DailyMission {
  final String id;            // unikal: "playMatch_3"
  final MissionType type;
  final int target;
  final int progress;
  final MissionReward reward;
  final int rewardAmount;
  final bool claimed;

  const DailyMission({
    required this.id,
    required this.type,
    required this.target,
    required this.progress,
    required this.reward,
    required this.rewardAmount,
    required this.claimed,
  });

  bool get isCompleted => progress >= target;

  DailyMission copyWith({int? progress, bool? claimed}) => DailyMission(
        id: id,
        type: type,
        target: target,
        progress: progress ?? this.progress,
        reward: reward,
        rewardAmount: rewardAmount,
        claimed: claimed ?? this.claimed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'target': target,
        'progress': progress,
        'reward': reward.name,
        'rewardAmount': rewardAmount,
        'claimed': claimed,
      };

  factory DailyMission.fromJson(Map<String, dynamic> j) => DailyMission(
        id: j['id'] as String,
        type: MissionType.values.firstWhere((e) => e.name == j['type']),
        target: (j['target'] as num).toInt(),
        progress: (j['progress'] as num).toInt(),
        reward: MissionReward.values.firstWhere((e) => e.name == j['reward']),
        rewardAmount: (j['rewardAmount'] as num).toInt(),
        claimed: j['claimed'] as bool? ?? false,
      );

  static String encodeList(List<DailyMission> list) =>
      jsonEncode(list.map((m) => m.toJson()).toList());

  static List<DailyMission> decodeList(String raw) {
    final list = jsonDecode(raw) as List;
    return list.map((e) => DailyMission.fromJson(e as Map<String, dynamic>)).toList();
  }
}
