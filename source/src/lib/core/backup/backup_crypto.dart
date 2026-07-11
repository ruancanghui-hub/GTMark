import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

import 'backup_format.dart';
import 'backup_parse_failure.dart';

/// 备份文件 AES-256-GCM 加密（Product-Spec §10 安全要求）。
abstract final class BackupCrypto {
  static const _iterations = 120000;
  static const _minPasswordLength = 6;

  static void validatePassword(String password) {
    if (password.length < _minPasswordLength) {
      throw BackupParseFailure('备份密码至少 $_minPasswordLength 位');
    }
  }

  static Map<String, dynamic> encryptPayload(String plaintext, String password) {
    validatePassword(password);
    final salt = _randomBytes(16);
    final key = _deriveKey(password, salt);
    final iv = IV.fromSecureRandom(12);
    final encrypter = Encrypter(AES(Key(key), mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return {
      'format': BackupFormat.encryptedFormatId,
      'version': BackupFormat.version,
      'kdf': {
        'name': 'pbkdf2-sha256',
        'iterations': _iterations,
        'salt': base64Encode(salt),
      },
      'cipher': {
        'name': 'aes-256-gcm',
        'nonce': iv.base64,
        'ciphertext': encrypted.base64,
      },
    };
  }

  static String decryptPayload(Map<String, dynamic> envelope, String password) {
    validatePassword(password);
    if (envelope['format'] != BackupFormat.encryptedFormatId) {
      throw BackupParseFailure('不是加密备份文件');
    }
    final kdf = envelope['kdf'];
    final cipher = envelope['cipher'];
    if (kdf is! Map || cipher is! Map) {
      throw BackupParseFailure('加密备份结构不正确');
    }
    final saltRaw = kdf['salt'];
    final nonceRaw = cipher['nonce'];
    final ciphertextRaw = cipher['ciphertext'];
    if (saltRaw is! String || nonceRaw is! String || ciphertextRaw is! String) {
      throw BackupParseFailure('加密备份字段缺失');
    }
    final iterations = kdf['iterations'];
    if (iterations is! int || iterations <= 0) {
      throw BackupParseFailure('加密参数无效');
    }
    final salt = base64Decode(saltRaw);
    final key = _deriveKey(password, salt, iterations: iterations);
    final iv = IV.fromBase64(nonceRaw);
    final encrypter = Encrypter(AES(Key(key), mode: AESMode.gcm));
    try {
      return encrypter.decrypt(Encrypted.fromBase64(ciphertextRaw), iv: iv);
    } catch (_) {
      throw BackupParseFailure('备份密码错误或文件已损坏');
    }
  }

  static bool isEncryptedEnvelope(Map<String, dynamic> json) {
    return json['format'] == BackupFormat.encryptedFormatId;
  }

  static Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => rnd.nextInt(256)));
  }

  static Uint8List _deriveKey(
    String password,
    Uint8List salt, {
    int iterations = _iterations,
  }) {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, iterations, 32));
    return derivator.process(Uint8List.fromList(utf8.encode(password)));
  }
}
