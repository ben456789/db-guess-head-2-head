import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../l10n/app_localizations.dart';
import 'language_selector.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({super.key});

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  bool _vibrationEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await SettingsService.isVibrationEnabled();
    if (mounted) {
      setState(() {
        _vibrationEnabled = enabled;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleVibration(bool value) async {
    setState(() {
      _vibrationEnabled = value;
    });
    await SettingsService.setVibrationEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.settings,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.vibration,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Switch(
                    value: _vibrationEnabled,
                    onChanged: _toggleVibration,
                    activeColor: const Color(0xFF1a8fe3),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const LanguageSelector(),
            ],
          ],
        ),
      ),
    );
  }
}
