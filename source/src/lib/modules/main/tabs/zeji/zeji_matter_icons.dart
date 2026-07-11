import 'package:flutter/material.dart';

import '../../../../core/zeji/zeji_matter.dart';

/// 择吉事项 → 骨架稿位图（s1…s8 对应 MAT-01…MAT-08）。
String zejiMatterAsset(String matterId) {
  final suffix = matterId.replaceFirst('MAT-', '');
  final index = int.tryParse(suffix);
  if (index == null || index < 1 || index > 8) {
    return 'assets/images/zj/s8.png';
  }
  return 'assets/images/zj/s$index.png';
}

/// 事项格内图标（选中也保持原色）。
Widget zejiMatterIconWidget({
  required String matterId,
  required bool selected,
  double size = 32,
}) {
  return Image.asset(
    zejiMatterAsset(matterId),
    width: size,
    height: size,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      Icons.category_outlined,
      size: size * 0.85,
      color: const Color(0xFFB8956B),
    ),
  );
}

String zejiRangeLabel(ZejiRangePreset preset) {
  switch (preset) {
    case ZejiRangePreset.days7:
      return '7天';
    case ZejiRangePreset.days30:
      return '30天';
    case ZejiRangePreset.custom:
      return '自定义';
  }
}
