import 'package:flutter/material.dart';

import '../core/prefs/jichen_prefs.dart';
import '../core/weather/weather_city_service.dart';
import '../core/weather/weather_location_service.dart';
import '../shared/theme/jichen_tokens.dart';

/// 选择天气城市（预设 + 搜索 + 定位）。
Future<WeatherCity?> showWeatherCityPicker(BuildContext context) {
  return showModalBottomSheet<WeatherCity>(
    context: context,
    isScrollControlled: true,
    backgroundColor: JichenTokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => const _WeatherCityPickerBody(),
  );
}

class _WeatherCityPickerBody extends StatefulWidget {
  const _WeatherCityPickerBody();

  @override
  State<_WeatherCityPickerBody> createState() => _WeatherCityPickerBodyState();
}

class _WeatherCityPickerBodyState extends State<_WeatherCityPickerBody> {
  final _searchCtrl = TextEditingController();
  List<WeatherCity> _results = WeatherCityService.presets;
  bool _locating = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    final list = await WeatherCityService.search(q);
    if (mounted) setState(() => _results = list);
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    final r = await WeatherLocationService.useCurrentLocation();
    if (!mounted) return;
    setState(() => _locating = false);
    if (r.ok) {
      Navigator.pop(
        context,
        WeatherCity(
          name: JichenPrefs.weatherCityName,
          lat: JichenPrefs.weatherLat,
          lon: JichenPrefs.weatherLon,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.message ?? '定位失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.paddingOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('选择城市', style: context.jichenTitle3()),
          const SizedBox(height: 12),
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: '搜索城市',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _search,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _locating ? null : _locate,
            icon: _locating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_outlined),
            label: Text(_locating ? '定位中…' : '使用当前位置'),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (ctx, i) {
                final c = _results[i];
                final selected = c.lat == JichenPrefs.weatherLat &&
                    c.lon == JichenPrefs.weatherLon;
                return ListTile(
                  title: Text(c.displayLabel),
                  trailing: selected
                      ? Icon(Icons.check, color: JichenTokens.accent)
                      : null,
                  onTap: () async {
                    await WeatherCityService.applyCity(c);
                    if (ctx.mounted) Navigator.pop(ctx, c);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
