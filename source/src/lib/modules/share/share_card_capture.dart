import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'share_card_model.dart';
import 'share_png_utils.dart';

/// PNG 捕获结果（含像素尺寸验收）。
class ShareCaptureResult {
  const ShareCaptureResult({
    required this.bytes,
    required this.width,
    required this.height,
    required this.expectedWidth,
    required this.expectedHeight,
  });

  final Uint8List bytes;
  final int width;
  final int height;
  final int expectedWidth;
  final int expectedHeight;

  bool get dimensionsMatch => width == expectedWidth && height == expectedHeight;

  bool get pngHeaderValid =>
      SharePngUtils.matchesExport(
        bytes,
        expectedWidth: expectedWidth,
        expectedHeight: expectedHeight,
      );
}

/// 将 [RepaintBoundary] 导出为 PNG（LOOP-008）。
abstract final class ShareCardCapture {
  static Future<ShareCaptureResult?> capturePng(
    GlobalKey boundaryKey, {
    required ShareCardAspect aspect,
  }) {
    return capturePngWithRatio(
      boundaryKey,
      pixelRatio: aspect.capturePixelRatio,
      expectedWidth: aspect.exportWidth,
      expectedHeight: aspect.exportHeight,
    );
  }

  static Future<ShareCaptureResult?> capturePngWithRatio(
    GlobalKey boundaryKey, {
    required double pixelRatio,
    required int expectedWidth,
    required int expectedHeight,
  }) async {
    final ctx = boundaryKey.currentContext;
    if (ctx == null) return null;
    final boundary = ctx.findRenderObject();
    if (boundary is! RenderRepaintBoundary) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data?.buffer.asUint8List();
    if (bytes == null || bytes.isEmpty) return null;
    return ShareCaptureResult(
      bytes: bytes,
      width: image.width,
      height: image.height,
      expectedWidth: expectedWidth,
      expectedHeight: expectedHeight,
    );
  }
}
