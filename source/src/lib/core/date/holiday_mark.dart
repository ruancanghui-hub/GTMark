import 'package:lunar/lunar.dart';

import 'calendar_data_meta.dart';

/// 法定节假日的休/班标记（调休）。
enum HolidayMarkKind { none, rest, workAdjust }

class HolidayMarkInfo {
  const HolidayMarkInfo({
    required this.kind,
    this.name,
    this.shortLabel,
  });

  final HolidayMarkKind kind;
  final String? name;
  final String? shortLabel;

  bool get hasMark => kind != HolidayMarkKind.none;
}

/// 解析 [HolidayUtil] 调休数据。
abstract final class HolidayMarkService {
  static HolidayMarkInfo resolve(DateTime date) {
    final h = HolidayUtil.getHolidayByYmd(date.year, date.month, date.day);
    if (h == null) {
      return const HolidayMarkInfo(kind: HolidayMarkKind.none);
    }
    if (h.isWork()) {
      return HolidayMarkInfo(
        kind: HolidayMarkKind.workAdjust,
        name: h.getName(),
        shortLabel: '班·${_shortName(h.getName())}',
      );
    }
    return HolidayMarkInfo(
      kind: HolidayMarkKind.rest,
      name: h.getName(),
      shortLabel: '休·${_shortName(h.getName())}',
    );
  }

  static String _shortName(String name) {
    return name
        .replaceAll('节', '')
        .replaceAll('元旦', '元旦')
        .replaceAll('劳动', '劳动');
  }

  static String sourceCaption() => CalendarDataMeta.holidayUpdatedAt();
}
