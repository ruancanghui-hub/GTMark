/// 公历日期输入解析（LOOP-001 搜索跳转）。
abstract final class DateInputParser {
  static DateTime? parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final normalized = text
        .replaceAll('年', '-')
        .replaceAll('月', '-')
        .replaceAll('日', '')
        .replaceAll('/', '-')
        .replaceAll('.', '-');

    final parts = normalized.split('-').where((p) => p.isNotEmpty).toList();
    if (parts.length != 3) return null;

    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    if (y < 1900 || y > 2100) return null;
    if (m < 1 || m > 12) return null;

    try {
      final dt = DateTime(y, m, d);
      if (dt.year != y || dt.month != m || dt.day != d) return null;
      return dt;
    } catch (_) {
      return null;
    }
  }

  static String? validateMessage(String raw) {
    if (raw.trim().isEmpty) return '请输入日期';
    if (parse(raw) == null) return '格式无效，请用 2026-06-21 或 2026年6月21日';
    return null;
  }
}
