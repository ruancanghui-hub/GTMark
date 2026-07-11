import '../../shared/utils/sp_utils.dart';

/// 收藏日期（本地，LOOP-001 下一步）。
abstract final class DateFavorites {
  static const _key = 'jichen_favorite_dates';

  static Future<void> load() async {
    // SpUtils 同步读取，无需预加载。
  }

  static bool isFavorite(DateTime date) {
    return _all().contains(_keyOf(date));
  }

  static int get count => _all().length;

  static List<String> allSorted() {
    final list = _all().toList()..sort();
    return list;
  }

  static Future<int> importMerge(Iterable<String> incoming) async {
    final set = _all();
    var added = 0;
    for (final raw in incoming) {
      if (!_isValidDateKey(raw) || set.contains(raw)) continue;
      set.add(raw);
      added++;
    }
    if (added > 0) {
      await SpUtils.putString(_key, set.join(','));
    }
    return added;
  }

  static Future<void> replaceAll(Iterable<String> keys) async {
    final set = keys.where(_isValidDateKey).toSet();
    await SpUtils.putString(_key, set.join(','));
  }

  static bool _isValidDateKey(String raw) {
    final p = raw.split('-');
    if (p.length != 3) return false;
    final y = int.tryParse(p[0]);
    final m = int.tryParse(p[1]);
    final d = int.tryParse(p[2]);
    if (y == null || m == null || d == null) return false;
    if (m < 1 || m > 12 || d < 1 || d > 31) return false;
    return true;
  }

  static Future<bool> toggle(DateTime date) async {
    final set = _all();
    final k = _keyOf(date);
    if (set.contains(k)) {
      set.remove(k);
    } else {
      set.add(k);
    }
    await SpUtils.putString(_key, set.join(','));
    return set.contains(k);
  }

  static Set<String> _all() {
    final raw = SpUtils.getString(_key, defValue: '') ?? '';
    if (raw.isEmpty) return {};
    return raw.split(',').where((e) => e.isNotEmpty).toSet();
  }

  static String _keyOf(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
