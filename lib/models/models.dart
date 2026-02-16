/// Compatibility exports for gradual migration from Pokemon to Character
///
/// This file provides backwards compatible exports to help with the migration.
/// Import this file in screens that haven't been fully migrated yet.

// Export new Character model
export 'character.dart';

// For backwards compatibility, you can use:
// import '../models/character.dart' as character_models;
// Then use character_models.Character instead of Pokemon

// Type aliases for gradual migration
// Note: Dart doesn't support type aliases for classes directly,
// but you can use these patterns in your code:

// 1. Import both:
//    import '../models/pokemon.dart' as old;
//    import '../models/character.dart';
//
// 2. Gradually replace old.Pokemon with Character

/// Helper function to get localized character name
String getLocalizedCharacterName(
  dynamic characterOrPokemon,
  String languageCode,
) {
  if (characterOrPokemon == null) return '';

  // Check if it's a Character
  if (characterOrPokemon is Character) {
    return characterOrPokemon.getLocalizedName(languageCode);
  }

  // Handle old Pokemon objects if they still exist
  try {
    return characterOrPokemon.getLocalizedName(languageCode);
  } catch (e) {
    return characterOrPokemon.capitalizedName ?? characterOrPokemon.name ?? '';
  }
}

class Character {
  // Re-export from character.dart
}
