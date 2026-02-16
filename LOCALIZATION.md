# Multi-Language Support Documentation

## Overview

This app now supports multiple languages using Flutter's built-in localization system.

## Currently Supported Languages

- 🇺🇸 English (en)
- 🇪🇸 Spanish (es)
- 🇫🇷 French (fr)
- 🇩🇪 German (de)
- 🇯🇵 Japanese (ja)

## How to Use Localized Strings in Your Code

### 1. Import the localization package

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### 2. Access localized strings

```dart
// In any widget with BuildContext:
Text(AppLocalizations.of(context)!.welcomeTitle)

// Common examples:
AppLocalizations.of(context)!.appTitle
AppLocalizations.of(context)!.createGame
AppLocalizations.of(context)!.joinGame
AppLocalizations.of(context)!.settings
```

### 3. Using the Language Selector Widget

To add a language selector to your settings or anywhere in the app:

```dart
import 'package:poke_guess_head_2_head/widgets/language_selector.dart';

// In your widget:
LanguageSelector()
```

### 4. Programmatically Change Language

```dart
import 'package:provider/provider.dart';
import 'package:poke_guess_head_2_head/providers/locale_provider.dart';

// Change language:
Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale('es'));
```

## Adding New Languages

### Step 1: Create a new ARB file

1. Go to `lib/l10n/` directory
2. Create a new file named `app_<language_code>.arb` (e.g., `app_it.arb` for Italian)
3. Copy the structure from `app_en.arb` and translate all strings

Example for Italian (`lib/l10n/app_it.arb`):

```json
{
  "@@locale": "it",
  "appTitle": "Gioco di Indovinelli Head 2 Head",
  "welcomeTitle": "Benvenuto",
  "createGame": "Crea Gioco",
  ...
}
```

### Step 2: Add the locale to main.dart

In `lib/main.dart`, add the new locale to `supportedLocales`:

```dart
supportedLocales: const [
  Locale('en'),
  Locale('es'),
  Locale('fr'),
  Locale('de'),
  Locale('ja'),
  Locale('it'), // Add your new language
],
```

### Step 3: Add to Language Selector (optional)

In `lib/widgets/language_selector.dart`, add the new language to the list:

```dart
final languages = [
  {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
  {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
  {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
  {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
  {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'}, // Add new language
];
```

### Step 4: Run flutter pub get

```bash
flutter pub get
```

This will regenerate the localization files with your new language.

## Adding New Translatable Strings

### Step 1: Add to English ARB file

Edit `lib/l10n/app_en.arb` and add your new string:

```json
{
  ...
  "myNewString": "My New String",
  "@myNewString": {
    "description": "Description of what this string is for"
  }
}
```

### Step 2: Add translations to all other ARB files

Add the same key with translated text to:

- `app_es.arb`
- `app_fr.arb`
- `app_de.arb`
- `app_ja.arb`
- Any other language files you've created

### Step 3: Run flutter pub get

```bash
flutter pub get
```

### Step 4: Use the new string in your code

```dart
Text(AppLocalizations.of(context)!.myNewString)
```

## Dynamic Strings with Parameters

If you need strings with dynamic values, add placeholders:

In `app_en.arb`:

```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "description": "Greeting message with user's name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

Usage in code:

```dart
Text(AppLocalizations.of(context)!.greeting('John'))
```

## Plural Support

For plural forms:

In `app_en.arb`:

```json
{
  "playerCount": "{count, plural, =0{No players} =1{One player} other{{count} players}}",
  "@playerCount": {
    "description": "Number of players",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Usage:

```dart
Text(AppLocalizations.of(context)!.playerCount(5))
```

## Testing Languages

To test a specific language without changing device settings:

1. Use the LanguageSelector widget in your app
2. Or programmatically set it: `Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale('es'))`

## File Structure

```
lib/
├── l10n/
│   ├── app_en.arb    # English (template)
│   ├── app_es.arb    # Spanish
│   ├── app_fr.arb    # French
│   ├── app_de.arb    # German
│   └── app_ja.arb    # Japanese
├── providers/
│   └── locale_provider.dart  # Manages locale state
├── widgets/
│   └── language_selector.dart  # Language picker UI
└── main.dart  # Configured with localization

l10n.yaml  # Localization configuration
```

## Resources

- [Flutter Internationalization Documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle)
