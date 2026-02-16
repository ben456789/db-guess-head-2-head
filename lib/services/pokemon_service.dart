import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const int maxPokemonId = 1010; // Up to Gen 9

  static final Random _random = Random();

  // Generation ranges (approximate)
  static const Map<int, List<int>> generationRanges = {
    1: [1, 151], // Kanto
    2: [152, 251], // Johto
    3: [252, 386], // Hoenn
    4: [387, 493], // Sinnoh
    5: [494, 649], // Unova
    6: [650, 721], // Kalos
    7: [722, 809], // Alola
    8: [810, 898], // Galar
    9: [899, 1010], // Paldea
  };
  static Future<Pokemon> getRandomPokemon() async {
    try {
      // Generate random Pokemon ID (1-1010)
      final int randomId = _random.nextInt(maxPokemonId) + 1;

      final response = await http.get(
        Uri.parse('$baseUrl/$randomId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);

        // Fetch evolution chain and localized names in parallel
        final results = await Future.wait([
          _getEvolutionChain(data),
          _getLocalizedNames(data),
        ]);

        final evolutionChain = results[0] as List<EvolutionMember>;
        final localizedNames = results[1] as Map<String, String>;

        return pokemon.copyWith(
          evolutionChain: evolutionChain,
          localizedNames: localizedNames,
        );
      } else {
        throw Exception('Failed to load Pokemon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Pokemon: $e');
    }
  }

  static Future<Pokemon> getPokemonByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/${name.toLowerCase()}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);

        // Fetch evolution chain and localized names in parallel
        final results = await Future.wait([
          _getEvolutionChain(data),
          _getLocalizedNames(data),
        ]);

        final evolutionChain = results[0] as List<EvolutionMember>;
        final localizedNames = results[1] as Map<String, String>;

        return pokemon.copyWith(
          evolutionChain: evolutionChain,
          localizedNames: localizedNames,
        );
      } else {
        throw Exception('Pokemon not found: $name');
      }
    } catch (e) {
      throw Exception('Error fetching Pokemon by name: $e');
    }
  }

  static Future<List<Pokemon>> getMultipleRandomPokemon(int count) async {
    List<Pokemon> pokemonList = [];
    Set<int> usedIds = {};

    while (pokemonList.length < count) {
      int randomId = _random.nextInt(maxPokemonId) + 1;

      if (!usedIds.contains(randomId)) {
        usedIds.add(randomId);
        try {
          final response = await http.get(
            Uri.parse('$baseUrl/$randomId'),
            headers: {'Content-Type': 'application/json'},
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            final pokemon = Pokemon.fromJson(data);

            // Fetch evolution chain and localized names
            try {
              final results = await Future.wait([
                _getEvolutionChain(data),
                _getLocalizedNames(data),
              ]);

              final evolutionChain = results[0] as List<EvolutionMember>;
              final localizedNames = results[1] as Map<String, String>;

              pokemonList.add(
                pokemon.copyWith(
                  evolutionChain: evolutionChain,
                  localizedNames: localizedNames,
                ),
              );
            } catch (e) {
              // If evolution chain/names fail, add pokemon without them
              pokemonList.add(pokemon);
            }
          }
        } catch (e) {
          // Skip this character if there's an error
          continue;
        }
      }
    }

    return pokemonList;
  }

  // Helper to get generation from ID
  static int? _getGenerationForId(int id) {
    for (final entry in generationRanges.entries) {
      final range = entry.value;
      if (id >= range[0] && id <= range[1]) {
        return entry.key;
      }
    }
    return null;
  }

  static Future<List<Pokemon>> getPokemonByGenerations(
    List<int> generations,
    int count,
  ) async {
    // Get all possible IDs from selected generations
    List<int> possibleIds = [];
    for (int gen in generations) {
      if (generationRanges.containsKey(gen)) {
        final range = generationRanges[gen]!;
        for (int i = range[0]; i <= range[1]; i++) {
          possibleIds.add(i);
        }
      }
    }

    if (possibleIds.isEmpty) {
      throw Exception('No Pokemon found for selected generations');
    }

    // Shuffle to get random character from the selected generations
    possibleIds.shuffle(_random);

    // Take more IDs than needed to account for potential failures
    final idsToFetch = possibleIds.take(count + 10).toList();

    // Fetch Pokemon in parallel batches for better performance
    const batchSize = 10;
    List<Pokemon> pokemonList = [];

    for (
      int i = 0;
      i < idsToFetch.length && pokemonList.length < count;
      i += batchSize
    ) {
      final batch = idsToFetch.skip(i).take(batchSize).toList();

      // Fetch this batch in parallel
      final results = await Future.wait(
        batch.map((id) => _fetchPokemonById(id)),
        eagerError: false,
      );

      // Add successful results
      for (final pokemon in results) {
        if (pokemon != null && pokemonList.length < count) {
          pokemonList.add(pokemon);
        }
      }

      // If we have enough, break early
      if (pokemonList.length >= count) break;
    }

    if (pokemonList.isEmpty) {
      throw Exception('Failed to fetch any Pokemon');
    }

    return pokemonList;
  }

  // Helper method to fetch a single Pokemon with timeout and error handling
  static Future<Pokemon?> _fetchPokemonById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);

        // Fetch evolution chain and localized names with timeout
        try {
          final results = await Future.wait([
            _getEvolutionChain(data).timeout(const Duration(seconds: 3)),
            _getLocalizedNames(data).timeout(const Duration(seconds: 3)),
          ]);

          final evolutionChain = results[0] as List<EvolutionMember>;
          final localizedNames = results[1] as Map<String, String>;

          return pokemon.copyWith(
            evolutionChain: evolutionChain,
            localizedNames: localizedNames,
          );
        } catch (e) {
          // If evolution chain/names fail, return pokemon without them
          return pokemon;
        }
      }
      return null;
    } catch (e) {
      // Return null for failed requests
      return null;
    }
  } // Get a list of Pokemon names for autocomplete/suggestions

  static Future<List<String>> searchPokemonNames(String query) async {
    // This is a simplified version - in a real app you might want to
    // cache a list of all character names locally
    try {
      // For now, we'll just return some common Pokemon names that match
      List<String> commonPokemon = [
        'pikachu',
        'charizard',
        'blastoise',
        'venusaur',
        'mewtwo',
        'mew',
        'lugia',
        'ho-oh',
        'rayquaza',
        'kyogre',
        'groudon',
        'dialga',
        'palkia',
        'giratina',
        'reshiram',
        'zekrom',
        'kyurem',
        'xerneas',
        'yveltal',
        'zygarde',
        'solgaleo',
        'lunala',
        'necrozma',
        'zacian',
        'zamazenta',
        'eternatus',
        'koraidon',
        'miraidon',
        'bulbasaur',
        'squirtle',
        'charmander',
        'geodude',
        'machamp',
        'alakazam',
        'gengar',
        'snorlax',
        'dragonite',
        'scizor',
        'tyranitar',
        'salamence',
        'garchomp',
        'lucario',
        'zoroark',
        'greninja',
        'talonflame',
        'goodra',
        'decidueye',
        'incineroar',
        'primarina',
        'dragapult',
        'corviknight',
        'toxapex',
        'mimikyu',
      ];

      return commonPokemon
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .take(10)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Helper method to fetch evolution chain
  static Future<List<EvolutionMember>> _getEvolutionChain(
    Map<String, dynamic> pokemonData,
  ) async {
    try {
      // Get species URL from pokemon data
      final speciesUrl = pokemonData['species']?['url'];
      if (speciesUrl == null) return [];

      // Fetch species data
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode != 200) return [];

      final speciesData = json.decode(speciesResponse.body);
      final evolutionChainUrl = speciesData['evolution_chain']?['url'];
      if (evolutionChainUrl == null) return [];

      // Fetch evolution chain data
      final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
      if (evolutionResponse.statusCode != 200) return [];

      final evolutionData = json.decode(evolutionResponse.body);

      // Parse evolution chain
      List<EvolutionMember> chain = [];
      await _parseEvolutionChain(evolutionData['chain'], chain);

      return chain;
    } catch (e) {
      // Return empty list if evolution chain fetch fails
      return [];
    }
  }

  // Helper method to fetch localized names from species data
  static Future<Map<String, String>> _getLocalizedNames(
    Map<String, dynamic> pokemonData,
  ) async {
    try {
      // Get species URL from pokemon data
      final speciesUrl = pokemonData['species']?['url'];
      if (speciesUrl == null) return {};

      // Fetch species data
      final speciesResponse = await http
          .get(Uri.parse(speciesUrl))
          .timeout(const Duration(seconds: 3));
      if (speciesResponse.statusCode != 200) return {};

      final speciesData = json.decode(speciesResponse.body);

      // Parse names array
      Map<String, String> localizedNames = {};
      if (speciesData['names'] != null && speciesData['names'] is List) {
        for (var nameEntry in speciesData['names']) {
          final languageCode = nameEntry['language']?['name'];
          final name = nameEntry['name'];
          if (languageCode != null && name != null) {
            localizedNames[languageCode] = name;
          }
        }
      }

      return localizedNames;
    } catch (e) {
      // Return empty map if localized names fetch fails
      return {};
    }
  }

  // Recursive helper to parse evolution chain
  static Future<void> _parseEvolutionChain(
    Map<String, dynamic> chainLink,
    List<EvolutionMember> chain,
  ) async {
    try {
      final speciesName = chainLink['species']?['name'];
      if (speciesName != null) {
        // Fetch pokemon data to get image and ID
        final pokemonResponse = await http.get(
          Uri.parse('$baseUrl/$speciesName'),
        );

        if (pokemonResponse.statusCode == 200) {
          final pokemonData = json.decode(pokemonResponse.body);
          final imageUrl =
              pokemonData['sprites']?['other']?['official-artwork']?['front_default'] ??
              pokemonData['sprites']?['front_default'] ??
              '';

          // Fetch localized names for this evolution member
          final localizedNames = await _getLocalizedNames(pokemonData);

          chain.add(
            EvolutionMember(
              name: speciesName,
              imageUrl: imageUrl,
              id: pokemonData['id'],
              localizedNames: localizedNames,
            ),
          );
        }
      }

      // Process evolutions (if any)
      if (chainLink['evolves_to'] != null &&
          chainLink['evolves_to'] is List &&
          (chainLink['evolves_to'] as List).isNotEmpty) {
        // Take the first evolution path
        await _parseEvolutionChain(chainLink['evolves_to'][0], chain);
      }
    } catch (e) {
      // Continue even if parsing fails for one link
    }
  }
}
