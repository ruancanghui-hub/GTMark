/// 提前提醒选项（分钟）— 闭环详规可多选。
const kAdvanceMinuteOptions = <int, String>{
  0: '准时',
  10: '提前 10 分钟',
  60: '提前 1 小时',
  1440: '提前 1 天',
  4320: '提前 3 天',
  10080: '提前 7 天',
};

/// 新建提醒默认提前 1 天（详规 B5）。
const kDefaultAdvanceMinutes = <int>[1440];

List<int> parseAdvanceMinutesList(String raw) {
  if (raw.isEmpty) return List<int>.from(kDefaultAdvanceMinutes);
  final parts = raw.contains(',') ? raw.split(',') : [raw];
  final list = parts
      .map((e) => int.tryParse(e.trim()))
      .whereType<int>()
      .where((m) => kAdvanceMinuteOptions.containsKey(m))
      .toSet()
      .toList()
    ..sort();
  return list.isEmpty ? [0] : list;
}

String formatAdvanceMinutesList(List<int> list) {
  if (list.isEmpty) return '0';
  return (list.toSet().toList()..sort()).join(',');
}

String advanceMinutesLabel(List<int> list) {
  if (list.isEmpty || (list.length == 1 && list.first == 0)) {
    return '准时';
  }
  return list
      .where((m) => m > 0)
      .map((m) => kAdvanceMinuteOptions[m] ?? '提前 $m 分钟')
      .join('、');
}

/// 所有可能需要取消的通知 id 偏移（用于 cancel）。
Iterable<int> allAdvanceSlotKeys() => kAdvanceMinuteOptions.keys;
