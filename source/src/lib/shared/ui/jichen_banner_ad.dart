import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/ads/admob_config.dart';
import '../../core/ads/admob_service.dart';
import '../theme/jichen_tokens.dart';

/// 非遮挡横幅广告：加载成功才占位，失败自动收起。
class JichenBannerAd extends StatefulWidget {
  const JichenBannerAd({super.key});

  @override
  State<JichenBannerAd> createState() => _JichenBannerAdState();
}

class _JichenBannerAdState extends State<JichenBannerAd> {
  final _service = AdMobService.instance;
  BannerAd? _bannerAd;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _service.canRequestAds.addListener(_maybeLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoad());
  }

  @override
  void dispose() {
    _service.canRequestAds.removeListener(_maybeLoad);
    _bannerAd?.dispose();
    super.dispose();
  }

  void _maybeLoad() {
    if (!mounted ||
        _failed ||
        _bannerAd != null ||
        !_service.canRequestAds.value ||
        !AdMobConfig.isSupportedPlatform) {
      return;
    }

    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobConfig.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          if (kDebugMode) {
            debugPrint(
              '[AdMob] Banner loaded (${AdMobConfig.bannerAdUnitId}).',
            );
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (kDebugMode) {
            debugPrint(
              '[AdMob] Banner failed (${error.code}): ${error.message}',
            );
          }
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _loaded = false;
            _failed = true;
          });
        },
      ),
    );
    _bannerAd = ad;
    ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (!_loaded || ad == null) return const SizedBox.shrink();

    return Semantics(
      label: '广告',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: JichenTokens.cardBorder)),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(
            height: ad.size.height.toDouble(),
            width: double.infinity,
            child: Center(
              child: SizedBox(
                width: ad.size.width.toDouble(),
                height: ad.size.height.toDouble(),
                child: AdWidget(ad: ad),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
