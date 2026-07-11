import 'package:flutter/foundation.dart';
import 'package:lunar/lunar.dart';

import '../prefs/jichen_prefs.dart';
import 'content_repository.dart';
import 'poem_entry.dart';

/// 日期 / 个人事项 → 诗句库 ID。
///
/// 优先级：P1 农历传统 `tf_*` → P2 法定/现代 `md_*` → P3 节气 `st_*`。
abstract final class PoemResolver {
  static final Map<String, DateTime?> _solarTermDateCache = {};
  static final Map<int, DateTime?> _hanshiSolarDateCache = {};
  static final Map<String, int> _solarTermScanCounts = {};

  static const _jieqiToSt = <String, String>{
    '立春': 'st_lichun',
    '雨水': 'st_yushui',
    '惊蛰': 'st_jingzhe',
    '春分': 'st_chunfen',
    '清明': 'st_qingming',
    '谷雨': 'st_guyu',
    '立夏': 'st_lixia',
    '小满': 'st_xiaoman',
    '芒种': 'st_mangzhong',
    '夏至': 'st_xiazhi',
    '小暑': 'st_xiaoshu',
    '大暑': 'st_dashu',
    '立秋': 'st_liqiu',
    '处暑': 'st_chushu',
    '白露': 'st_bailu',
    '秋分': 'st_qiufen',
    '寒露': 'st_hanlu',
    '霜降': 'st_shuangjiang',
    '立冬': 'st_lidong',
    '小雪': 'st_xiaoxue',
    '大雪': 'st_daxue',
    '冬至': 'st_dongzhi',
    '小寒': 'st_xiaohan',
    '大寒': 'st_dahan',
  };

  /// 仅 P1/P2（节日），不含节气。
  static String? festivalIdForDate(
    DateTime date, {
    XiaonianRegion? xiaonianRegion,
  }) {
    return _traditionalFestivalId(date, xiaonianRegion: xiaonianRegion) ??
        _modernFestivalId(date);
  }

  /// P1 → P2 → P3 完整解析。
  static String? resolveIdForDate(
    DateTime date, {
    XiaonianRegion? xiaonianRegion,
  }) {
    return festivalIdForDate(date, xiaonianRegion: xiaonianRegion) ??
        solarTermIdForDate(date);
  }

  /// P3 节气 ID（当日 [Lunar.getJieQi] 命中时）。
  static String? solarTermIdForDate(DateTime date) {
    final jq = Lunar.fromDate(date).getJieQi().trim();
    if (jq.isEmpty) return null;
    return _jieqiToSt[jq];
  }

  /// 腊月廿三/廿四是否为小年（不考虑地区偏好）。
  static bool isXiaonianSolarDay(DateTime date) {
    final lunar = Lunar.fromDate(date);
    return lunar.getMonth().abs() == 12 &&
        (lunar.getDay() == 23 || lunar.getDay() == 24);
  }

  /// 小年习俗变体：`north` 廿三 / `south` 廿四。
  static String? xiaonianVariant(DateTime date) {
    if (!isXiaonianSolarDay(date)) return null;
    final d = Lunar.fromDate(date).getDay();
    if (d == 23) return 'north';
    if (d == 24) return 'south';
    return null;
  }

  static String? xiaonianDisplayName(DateTime date) {
    final v = xiaonianVariant(date);
    return switch (v) {
      'north' => '北方小年',
      'south' => '南方小年',
      _ => null,
    };
  }

  static String? personalBirthdayId(String relation) {
    switch (relation) {
      case 'parent':
        return 'bd_parent';
      case 'elder':
        return 'bd_elder';
      case 'spouse':
        return 'bd_spouse';
      case 'peer':
        return 'bd_peer';
      case 'child':
        return 'bd_child';
      case 'self':
        return 'bd_self';
      default:
        return null;
    }
  }

  static String? personalAnniversaryId(String subtype) {
    switch (subtype) {
      case 'wedding':
        return 'an_wedding';
      case 'love':
        return 'an_love';
      case 'family':
        return 'an_family';
      case 'work':
        return 'an_work';
      case 'custom':
        return 'an_custom';
      default:
        return null;
    }
  }

  static String? personalCountdownId(String theme) {
    switch (theme) {
      case 'time':
      case 'travel':
      case 'exam':
        return 'cd_$theme';
      default:
        return 'cd_time';
    }
  }

  /// Clears isolate-local date caches and diagnostics between tests.
  @visibleForTesting
  static void debugResetCaches() {
    _solarTermDateCache.clear();
    _hanshiSolarDateCache.clear();
    _solarTermScanCounts.clear();
  }

  /// Returns how often a full-year scan ran for [year] and [jieQiName].
  @visibleForTesting
  static int debugSolarTermScanCount(int year, String jieQiName) {
    return _solarTermScanCounts[_solarTermCacheKey(year, jieQiName)] ?? 0;
  }

  static PoemBundle? resolveForDate(DateTime date) {
    final id = resolveIdForDate(date);
    if (id == null) return null;
    return ContentRepository.instance.poemBundle(id);
  }

  static PoemBundle? resolveForBirthday({required String relation}) {
    final id = personalBirthdayId(relation);
    if (id == null) return null;
    return ContentRepository.instance.poemBundle(id);
  }

  static PoemBundle? resolveForAnniversary({required String subtype}) {
    final id = personalAnniversaryId(subtype);
    if (id == null) return null;
    return ContentRepository.instance.poemBundle(id);
  }

  static PoemBundle? resolveForCountdown({String theme = 'time'}) {
    final id = personalCountdownId(theme);
    if (id == null) return null;
    return ContentRepository.instance.poemBundle(id);
  }

  static String? _traditionalFestivalId(
    DateTime date, {
    XiaonianRegion? xiaonianRegion,
  }) {
    if (_isChuxi(date)) return 'tf_chuxi';

    final lunar = Lunar.fromDate(date);
    final m = lunar.getMonth().abs();
    final d = lunar.getDay();

    if (m == 1 && d == 1) return 'tf_chunjie';
    if (m == 1 && d == 15) return 'tf_yuanxiao';
    if (m == 2 && d == 2) return 'tf_longtaitou';
    if (m == 3 && d == 3) return 'tf_shangsi';
    if (_isQingmingDay(date)) return 'tf_qingming';
    if (_isHanshi(date)) return 'tf_hanshi';
    if (m == 5 && d == 5) return 'tf_duanwu';
    if (m == 7 && d == 7) return 'tf_qixi';
    if (m == 7 && d == 15) return 'tf_zhongyuan';
    if (m == 8 && d == 15) return 'tf_zhongqiu';
    if (m == 9 && d == 9) return 'tf_chongyang';
    if (m == 10 && d == 1) return 'tf_hanyi';
    if (m == 10 && d == 15) return 'tf_xiayuan';
    if (m == 12 && d == 8) return 'tf_laba';
    if (_isXiaonian(date, xiaonianRegion: xiaonianRegion)) {
      return 'tf_xiaonian';
    }

    return null;
  }

  static String? _modernFestivalId(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    if (m == 1 && d == 1) return 'md_yuandan';
    if (m == 3 && d == 8) return 'md_women';
    if (m == 3 && d == 12) return 'md_arbor';
    if (m == 5 && d == 1) return 'md_labor';
    if (m == 5 && d == 4) return 'md_qingnian';
    if (m == 6 && d == 1) return 'md_children';
    if (m == 7 && d == 1) return 'md_party';
    if (m == 8 && d == 1) return 'md_army';
    if (m == 9 && d == 10) return 'md_teacher';
    if (m == 10 && d == 1) return 'md_national';

    if (_isSameDay(date, _nthWeekdayOfMonth(y, 5, DateTime.sunday, 2))) {
      return 'md_mothers';
    }
    if (_isSameDay(date, _nthWeekdayOfMonth(y, 8, DateTime.sunday, 3))) {
      return 'md_fathers';
    }

    return null;
  }

  static bool _isXiaonian(DateTime date, {XiaonianRegion? xiaonianRegion}) {
    if (!isXiaonianSolarDay(date)) return false;
    final d = Lunar.fromDate(date).getDay();
    switch (xiaonianRegion ?? JichenPrefs.xiaonianRegion) {
      case XiaonianRegion.north:
        return d == 23;
      case XiaonianRegion.south:
        return d == 24;
      case XiaonianRegion.both:
        return d == 23 || d == 24;
    }
  }

  static bool _isChuxi(DateTime date) {
    final tomorrow = Lunar.fromDate(date.add(const Duration(days: 1)));
    return tomorrow.getMonth() == 1 && tomorrow.getDay() == 1;
  }

  static bool _isQingmingDay(DateTime date) {
    return Lunar.fromDate(date).getJieQi().trim() == '清明';
  }

  /// 寒食：冬至后第 105 日（取清明所在公历年的前一次冬至），或清明前 1–2 日。
  static bool _isHanshi(DateTime date) {
    final day = _dateOnly(date);
    final hanshi = _hanshiSolarDate(date.year);
    if (hanshi != null && _isSameDay(day, hanshi)) return true;
    final qm = _solarTermDate(date.year, '清明');
    if (qm == null) return false;
    for (final offset in [1, 2]) {
      if (_isSameDay(day, qm.subtract(Duration(days: offset)))) return true;
    }
    return false;
  }

  static DateTime? _hanshiSolarDate(int year) {
    if (_hanshiSolarDateCache.containsKey(year)) {
      return _hanshiSolarDateCache[year];
    }
    final dongzhi = _solarTermDate(year - 1, '冬至');
    final result = dongzhi?.add(const Duration(days: 105));
    _hanshiSolarDateCache[year] = result;
    return result;
  }

  static DateTime? _solarTermDate(int year, String jieQiName) {
    final key = _solarTermCacheKey(year, jieQiName);
    if (_solarTermDateCache.containsKey(key)) {
      return _solarTermDateCache[key];
    }
    _solarTermScanCounts[key] = (_solarTermScanCounts[key] ?? 0) + 1;
    for (var m = 1; m <= 12; m++) {
      final daysInMonth = DateTime(year, m + 1, 0).day;
      for (var d = 1; d <= daysInMonth; d++) {
        final dt = DateTime(year, m, d);
        if (Lunar.fromDate(dt).getJieQi().trim() == jieQiName) {
          final result = _dateOnly(dt);
          _solarTermDateCache[key] = result;
          return result;
        }
      }
    }
    _solarTermDateCache[key] = null;
    return null;
  }

  static String _solarTermCacheKey(int year, String jieQiName) {
    return '$year:$jieQiName';
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime _nthWeekdayOfMonth(int year, int month, int weekday, int n) {
    var count = 0;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (var d = 1; d <= daysInMonth; d++) {
      final dt = DateTime(year, month, d);
      if (dt.weekday == weekday) {
        count++;
        if (count == n) return dt;
      }
    }
    return DateTime(year, month, 1);
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
