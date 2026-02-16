import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale ?? const Locale('en');

    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇧🇷'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
      {'code': 'id', 'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.language,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          DropdownButton<String>(
            value: currentLocale.languageCode,
            items: languages.map((lang) {
              return DropdownMenuItem<String>(
                value: lang['code']!,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(lang['flag']!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Text(lang['name']!),
                    const SizedBox(width: 2),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                localeProvider.setLocale(Locale(value));
              }
            },
            underline: Container(),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
