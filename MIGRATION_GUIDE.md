# Dragon Ball Character Migration Guide

This document outlines the changes made to convert the Pokemon Head-to-Head game to use Dragon Ball characters instead.

## Core Changes Completed

### 1. Models

- ✅ Created `lib/models/character.dart` - New Character model for Dragon Ball characters
- ✅ Updated `lib/models/game_state.dart` - Changed from Pokemon to Character with backwards compatibility

### 2. Services

- ✅ Created `lib/services/character_service.dart` - Service to interact with Dragon Ball API
- ✅ Updated `lib/services/game_service.dart` - Added Character methods with Pokemon backwards compatibility

### 3. Providers

- ✅ Updated `lib/providers/game_provider.dart` - Migrated to use CharacterService with backwards compatibility methods

### 4. Widgets

- ✅ Created `lib/widgets/character_fact_widget.dart` - Displays Dragon Ball character facts

### 5. Documentation

- ✅ Updated README.md to reflect Dragon Ball theme

## Remaining UI Changes Needed

The following screens still reference Pokemon and need to be updated to use Character:

### Critical Files (Manual Update Required)

1. **lib/screens/pokemon_selection_screen.dart**
   - Change: `Pokemon` → `Character`
   - Update: `_getLocalizedPokemonName()` → `_getLocalizedCharacterName()`
   - Update: `choosePokemon()` → `chooseCharacter()` (or use backwards compatible method)
   - Update: Widget name to `CharacterSelectionScreen`

2. **lib/screens/game_screen.dart**
   - Change: All `Pokemon` references → `Character`
   - Update: `_getLocalizedPokemonName()` → use `character.getLocalizedName()`
   - Update: `availablePokemon` → `availableCharacters`
   - Update: `chosenPokemon` → `chosenCharacter`
   - Update: `eliminatePokemon()` → `eliminateCharacter()`

3. **lib/screens/game_over_screen.dart**
   - Change: `Pokemon` type references → `Character`
   - Update: `_getLocalizedPokemonName()` → `_getLocalizedCharacterName()`
   - Update: Display logic to show character properties (race, affiliation, KI) instead of Pokemon types

4. **lib/screens/create_game_screen.dart**
   - Remove or repurpose generation selection logic
   - Could be replaced with race/affiliation selection

5. **lib/main.dart**
   - ✅ Updated to use `CharacterFactWidget`

### Search and Replace Patterns

Use these find/replace patterns across all files:

```
Pokemon → Character
pokemon → character
availablePokemon → availableCharacters
chosenPokemon → chosenCharacter
eliminatedPokemonIds → eliminatedCharacterIds
pokemonSelection → characterSelection
_getLocalizedPokemonName → _getLocalizedCharacterName
```

## Backwards Compatibility

The code includes backwards compatibility in several places to ensure smooth migration:

- `Player.chosenPokemon` getter still works (returns `chosenCharacter`)
- `GameState.availablePokemon` getter still works (returns `availableCharacters`)
- `GameService.choosePokemon()` method still works (calls `chooseCharacter()`)
- Database fields are written with both old and new names

## Dragon Ball API Details

- **Base URL**: `https://dragonball-api.com/api/characters`
- **Total Characters**: 58
- **Character Properties**:
  - `id`: Unique identifier
  - `name`: Character name
  - `race`: Race (Saiyan, Human, Namekian, etc.)
  - `gender`: Male/Female/Unknown
  - `ki`: Base power level
  - `maxKi`: Maximum power level
  - `affiliation`: Z Fighter, Army of Frieza, etc.
  - `description`: Character description
  - `image`: Character image URL
  - `transformations`: Array of transformation forms

## Character Attributes for Game Questions

Players can ask questions about:

- **Race**: Is your character a Saiyan? Human? Namekian?
- **Gender**: Is your character male?
- **Affiliation**: Is your character a Z Fighter?
- **KI Level**: Does your character have high base KI?
- **Transformations**: Does your character have transformations?

## Testing Checklist

- [ ] Test character selection flow
- [ ] Test game play with character questions
- [ ] Test character elimination
- [ ] Test final guess with characters
- [ ] Test rematch functionality
- [ ] Verify character images load correctly
- [ ] Test with slow/no internet connection
- [ ] Verify backwards compatibility with existing games

## API Rate Limiting

The Dragon Ball API doesn't specify rate limits in their documentation, but best practices:

- Cache character data when possible
- Use batch requests where available
- Implement error handling for API failures
- Consider local fallback data

## Future Enhancements

Potential improvements:

1. Add race/affiliation filter selection (like Pokemon generations)
2. Display character transformations during game
3. Show character power levels in UI
4. Add character comparison feature
5. Include planet information from API
6. Add character trivia questions
