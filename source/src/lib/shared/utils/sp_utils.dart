import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// SharedPreferences 封装（自参考工程迁移）。
class SpUtils {
  static SpUtils? _singleton;
  static SharedPreferences? _prefs;
  static final Lock _lock = Lock();

  static Future<SpUtils?> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          final singleton = SpUtils._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SpUtils._();

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool>? putObject(String key, Object value) {
    return _prefs?.setString(key, json.encode(value));
  }

  static T? getObj<T>(String key, T Function(Map v) f, {T? defValue}) {
    final map = getObject(key);
    return map == null ? defValue : f(map);
  }

  static Map? getObject(String key) {
    final data = _prefs?.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data) as Map?;
  }

  static Future<bool>? putObjectList(String key, List<Object> list) {
    final dataList = list.map(json.encode).toList();
    return _prefs?.setStringList(key, dataList);
  }

  static List<T>? getObjList<T>(
    String key,
    T Function(Map v) f, {
    List<T>? defValue = const [],
  }) {
    final dataList = getObjectList(key);
    final list = dataList?.map(f).toList();
    return list ?? defValue;
  }

  static List<Map>? getObjectList(String key) {
    final dataList = _prefs?.getStringList(key);
    return dataList?.map((value) => json.decode(value) as Map).toList();
  }

  static String? getString(String key, {String? defValue = ''}) {
    return _prefs?.getString(key) ?? defValue;
  }

  static Future<bool>? putString(String key, String value) {
    return _prefs?.setString(key, value);
  }

  static bool getBool(String key, {bool defValue = false}) {
    return _prefs?.getBool(key) ?? defValue;
  }

  static Future<bool>? putBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  static int? getInt(String key, {int? defValue = 0}) {
    return _prefs?.getInt(key) ?? defValue;
  }

  static Future<bool>? putInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  static double? getDouble(String key, {double? defValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defValue;
  }

  static Future<bool>? putDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  static List<String>? getStringList(String key, {List<String>? defValue = const []}) {
    return _prefs?.getStringList(key) ?? defValue;
  }

  static Future<bool>? putStringList(String key, List<String> value) {
    return _prefs?.setStringList(key, value);
  }

  static dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs?.get(key) ?? defValue;
  }

  static bool? haveKey(String key) {
    return _prefs?.getKeys().contains(key);
  }

  static bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  static Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  static Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  static Future<bool>? clear() {
    return _prefs?.clear();
  }

  static Future<void>? reload() {
    return _prefs?.reload();
  }

  static bool isInitialized() {
    return _prefs != null;
  }

  static SharedPreferences? getSp() {
    return _prefs;
  }
}
