import 'zeji_matter.dart';

/// 单日择吉推荐（LOOP-002）。
class ZejiRecommendation {
  const ZejiRecommendation({
    required this.date,
    required this.score,
    required this.reason,
    required this.matchedYi,
    this.workAdjust = false,
    this.restDay = false,
    this.weatherRiskLabels = const [],
    this.festivalConflict = false,
    this.festivalConflictLabel,
    this.reminderConflict = false,
    this.reminderConflictLabel,
    this.sparseHint = false,
  });

  final DateTime date;
  final int score;
  final String reason;
  final List<String> matchedYi;
  final bool workAdjust;
  final bool restDay;
  final List<String> weatherRiskLabels;
  final bool festivalConflict;
  final String? festivalConflictLabel;
  final bool reminderConflict;
  final String? reminderConflictLabel;
  final bool sparseHint;
}

/// 择吉搜索结果。
class ZejiSearchResult {
  const ZejiSearchResult({
    required this.query,
    required this.recommendations,
    this.scannedDays = 0,
    this.note,
    this.weatherSource,
  });

  final ZejiQuery query;
  final List<ZejiRecommendation> recommendations;
  final int scannedDays;
  final String? note;
  final String? weatherSource;

  bool get isEmpty => recommendations.isEmpty;
}
