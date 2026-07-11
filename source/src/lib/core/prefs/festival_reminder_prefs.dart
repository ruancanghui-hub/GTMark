import '../../shared/utils/sp_utils.dart';

/// 内置节日提醒开关（LOOP-004 / SPEC-014）。
abstract final class FestivalReminderPrefs {
  static const _key = 'jichen_festival_reminder_off';

  static const entries = <String, String>{
    'tf_chunjie': '春节',
    'tf_qingming': '清明',
    'tf_duanwu': '端午',
    'tf_zhongqiu': '中秋',
    'tf_yuanxiao': '元宵',
    'tf_chongyang': '重阳',
  };

  static Set<String> _disabled = {};

  static void load() {
    final raw = SpUtils.getString(_key, defValue: '') ?? '';
    if (raw.isEmpty) {
      _disabled = {};
      return;
    }
    _disabled = raw.split(',').where((e) => e.isNotEmpty).toSet();
  }

  static bool isEnabled(String festivalId) => !_disabled.contains(festivalId);

  static List<String> disabledIds() => _disabled.toList()..sort();

  static Future<void> replaceDisabled(Set<String> ids) async {
    _disabled = ids.where((e) => entries.containsKey(e)).toSet();
    await SpUtils.putString(_key, _disabled.join(','));
  }

  static Future<void> setEnabled(String festivalId, bool enabled) async {
    if (enabled) {
      _disabled.remove(festivalId);
    } else {
      _disabled.add(festivalId);
    }
    await SpUtils.putString(_key, _disabled.join(','));
  }
}
