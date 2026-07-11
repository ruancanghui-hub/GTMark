import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/ads/admob_service.dart';

/// 在启动首帧与回前台自然断点尝试展示开屏广告。
class AppOpenAdGate extends StatefulWidget {
  const AppOpenAdGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppOpenAdGate> createState() => _AppOpenAdGateState();
}

class _AppOpenAdGateState extends State<AppOpenAdGate>
    with WidgetsBindingObserver {
  final _service = AdMobService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _service.canRequestAds.addListener(_tryShowAppOpenAd);
  }

  @override
  void dispose() {
    _service.canRequestAds.removeListener(_tryShowAppOpenAd);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _tryShowAppOpenAd() {
    if (_service.canRequestAds.value) {
      unawaited(_service.showAppOpenAdIfAvailable());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _service.showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
