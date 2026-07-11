/// SPEC-013：生日关系 / 纪念日类型 / 倒数日主题。
abstract final class ReminderPersonalMeta {
  static const birthdayRelations = <String, String>{
    'parent': '父母',
    'elder': '长辈',
    'spouse': '配偶',
    'peer': '同辈',
    'child': '晚辈',
    'self': '自己',
  };

  static const anniversarySubtypes = <String, String>{
    'wedding': '结婚',
    'love': '恋爱',
    'family': '家庭',
    'work': '工作/开业',
    'custom': '其他纪念',
  };

  static const countdownThemes = <String, String>{
    'time': '重要日子',
    'travel': '出行',
    'exam': '考试',
  };

  static String relationLabel(String? key) =>
      birthdayRelations[key] ?? '生日';

  static String subtypeLabel(String? key) =>
      anniversarySubtypes[key] ?? '纪念日';

  static String countdownThemeLabel(String? key) =>
      countdownThemes[key ?? 'time'] ?? '倒数日';
}
