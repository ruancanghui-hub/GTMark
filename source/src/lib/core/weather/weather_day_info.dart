/// 单日天气摘要与风险标签（SPEC-016 / LOOP-005）。
class WeatherDayInfo {
  const WeatherDayInfo({
    required this.date,
    this.precipitationProbMax,
    this.tempMaxC,
    this.tempMinC,
    this.aqi,
    this.fetchedAt,
    this.offline = false,
    this.unavailable = false,
  });

  final DateTime date;
  final double? precipitationProbMax;
  final double? tempMaxC;
  final double? tempMinC;
  final int? aqi;
  final DateTime? fetchedAt;
  final bool offline;
  final bool unavailable;

  /// 风险标签：可能有雨 / 高温 / 低温 / 空气差
  List<String> get riskLabels {
    if (unavailable) return const [];
    final labels = <String>[];
    if (precipitationProbMax != null && precipitationProbMax! >= 60) {
      labels.add('可能有雨');
    }
    if (tempMaxC != null && tempMaxC! >= 35) labels.add('高温');
    if (tempMinC != null && tempMinC! <= 0) labels.add('低温');
    if (aqi != null && aqi! > 150) labels.add('空气差');
    return labels;
  }

  bool get hasRisk => riskLabels.isNotEmpty;

  /// 首页天气一行：仅温度与有意义的天气词，不含 AQI / 降雨概率数字。
  String? get homeSummaryLine {
    if (unavailable) return null;
    final parts = <String>[];
    if (tempMinC != null && tempMaxC != null) {
      parts.add('${tempMinC!.round()}~${tempMaxC!.round()}°C');
    } else if (tempMaxC != null) {
      parts.add('最高 ${tempMaxC!.round()}°C');
    }
    if (precipitationProbMax != null && precipitationProbMax! >= 60) {
      parts.add('降雨');
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// 详情页一行摘要：温度 / 降雨 / AQI。
  String? get summaryLine {
    if (unavailable) return null;
    final parts = <String>[];
    if (tempMinC != null && tempMaxC != null) {
      parts.add('${tempMinC!.round()}~${tempMaxC!.round()}°C');
    } else if (tempMaxC != null) {
      parts.add('最高 ${tempMaxC!.round()}°C');
    }
    if (precipitationProbMax != null) {
      parts.add('降雨 ${precipitationProbMax!.round()}%');
    }
    if (aqi != null) parts.add('AQI $aqi');
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String get sourceCaption {
    if (unavailable) return '天气暂不可用 · Open-Meteo';
    final t = fetchedAt;
    final prefix = offline ? '离线缓存' : 'Open-Meteo';
    if (t == null) return prefix;
    return '$prefix · 更新于 ${t.month}/${t.day} ${t.hour}:${t.minute.toString().padLeft(2, '0')}';
  }
}
