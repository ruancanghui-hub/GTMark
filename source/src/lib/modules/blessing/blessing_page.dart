import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/content/blessing_entry.dart';
import '../../core/content/blessing_resolver.dart';
import '../../core/content/content_repository.dart';
import '../../core/content/poem_resolver.dart';
import '../../shared/theme/jichen_tokens.dart';
import '../../shared/ui/jichen_secondary_scaffold.dart';
import '../share/share_card_args.dart';
import '../share/share_nav.dart';

/// 发祝福 — 双轨（微信/短信）离线模板预览与复制。
class BlessingPage extends StatefulWidget {
  const BlessingPage({super.key});

  @override
  State<BlessingPage> createState() => _BlessingPageState();
}

class _BlessingPageState extends State<BlessingPage> {
  static const _scenes = [
    _Scene('今日节日', _SceneKind.today),
    _Scene('父母生日', _SceneKind.birthdayParent),
    _Scene('结婚纪念日', _SceneKind.anniversaryWedding),
    _Scene('通用祝福', _SceneKind.generic),
  ];

  int _sceneIndex = 0;
  bool _useSms = false;
  final _chengHuController = TextEditingController(text: '爸爸');

  @override
  void dispose() {
    _chengHuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scene = _scenes[_sceneIndex];
    final template = _resolveTemplate(scene.kind);
    final festivalId = _festivalIdForScene(scene.kind);
    final poem = festivalId != null
        ? ContentRepository.instance.poemForFestivalId(festivalId)
        : null;
    final chengHu = _chengHuController.text.trim().isEmpty
        ? '您'
        : _chengHuController.text;
    final text = BlessingResolver.render(
      template: template,
      useSms: _useSms,
      chengHu: chengHu,
      festivalName: poem?.name ?? '佳节',
      typeName: '纪念日',
    );

    return JichenSecondaryScaffold(
      title: '发祝福',
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('选择场景', style: context.jichenCaption()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _scenes.length; i++)
                ChoiceChip(
                  label: Text(_scenes[i].label),
                  selected: _sceneIndex == i,
                  onSelected: (_) => setState(() => _sceneIndex = i),
                ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _chengHuController,
            decoration: InputDecoration(
              labelText: '称呼',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('微信版 ≤50字')),
              ButtonSegment(value: true, label: Text('短信版 ≤70字')),
            ],
            selected: {_useSms},
            onSelectionChanged: (s) => setState(() => _useSms = s.first),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: JichenTokens.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('祝福预览', style: context.jichenCaption()),
                const SizedBox(height: 8),
                Text(text, style: context.jichenBody()),
                const SizedBox(height: 4),
                Text(
                  '${text.characters.length} 字',
                  style: context.jichenCaption(
                    color: JichenTokens.labelSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (poem?.defaultPoem != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: JichenTokens.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('配套诗句', style: context.jichenCaption()),
                  const SizedBox(height: 8),
                  Text(poem!.defaultPoem.text, style: context.jichenBody()),
                  Text(
                    '—— ${poem.defaultPoem.author}',
                    style: context.jichenCaption(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              openSharePreview(
                context,
                ShareCardArgs.blessing(
                  date: DateTime.now(),
                  blessingText: text,
                  festivalId: festivalId,
                ),
              );
            },
            icon: const Icon(Icons.image_outlined),
            label: const Text('分享祝福卡片'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_useSms ? '已复制短信版' : '已复制微信版')),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(_useSms ? '复制短信版' : '复制微信版'),
            style: FilledButton.styleFrom(
              backgroundColor: JichenTokens.accent,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  BlessingTemplate _resolveTemplate(_SceneKind kind) {
    switch (kind) {
      case _SceneKind.today:
        final id = PoemResolver.resolveIdForDate(DateTime.now());
        return id != null
            ? (BlessingResolver.forFestivalId(id) ?? BlessingResolver.generic())
            : BlessingResolver.generic();
      case _SceneKind.birthdayParent:
        return BlessingResolver.forBirthdayRelation('parent') ??
            BlessingResolver.generic();
      case _SceneKind.anniversaryWedding:
        return BlessingResolver.forAnniversarySubtype('wedding') ??
            BlessingResolver.generic();
      case _SceneKind.generic:
        return BlessingResolver.generic();
    }
  }

  String? _festivalIdForScene(_SceneKind kind) {
    switch (kind) {
      case _SceneKind.today:
        return PoemResolver.resolveIdForDate(DateTime.now());
      case _SceneKind.birthdayParent:
        return 'bd_parent';
      case _SceneKind.anniversaryWedding:
        return 'an_wedding';
      case _SceneKind.generic:
        return null;
    }
  }
}

enum _SceneKind { today, birthdayParent, anniversaryWedding, generic }

class _Scene {
  const _Scene(this.label, this.kind);
  final String label;
  final _SceneKind kind;
}
