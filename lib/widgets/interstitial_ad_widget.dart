import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// Only import dart:io if not on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show Platform;

/// A reusable widget that loads and displays a Google Mobile Ads Interstitial Ad
/// at appropriate transition points in the app (like game over screen).
class InterstitialAdWidget extends StatefulWidget {
  /// Callback to execute after the ad is dismissed or failed to load
  final VoidCallback? onAdDismissed;

  const InterstitialAdWidget({super.key, this.onAdDismissed});

  @override
  State<InterstitialAdWidget> createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  // Test ad unit IDs - these are safe to use for testing
  // Android test ad unit ID
  //static const String _androidTestAdUnitId =
  //'ca-app-pub-3940256099942544/1033173712';
  // iOS test ad unit ID
  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadInterstitialAd();
    }
  }

  void _loadInterstitialAd() {
    // Only load ads if not on web
    if (kIsWeb) return;

    // Determine ad unit ID based on platform
    String adUnitId = 'ca-app-pub-8540464399341739/7883545519';
    if (Platform.isIOS) {
      adUnitId = _iosTestAdUnitId;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;

          // Set up full screen content callback
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  widget.onAdDismissed?.call();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  widget.onAdDismissed?.call();
                },
              );

          // Show the ad automatically once loaded
          _showAd();
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          widget.onAdDismissed?.call();
        },
      ),
    );
  }

  void _showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Interstitial ads don't have a visual widget component
    // They are shown as full-screen overlays
    return const SizedBox.shrink();
  }
}
