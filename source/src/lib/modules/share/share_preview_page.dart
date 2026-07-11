import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/theme/jichen_tokens.dart';
import '../../shared/ui/jichen_secondary_scaffold.dart';
import 'share_card_args.dart';
import 'share_card_capture.dart';
import 'share_card_model.dart';
import 'share_card_storage.dart';
import 'share_card_widget.dart';

/// 分享卡预览 — PNG 生成 + 比例 + 换句诗 + 附言（LOOP-008）。
class SharePreviewPage extends StatefulWidget {
  const SharePreviewPage({super.key, required this.args});

  final ShareCardArgs args;

  @override
  State<SharePreviewPage> createState() => _SharePreviewPageState();
}

class _SharePreviewPageState extends State<SharePreviewPage> {
  final _captureKey = GlobalKey();
  final _captionCtrl = TextEditingController();
  late ShareCardModel _model;
  ShareCardAspect _aspect = ShareCardAspect.ratio1x1;
  bool _busy = false;
  String? _lastExportSizeLabel;

  @override
  void initState() {
    super.initState();
    _model = ShareCardModel.fromArgs(widget.args);
    _captionCtrl.text = widget.args.caption ?? '';
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  void _cyclePoem() {
    if (!_model.canCyclePoem) return;
    setState(() {
      _model = _model.copyWith(poemIndex: _model.poemIndex + 1);
    });
  }

  void _onCaptionChanged(String value) {
    setState(() => _model = _model.copyWith(caption: value));
  }

  Future<void> _shareImage() async {
    await _exportAndShare(saveOnly: false);
  }

  Future<void> _saveImage() async {
    await _exportAndShare(saveOnly: true);
  }

  Future<ShareCaptureResult?> _capture() async {
    await Future<void>.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;
    return ShareCardCapture.capturePng(_captureKey, aspect: _aspect);
  }

  Future<void> _exportAndShare({required bool saveOnly}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final captured = await _capture();
      if (!mounted) return;
      if (captured == null || !captured.dimensionsMatch) {
        _fallbackTextShare(
          captured == null
              ? '图片生成失败，已改为文字分享'
              : '导出尺寸异常（${captured.width}×${captured.height}），已改为文字分享',
        );
        return;
      }
      setState(() {
        _lastExportSizeLabel = '${captured.width}×${captured.height}px';
      });
      if (saveOnly) {
        final result = await ShareCardStorage.savePng(captured.bytes);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.ok
                  ? '${result.message ?? '已保存'} · $_lastExportSizeLabel'
                  : (result.message ?? '保存失败'),
            ),
            action: result.needsSettings
                ? SnackBarAction(
                    label: '去设置',
                    onPressed: ShareCardStorage.openSettingsIfNeeded,
                  )
                : null,
          ),
        );
        return;
      }
      final shareText = _model.buildPlainTextShare();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              captured.bytes,
              mimeType: 'image/png',
              name: 'jichen_share.png',
            ),
          ],
          text: shareText,
        ),
      );
    } catch (_) {
      if (mounted) _fallbackTextShare('分享失败，已改为文字分享');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _fallbackTextShare(String hint) {
    SharePlus.instance.share(ShareParams(text: _model.buildPlainTextShare()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hint)));
  }

  void _shareTextOnly() {
    SharePlus.instance.share(ShareParams(text: _model.buildPlainTextShare()));
  }

  @override
  Widget build(BuildContext context) {
    final kindLabel = widget.args.kind.label;
    final exportLabel =
        _lastExportSizeLabel ??
        '${_aspect.exportWidth}×${_aspect.exportHeight}px';
    return JichenSecondaryScaffold(
      title: '分享预览',
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$kindLabel · 导出 $exportLabel', style: context.jichenCaption()),
          if (_model.isSolemn) ...[
            const SizedBox(height: 8),
            Text(
              '祭祀/清明气质 · 灰青色调',
              style: context.jichenCaption(color: const Color(0xFF5A6B7A)),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _captionCtrl,
            maxLength: 40,
            decoration: InputDecoration(
              labelText: '附言（可选）',
              hintText: '发给家人的一句话',
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _onCaptionChanged,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ShareCardAspect>(
            segments: ShareCardAspect.values
                .map(
                  (e) => ButtonSegment(
                    value: e,
                    label: Text(e.label, style: context.jichenCaption()),
                  ),
                )
                .toList(),
            selected: {_aspect},
            onSelectionChanged: (s) => setState(() => _aspect = s.first),
          ),
          const SizedBox(height: 16),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: RepaintBoundary(
                key: _captureKey,
                child: ShareCardWidget(model: _model, aspect: _aspect),
              ),
            ),
          ),
          if (_model.canCyclePoem) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _cyclePoem,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('换一句诗'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _busy ? null : _shareImage,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share),
            label: const Text('分享图片'),
            style: FilledButton.styleFrom(
              backgroundColor: JichenTokens.accent,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _saveImage,
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('保存到相册'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _shareTextOnly, child: const Text('降级：分享纯文字')),
        ],
      ),
    );
  }
}
