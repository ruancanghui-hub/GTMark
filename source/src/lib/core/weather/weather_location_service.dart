import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../prefs/jichen_prefs.dart';
import 'weather_service.dart';

/// 定位获取当前坐标并设为天气城市。
abstract final class WeatherLocationService {
  static Future<({bool ok, String? message})> useCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return (ok: false, message: '请开启系统定位服务');
    }

    var perm = await Permission.locationWhenInUse.status;
    if (!perm.isGranted) {
      perm = await Permission.locationWhenInUse.request();
    }
    if (!perm.isGranted) {
      return (ok: false, message: '定位未授权，可手动选择城市');
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      await JichenPrefs.setWeatherCity(
        '当前位置',
        pos.latitude,
        pos.longitude,
      );
      await WeatherService.clearCache();
      return (ok: true, message: '已使用当前位置');
    } catch (_) {
      return (ok: false, message: '定位失败，请手动选择城市');
    }
  }
}
