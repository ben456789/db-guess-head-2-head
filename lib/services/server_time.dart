import 'package:firebase_database/firebase_database.dart';

/// Utility to fetch the current server time offset from Firebase Realtime Database.
class ServerTime {
  static int? _offsetMs;
  static DateTime? _lastFetch;

  /// Returns the current server time as a DateTime, or null if not yet available.
  static DateTime? get now {
    if (_offsetMs == null) return null;
    return DateTime.now().add(Duration(milliseconds: _offsetMs!));
  }

  /// Returns the current server time offset in milliseconds, or null if not yet available.
  static int? get offsetMs => _offsetMs;

  /// Fetches the server time offset from Firebase and caches it for 5 minutes.
  static Future<void> fetchOffset() async {
    // Only refresh if not fetched recently
    if (_lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < Duration(minutes: 5)) {
      return;
    }
    try {
      final ref = FirebaseDatabase.instance.ref('.info/serverTimeOffset');
      final snapshot = await ref.get();
      if (snapshot.exists) {
        _offsetMs = (snapshot.value as int?) ?? 0;
        _lastFetch = DateTime.now();
      }
    } catch (e) {}
  }
}
