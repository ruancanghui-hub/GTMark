import 'package:get/get.dart';

import '../../shared/utils/sp_utils.dart';

/// 小年习俗：北方腊月廿三 / 南方腊月廿四 / 两者皆认。
enum XiaonianRegion {
  north('north', '北方（腊月廿三）'),
  south('south', '南方（腊月廿四）'),
  both('both', '南北皆认（廿三、廿四）');

  const XiaonianRegion(this.storageKey, this.label);
  final String storageKey;
  final String label;

  static XiaonianRegion fromStorage(String? raw) {
    return XiaonianRegion.values.firstWhere(
      (e) => e.storageKey == raw,
      orElse: () => XiaonianRegion.both,
    );
  }
}

/// 吉辰用户偏好（同步读取，启动时 [load]）。
abstract final class JichenPrefs {
  static const _kXiaonianRegion = 'jichen_xiaonian_region';
  static const _kSkipWorkdayAdjust = 'jichen_skip_workday_adjust';
  static const _kNotifyMaster = 'jichen_notify_master';
  static const _kWeatherLat = 'jichen_weather_lat';
  static const _kWeatherLon = 'jichen_weather_lon';
  static const _kWeatherCity = 'jichen_weather_city';

  static XiaonianRegion xiaonianRegion = XiaonianRegion.both;
  static bool skipWorkdayAdjust = false;
  static bool notifyMasterEnabled = true;
  static double weatherLat = 39.9042;
  static double weatherLon = 116.4074;
  static String weatherCityName = '北京';

  /// 偏好变更时递增，供今日页 Obx 刷新。
  static final prefsTick = 0.obs;

  static Future<void> load() async {
    xiaonianRegion = XiaonianRegion.fromStorage(
      SpUtils.getString(_kXiaonianRegion, defValue: XiaonianRegion.both.storageKey),
    );
    skipWorkdayAdjust = SpUtils.getBool(_kSkipWorkdayAdjust, defValue: false);
    notifyMasterEnabled = SpUtils.getBool(_kNotifyMaster, defValue: true);
    weatherLat = double.tryParse(
          SpUtils.getString(_kWeatherLat, defValue: '39.9042') ?? '39.9042',
        ) ??
        39.9042;
    weatherLon = double.tryParse(
          SpUtils.getString(_kWeatherLon, defValue: '116.4074') ?? '116.4074',
        ) ??
        116.4074;
    weatherCityName =
        SpUtils.getString(_kWeatherCity, defValue: '北京') ?? '北京';
  }

  static Future<void> setXiaonianRegion(XiaonianRegion region) async {
    xiaonianRegion = region;
    await SpUtils.putString(_kXiaonianRegion, region.storageKey);
    prefsTick.value++;
  }

  static Future<void> setSkipWorkdayAdjust(bool value) async {
    skipWorkdayAdjust = value;
    await SpUtils.putBool(_kSkipWorkdayAdjust, value);
    prefsTick.value++;
  }

  static Future<void> setNotifyMasterEnabled(bool value) async {
    notifyMasterEnabled = value;
    await SpUtils.putBool(_kNotifyMaster, value);
    prefsTick.value++;
  }

  static Future<void> setWeatherCity(
    String name,
    double lat,
    double lon,
  ) async {
    weatherCityName = name;
    weatherLat = lat;
    weatherLon = lon;
    await SpUtils.putString(_kWeatherCity, name);
    await SpUtils.putString(_kWeatherLat, lat.toString());
    await SpUtils.putString(_kWeatherLon, lon.toString());
    prefsTick.value++;
  }
}
