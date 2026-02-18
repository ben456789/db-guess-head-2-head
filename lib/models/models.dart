/// Exports for Dragon Ball Character model only
import 'character.dart';

/// Helper function to get localized character name
String getLocalizedCharacterName(Character character, String languageCode) {
  return character.getLocalizedName(languageCode);
}
