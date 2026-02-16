import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class CharacterService {
  static const String baseUrl = 'https://dragonball-api.com/api/characters';
  static const int totalCharacters = 58; // As per API documentation

  static final Random _random = Random();

  /// Fetches a random character from the Dragon Ball API
  static Future<Character> getRandomCharacter() async {
    try {
      // Generate random character ID (1-58)
      final int randomId = _random.nextInt(totalCharacters) + 1;

      final response = await http
          .get(
            Uri.parse('$baseUrl/$randomId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Character.fromJson(data);
      } else {
        throw Exception('Failed to load character: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching character: $e');
    }
  }

  /// Fetches a character by name
  static Future<Character> getCharacterByName(String name) async {
    try {
      // The Dragon Ball API doesn't support direct name lookup,
      // so we need to fetch all and filter
      final characters = await getAllCharacters();
      final character = characters.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw Exception('Character not found: $name'),
      );

      // Fetch full details with transformations
      return getCharacterById(character.id);
    } catch (e) {
      throw Exception('Error fetching character by name: $e');
    }
  }

  /// Fetches a character by ID
  static Future<Character> getCharacterById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Character.fromJson(data);
      } else {
        throw Exception('Failed to load character: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching character: $e');
    }
  }

  /// Fetches all characters (paginated)
  static Future<List<Character>> getAllCharacters() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl?limit=$totalCharacters'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items
            .map((item) => Character.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load characters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all characters: $e');
    }
  }

  /// Fetches multiple random characters
  static Future<List<Character>> getMultipleRandomCharacters(int count) async {
    List<Character> characterList = [];
    Set<int> usedIds = {};

    // Limit count to available characters
    final requestCount = count > totalCharacters ? totalCharacters : count;

    while (characterList.length < requestCount) {
      int randomId = _random.nextInt(totalCharacters) + 1;

      if (!usedIds.contains(randomId)) {
        usedIds.add(randomId);
        try {
          final character = await getCharacterById(randomId);
          characterList.add(character);
        } catch (e) {
          // Skip this character if there's an error
          continue;
        }
      }
    }

    return characterList;
  }

  /// Fetches characters by race (e.g., "Saiyan", "Human", "Namekian")
  static Future<List<Character>> getCharactersByRace(
    List<String> races,
    int count,
  ) async {
    try {
      List<Character> allCharacters = [];

      // Fetch characters for each race
      for (String race in races) {
        final response = await http
            .get(
              Uri.parse('$baseUrl?race=$race'),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final characters = data
              .map((item) => Character.fromJson(item as Map<String, dynamic>))
              .toList();
          allCharacters.addAll(characters);
        }
      }

      // Remove duplicates by ID
      final uniqueCharacters = <int, Character>{};
      for (var character in allCharacters) {
        uniqueCharacters[character.id] = character;
      }

      // Shuffle and take requested count
      final characterList = uniqueCharacters.values.toList();
      characterList.shuffle(_random);

      return characterList.take(count).toList();
    } catch (e) {
      throw Exception('Error fetching characters by race: $e');
    }
  }

  /// Fetches characters by affiliation (e.g., "Z Fighter", "Army of Frieza")
  static Future<List<Character>> getCharactersByAffiliation(
    List<String> affiliations,
    int count,
  ) async {
    try {
      List<Character> allCharacters = [];

      // Fetch characters for each affiliation
      for (String affiliation in affiliations) {
        final response = await http
            .get(
              Uri.parse('$baseUrl?affiliation=$affiliation'),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final characters = data
              .map((item) => Character.fromJson(item as Map<String, dynamic>))
              .toList();
          allCharacters.addAll(characters);
        }
      }

      // Remove duplicates by ID
      final uniqueCharacters = <int, Character>{};
      for (var character in allCharacters) {
        uniqueCharacters[character.id] = character;
      }

      // Shuffle and take requested count
      final characterList = uniqueCharacters.values.toList();
      characterList.shuffle(_random);

      return characterList.take(count).toList();
    } catch (e) {
      throw Exception('Error fetching characters by affiliation: $e');
    }
  }

  /// Search character names (for autocomplete)
  static Future<List<String>> searchCharacterNames(String query) async {
    try {
      final characters = await getAllCharacters();
      return characters
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .map((c) => c.name)
          .take(10)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get available races
  static List<String> getAvailableRaces() {
    return [
      'Human',
      'Saiyan',
      'Namekian',
      'Majin',
      'Frieza Race',
      'Android',
      'Jiren Race',
      'God',
      'Angel',
      'Evil',
      'Nucleico',
      'Nucleico benigno',
      'Unknown',
    ];
  }

  /// Get available affiliations
  static List<String> getAvailableAffiliations() {
    return [
      'Z Fighter',
      'Red Ribbon Army',
      'Namekian Warrior',
      'Freelancer',
      'Army of Frieza',
      'Pride Troopers',
      'Assistant of Vermoud',
      'God',
      'Assistant of Beerus',
      'Villain',
      'Other',
    ];
  }
}
