import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
// Only import dart:io if not on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show Platform;

/// A reusable widget that displays a Google Mobile Ads banner
/// at the bottom of the screen in a non-intrusive way.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  // Test ad unit IDs - these are safe to use for testing
  // Android test ad unit ID
  //static const String _androidTestAdUnitId =
  //'ca-app-pub-3940256099942544/6300978111';
  // iOS test ad unit ID
  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    // Only load ads if not on web
    if (kIsWeb) return;
    // Determine ad unit ID based on platform
    String adUnitId = 'ca-app-pub-8540464399341739/2595994582';
    if (Platform.isIOS) {
      adUnitId = _iosTestAdUnitId;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdOpened: (ad) {},
        onAdClosed: (ad) {},
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On web, do not display ads
    if (kIsWeb) {
      return const SizedBox.shrink();
    }
    if (!_isAdLoaded || _bannerAd == null) {
      // Return an empty container while ad is loading
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
