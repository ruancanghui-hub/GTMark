import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 保存分享 PNG：iOS/Android 写入相册；桌面端写入 Downloads。
abstract final class ShareCardStorage {
  static Future<ShareSaveResult> savePng(Uint8List bytes) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return _saveToGallery(bytes);
    }
    return _saveToDesktop(bytes);
  }

  static Future<ShareSaveResult> _saveToGallery(Uint8List bytes) async {
    try {
      var hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }
      if (!hasAccess) {
        return ShareSaveResult(
          ok: false,
          needsSettings: true,
          message: '需要相册写入权限才能保存；可在系统设置中开启',
        );
      }
      await Gal.putImageBytes(
        bytes,
        name: 'jichen_share_${DateTime.now().millisecondsSinceEpoch}',
      );
      return ShareSaveResult(ok: true, message: '已保存到相册');
    } on GalException catch (_) {
      return ShareSaveResult(
        ok: false,
        needsSettings: true,
        message: '保存失败，请检查相册权限',
      );
    } catch (e) {
      return ShareSaveResult(ok: false, message: '保存失败：$e');
    }
  }

  static Future<ShareSaveResult> _saveToDesktop(Uint8List bytes) async {
    try {
      final dir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/jichen_share_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(path).writeAsBytes(bytes, flush: true);
      return ShareSaveResult(ok: true, path: path, message: '已保存至 $path');
    } catch (e) {
      return ShareSaveResult(ok: false, message: '保存失败：$e');
    }
  }

  static Future<void> openSettingsIfNeeded() => openAppSettings();
}

class ShareSaveResult {
  const ShareSaveResult({
    required this.ok,
    this.path,
    this.message,
    this.needsSettings = false,
  });

  final bool ok;
  final String? path;
  final String? message;
  final bool needsSettings;
}
