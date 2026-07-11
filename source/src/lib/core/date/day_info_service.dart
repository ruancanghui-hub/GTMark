import 'package:lunar/lunar.dart';

import '../content/poem_resolver.dart';
import 'calendar_data_meta.dart';
import 'day_info.dart';
import 'holiday_mark.dart';
import 'huangli_plain.dart';
import 'lunar_helper.dart';

/// 由公历日构建农历、节气、节日、宜忌摘要。
abstract final class DayInfoService {
  static const _weekdayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  /// 测试黄历降级 UI 时使用。
  static bool debugForceHuangliEmpty = false;

  static DayInfo build(DateTime date, {DateTime? today}) {
    final local = DateTime(date.year, date.month, date.day);
    final now = today ?? DateTime.now();
    final todayLocal = DateTime(now.year, now.month, now.day);
    final solar = Solar.fromDate(local);
    final lunar = solar.getLunar();
    final jq = lunar.getJieQi().trim();

    final festivalId = PoemResolver.resolveIdForDate(local);
    final festivalName = _festivalDisplayName(local, festivalId, lunar);
    final holidayMark = HolidayMarkService.resolve(local);

    final yi = debugForceHuangliEmpty ? <String>[] : lunar.getDayYi();
    final ji = debugForceHuangliEmpty ? <String>[] : lunar.getDayJi();
    final xi = lunar.getDayPositionXiDesc();
    final cai = lunar.getDayPositionCaiDesc();

    return DayInfo(
      date: local,
      weekdayLabel: _weekdayLabels[local.weekday - 1],
      lunarLabel: lunarLabelForSolar(local),
      lunarDayName: lunarDayShortName(local),
      ganZhiDay: lunar.getDayInGanZhi(),
      shengXiao: lunar.getYearShengXiao(),
      chongDesc: lunar.getDayChongDesc(),
      positionXi: xi,
      positionCai: cai,
      plainYi: HuangliPlain.yiExplanation(yi),
      plainJi: HuangliPlain.jiExplanation(ji),
      holidayMark: holidayMark,
      jieQi: jq.isEmpty ? null : jq,
      festivalName: festivalName,
      festivalId: festivalId,
      yi: yi,
      ji: ji,
      isToday: local == todayLocal,
    );
  }

  static String huangliSourceCaption(DateTime date) =>
      CalendarDataMeta.huangliUpdatedAt(date);

  static String holidaySourceCaption() => HolidayMarkService.sourceCaption();

  static String? _festivalDisplayName(
    DateTime date,
    String? resolvedId,
    Lunar lunar,
  ) {
    if (resolvedId == 'tf_xiaonian') {
      return PoemResolver.xiaonianDisplayName(date) ?? '小年';
    }
    if (resolvedId != null) {
      final bundle = PoemResolver.resolveForDate(date);
      if (bundle != null) return bundle.name;
    }
    final fs = [...lunar.getFestivals(), ...lunar.getOtherFestivals()];
    if (fs.isNotEmpty) return fs.first;
    return null;
  }
}
