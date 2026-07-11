/// 择吉事项（闭环详规 MAT-01 … MAT-08）。
class ZejiMatter {
  const ZejiMatter({
    required this.id,
    required this.name,
    required this.description,
    this.yiKeywords = const [],
    this.jiBlockKeywords = const [],
    this.hardFilter = true,
  });

  final String id;
  final String name;
  final String description;
  final List<String> yiKeywords;
  final List<String> jiBlockKeywords;
  final bool hardFilter;

  static const all = [
    ZejiMatter(
      id: 'MAT-01',
      name: '搬家',
      description: '参考宜移徙、入宅；建议避开破日、四离四绝。传统文化参考，非专业择日。',
      yiKeywords: ['移徙', '入宅'],
      jiBlockKeywords: ['移徙', '入宅'],
    ),
    ZejiMatter(
      id: 'MAT-02',
      name: '祭扫',
      description: '参考宜祭祀、祈福；尊重各地习俗差异。',
      yiKeywords: ['祭祀', '祈福', '求嗣'],
      jiBlockKeywords: ['祭祀'],
    ),
    ZejiMatter(
      id: 'MAT-03',
      name: '结婚/订婚',
      description: '参考宜嫁娶、纳采；非八字合婚，重要决定请与家人商议。',
      yiKeywords: ['嫁娶', '纳采', '订盟'],
      jiBlockKeywords: ['嫁娶'],
    ),
    ZejiMatter(
      id: 'MAT-04',
      name: '出行',
      description: '参考宜出行、远行；请结合天气与行程安排。',
      yiKeywords: ['出行', '远行', '赴任'],
      jiBlockKeywords: ['出行'],
    ),
    ZejiMatter(
      id: 'MAT-05',
      name: '开业',
      description: '参考宜开市、立券；工商登记与消防等事项请自行办理。',
      yiKeywords: ['开市', '立券', '纳财'],
      jiBlockKeywords: ['开市'],
    ),
    ZejiMatter(
      id: 'MAT-06',
      name: '装修',
      description: '参考宜修造、动土；施工安全请自行评估。',
      yiKeywords: ['修造', '动土', '竖柱'],
      jiBlockKeywords: ['修造', '动土'],
    ),
    ZejiMatter(
      id: 'MAT-07',
      name: '签约',
      description: '参考宜订盟、纳财；合同条款请专业审阅。',
      yiKeywords: ['订盟', '纳财', '立券'],
      jiBlockKeywords: ['订盟'],
    ),
    ZejiMatter(
      id: 'MAT-08',
      name: '通用',
      description: '不做硬性宜忌过滤，按综合评分排序；仍标注调休与明显忌日。',
      hardFilter: false,
    ),
  ];

  static ZejiMatter byId(String id) =>
      all.firstWhere((m) => m.id == id, orElse: () => all.first);

  static ZejiMatter byName(String name) =>
      all.firstWhere((m) => m.name == name, orElse: () => all.first);
}

enum ZejiRangePreset { days7, days30, custom }

/// 择吉查询条件（LOOP-002）。
class ZejiQuery {
  const ZejiQuery({
    required this.matterId,
    required this.start,
    required this.end,
    this.skipWorkdayAdjust = false,
    this.weekendOnly = false,
    this.ignoreWeather = true,
  });

  final String matterId;
  final DateTime start;
  final DateTime end;
  final bool skipWorkdayAdjust;
  final bool weekendOnly;
  final bool ignoreWeather;

  int get dayCount => end.difference(start).inDays + 1;

  static const maxCustomDays = 90;

  static String? validateRange(DateTime start, DateTime end) {
    if (end.isBefore(start)) return '结束日期不能早于开始日期';
    final days = end.difference(start).inDays + 1;
    if (days > maxCustomDays) return '自定义范围最长 $maxCustomDays 天，请缩短';
    if (days < 1) return '请选择有效日期范围';
    return null;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static ZejiQuery preset7({
    required String matterId,
    bool skipWorkdayAdjust = false,
    bool weekendOnly = false,
    DateTime? from,
  }) {
    final base = _dateOnly(from ?? DateTime.now());
    return ZejiQuery(
      matterId: matterId,
      start: base,
      end: base.add(const Duration(days: 6)),
      skipWorkdayAdjust: skipWorkdayAdjust,
      weekendOnly: weekendOnly,
    );
  }

  static ZejiQuery preset30({
    required String matterId,
    bool skipWorkdayAdjust = false,
    bool weekendOnly = false,
    DateTime? from,
  }) {
    final base = _dateOnly(from ?? DateTime.now());
    return ZejiQuery(
      matterId: matterId,
      start: base,
      end: base.add(const Duration(days: 29)),
      skipWorkdayAdjust: skipWorkdayAdjust,
      weekendOnly: weekendOnly,
    );
  }

  ZejiQuery expandByDays(int extra) {
    return ZejiQuery(
      matterId: matterId,
      start: start,
      end: end.add(Duration(days: extra)),
      skipWorkdayAdjust: skipWorkdayAdjust,
      weekendOnly: weekendOnly,
      ignoreWeather: ignoreWeather,
    );
  }

  ZejiQuery copyWith({
    String? matterId,
    DateTime? start,
    DateTime? end,
    bool? skipWorkdayAdjust,
    bool? weekendOnly,
    bool? ignoreWeather,
  }) {
    return ZejiQuery(
      matterId: matterId ?? this.matterId,
      start: start ?? this.start,
      end: end ?? this.end,
      skipWorkdayAdjust: skipWorkdayAdjust ?? this.skipWorkdayAdjust,
      weekendOnly: weekendOnly ?? this.weekendOnly,
      ignoreWeather: ignoreWeather ?? this.ignoreWeather,
    );
  }
}
