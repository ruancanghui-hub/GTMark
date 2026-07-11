/// 黄历宜忌白话摘要（传统文化参考，非承诺）。
abstract final class HuangliPlain {
  static String yiExplanation(List<String> yi) {
    if (yi.isEmpty) {
      return '暂无特别宜事记录，可按日常安排，重要事项仍建议结合实际情况。';
    }
    final items = yi.take(4).join('、');
    return '今日宜 $items 等，适合作为安排参考，不构成专业择日建议。';
  }

  static String jiExplanation(List<String> ji) {
    if (ji.isEmpty) {
      return '暂无特别忌事记录，涉及医疗、法律、大额决策请咨询专业人士。';
    }
    final items = ji.take(4).join('、');
    return '今日忌 $items 等，重要事项宜谨慎或另择吉日，仅供参考。';
  }

  static String chongExplanation(String chongDesc) {
    if (chongDesc.isEmpty) return '';
    return '冲煞 $chongDesc：传统说法中该日气运与部分生肖相冲，仅作民俗了解。';
  }

  static String positionExplanation({
    required String xi,
    required String cai,
  }) {
    return '方位参考：喜神 $xi，财神 $cai（传统历法方位，仅供民俗了解）。';
  }
}
