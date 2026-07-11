import 'package:hugeicons/hugeicons.dart';

/// 节日提醒行图标（Hugeicons 近似设计稿）。
List<List<dynamic>> festivalReminderIcon(String id) {
  return switch (id) {
    'tf_chunjie' => HugeIcons.strokeRoundedLantern,
    'tf_qingming' => HugeIcons.strokeRoundedLeaf01,
    'tf_duanwu' => HugeIcons.strokeRoundedRiceBowl01,
    'tf_zhongqiu' => HugeIcons.strokeRoundedMoon02,
    'tf_yuanxiao' => HugeIcons.strokeRoundedRiceBowl02,
    'tf_chongyang' => HugeIcons.strokeRoundedFlower,
    _ => HugeIcons.strokeRoundedGift,
  };
}

String festivalLunarHint(String id) => switch (id) {
      'tf_chunjie' => '正月初一',
      'tf_qingming' => '清明日',
      'tf_duanwu' => '五月初五',
      'tf_zhongqiu' => '八月十五',
      'tf_yuanxiao' => '正月十五',
      'tf_chongyang' => '九月初九',
      _ => '',
    };
