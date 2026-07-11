import 'package:flutter/material.dart';

import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late final HydrationStore _store;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _store.addListener(_onChange);
  }

  @override
  void dispose() {
    _store.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('单位'),
            subtitle: Text(
              _store.unit == VolumeUnit.ml ? '毫升 (ml)' : '盎司 (oz)',
            ),
            trailing: Switch(
              value: _store.unit == VolumeUnit.oz,
              onChanged: (v) =>
                  _store.setUnit(v ? VolumeUnit.oz : VolumeUnit.ml),
            ),
          ),
          ListTile(
            title: const Text('深色主题'),
            trailing: Switch(
              value: _store.themeMode == ThemeMode.dark,
              onChanged: (v) =>
                  _store.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
            ),
          ),
          const ListTile(
            title: Text('云同步'),
            subtitle: Text('V2 即将支持 Supabase'),
            trailing: Icon(Icons.cloud_off),
          ),
          const ListTile(title: Text('科普专区'), subtitle: Text('V2 即将推出')),
        ],
      ),
    );
  }
}
