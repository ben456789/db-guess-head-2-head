import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _vibrationKey = 'vibration_enabled';

  static Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationKey) ?? true; // Default to enabled
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
  }
}
