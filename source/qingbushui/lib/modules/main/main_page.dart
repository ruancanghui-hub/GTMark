import 'package:flutter/material.dart';

import '../home/home_tab.dart';
import '../insights/insights_tab.dart';
import '../me/me_tab.dart';
import '../stats/history_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  void _onNavTap(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(onNavTap: _onNavTap),
      HistoryTab(onNavTap: _onNavTap),
      InsightsTab(onNavTap: _onNavTap),
      MeTab(onNavTap: _onNavTap),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
    );
  }
}
