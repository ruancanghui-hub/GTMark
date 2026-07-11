import 'dart:typed_data';

/// PNG IHDR 尺寸解析与导出验收（LOOP-008 QA）。
class SharePngDimensions {
  const SharePngDimensions({required this.width, required this.height});

  final int width;
  final int height;
}

abstract final class SharePngUtils {
  /// 从 PNG 字节读取宽高（IHDR chunk）。
  static SharePngDimensions? readDimensions(Uint8List bytes) {
    if (bytes.length < 24) return null;
    // PNG signature 8 bytes + IHDR length 4 + "IHDR" 4 + width 4 + height 4
    const pngSig = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    for (var i = 0; i < 8; i++) {
      if (bytes[i] != pngSig[i]) return null;
    }
    if (bytes[12] != 0x49 ||
        bytes[13] != 0x48 ||
        bytes[14] != 0x44 ||
        bytes[15] != 0x52) {
      return null;
    }
    final w = _readUint32(bytes, 16);
    final h = _readUint32(bytes, 20);
    return SharePngDimensions(width: w, height: h);
  }

  static int _readUint32(Uint8List b, int offset) {
    return (b[offset] << 24) |
        (b[offset + 1] << 16) |
        (b[offset + 2] << 8) |
        b[offset + 3];
  }

  static bool matchesExport(
    Uint8List bytes, {
    required int expectedWidth,
    required int expectedHeight,
  }) {
    final dims = readDimensions(bytes);
    if (dims == null) return false;
    return dims.width == expectedWidth && dims.height == expectedHeight;
  }
}
