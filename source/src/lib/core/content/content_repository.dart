import 'dart:convert';

import 'package:flutter/services.dart';

import 'blessing_entry.dart';
import 'content_fallback.dart';
import 'poem_entry.dart';

/// 离线诗句 + 祝福双库，启动时加载至内存。
class ContentRepository {
  ContentRepository._();

  static final ContentRepository instance = ContentRepository._();

  static const poemsAsset = 'assets/content/jichen_poems.v1.json';
  static const blessingsAsset = 'assets/content/jichen_blessings.v1.json';

  final Map<String, PoemBundle> _poems = {};
  final Map<String, BlessingTemplate> _blessings = {};
  bool _ready = false;

  bool get isReady => _ready;

  Future<void> init({
    AssetBundle? bundle,
    String? poemsJson,
    String? blessingsJson,
  }) async {
    if (_ready) return;
    final assets = bundle ?? rootBundle;
    try {
      final pRaw = poemsJson ?? await assets.loadString(poemsAsset);
      final bRaw = blessingsJson ?? await assets.loadString(blessingsAsset);
      _parsePoems(jsonDecode(pRaw) as Map<String, dynamic>);
      _parseBlessings(jsonDecode(bRaw) as Map<String, dynamic>);
    } catch (_) {
      _poems['tf_duanwu'] = ContentFallback.poemDuanwu;
      _blessings['bls_generic'] = ContentFallback.blessingGeneric;
    }
    _ready = true;
  }

  void _parsePoems(Map<String, dynamic> root) {
    _poems.clear();
    for (final key in ['solar_terms', 'festivals', 'personal']) {
      final block = root[key] as Map<String, dynamic>?;
      if (block == null) continue;
      block.forEach((id, value) {
        _poems[id] = PoemBundle.fromJson(
          id,
          Map<String, dynamic>.from(value as Map),
        );
      });
    }
  }

  void _parseBlessings(Map<String, dynamic> root) {
    _blessings.clear();
    final templates = root['templates'] as Map<String, dynamic>?;
    if (templates == null) return;
    templates.forEach((id, value) {
      _blessings[id] = BlessingTemplate.fromJson(
        id,
        Map<String, dynamic>.from(value as Map),
      );
    });
  }

  PoemBundle? poemBundle(String id) => _poems[id];

  /// 可跨 isolate 传递的节日名称快照，避免后台计算读取 isolate-local 单例。
  Map<String, String> festivalNameSnapshot() => Map.unmodifiable({
    for (final entry in _poems.entries) entry.key: entry.value.name,
  });

  BlessingTemplate? blessingTemplate(String id) =>
      _blessings[id] ?? _blessings['bls_generic'];

  PoemBundle? poemForFestivalId(String festivalId) => _poems[festivalId];

  BlessingTemplate? blessingForFestivalId(String festivalId) {
    final direct = _blessings['bls_$festivalId'];
    if (direct != null) return direct;
    final alias = _blessingAlias(festivalId);
    if (alias != null) return _blessings['bls_$alias'];
    return blessingTemplate('bls_generic');
  }

  static String? _blessingAlias(String festivalId) {
    switch (festivalId) {
      case 'md_chongyang_legal':
        return 'tf_chongyang';
      case 'md_youth':
        return 'md_children';
      default:
        return null;
    }
  }

  int get poemCount => _poems.length;
  int get blessingCount => _blessings.length;

  /// 测试用：重置单例状态。
  void resetForTest() {
    _poems.clear();
    _blessings.clear();
    _ready = false;
  }
}
