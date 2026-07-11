import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_config.dart';

/// Google Mobile Ads SDK 生命周期封装。
///
/// - 同意隐私/用户协议后才启动 SDK 与加载广告。
/// - 开屏广告只在启动/回前台自然断点展示，并做最小间隔限制。
/// - 广告失败不影响核心功能。
class AdMobService {
  AdMobService._();

  static final AdMobService instance = AdMobService._();

  static const Duration _appOpenCacheDuration = Duration(hours: 4);
  static const Duration _appOpenMinInterval = Duration(hours: 4);

  final ValueNotifier<bool> canRequestAds = ValueNotifier<bool>(false);

  AppOpenAd? _appOpenAd;
  DateTime? _appOpenLoadedAt;
  DateTime? _lastAppOpenShownAt;
  bool _starting = false;
  bool _started = false;
  bool _loadingAppOpen = false;
  bool _showingAppOpen = false;
  bool _pendingColdStartShow = false;

  bool get isSupported => AdMobConfig.isSupportedPlatform;

  Future<void> start() async {
    if (!isSupported || _started || _starting) return;
    _starting = true;
    try {
      final consentAllowsAds = await _prepareConsentForAds();
      if (!consentAllowsAds) {
        _log('Ads blocked: UMP consent did not allow requests.');
        return;
      }
      await MobileAds.instance.initialize();
      _started = true;
      canRequestAds.value = true;
      _pendingColdStartShow = true;
      final loaded = await loadAppOpenAd();
      if (loaded && _pendingColdStartShow) {
        _pendingColdStartShow = false;
        await showAppOpenAdIfAvailable();
      }
    } catch (error, stackTrace) {
      _log('AdMob start failed: $error\n$stackTrace');
      canRequestAds.value = false;
    } finally {
      _starting = false;
    }
  }

  Future<bool> _prepareConsentForAds() async {
    try {
      final completer = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {
              if (!completer.isCompleted) completer.complete();
            });
          } catch (error) {
            _log('UMP consent form failed: $error');
            if (!completer.isCompleted) completer.complete();
          }
        },
        (error) {
          _log('UMP consent info update failed: $error');
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _log('UMP consent timed out after 8s.');
        },
      );
      return ConsentInformation.instance.canRequestAds();
    } on MissingPluginException catch (error) {
      _log('UMP plugin unavailable: $error');
      return kDebugMode;
    } catch (error) {
      _log('UMP consent error: $error');
      return false;
    }
  }

  Future<bool> loadAppOpenAd() async {
    if (!isSupported ||
        !canRequestAds.value ||
        _loadingAppOpen ||
        _appOpenAd != null) {
      return _hasFreshAppOpenAd;
    }

    _loadingAppOpen = true;
    final completer = Completer<bool>();
    await AppOpenAd.load(
      adUnitId: AdMobConfig.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadedAt = DateTime.now();
          _loadingAppOpen = false;
          _log('App open ad loaded (${AdMobConfig.appOpenAdUnitId}).');
          if (_pendingColdStartShow) {
            _pendingColdStartShow = false;
            unawaited(showAppOpenAdIfAvailable());
          }
          if (!completer.isCompleted) completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _appOpenLoadedAt = null;
          _loadingAppOpen = false;
          _pendingColdStartShow = false;
          _log(
            'App open ad failed (${error.code}): ${error.message}',
          );
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );
    return completer.future;
  }

  Future<void> showAppOpenAdIfAvailable() async {
    if (!isSupported || !canRequestAds.value || _showingAppOpen) return;
    if (_shownTooRecently) {
      _log('App open skipped: shown within min interval.');
      return;
    }
    if (!_hasFreshAppOpenAd) {
      _disposeAppOpenAd();
      final loaded = await loadAppOpenAd();
      if (!loaded || !_hasFreshAppOpenAd) return;
    }

    final ad = _appOpenAd!;
    _appOpenAd = null;
    _appOpenLoadedAt = null;
    _showingAppOpen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _showingAppOpen = false;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        _showingAppOpen = false;
        _log('App open show failed (${error.code}): ${error.message}');
        loadAppOpenAd();
      },
    );
    _lastAppOpenShownAt = DateTime.now();
    _log('Showing app open ad.');
    await ad.show();
  }

  bool get _shownTooRecently {
    final lastShown = _lastAppOpenShownAt;
    return lastShown != null &&
        DateTime.now().difference(lastShown) < _appOpenMinInterval;
  }

  bool get _hasFreshAppOpenAd {
    final ad = _appOpenAd;
    final loadedAt = _appOpenLoadedAt;
    return ad != null &&
        loadedAt != null &&
        DateTime.now().difference(loadedAt) < _appOpenCacheDuration;
  }

  void _disposeAppOpenAd() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _appOpenLoadedAt = null;
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AdMob] $message');
    }
  }
}
