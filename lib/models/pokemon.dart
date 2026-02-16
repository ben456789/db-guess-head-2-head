class EvolutionMember {
  final String name;
  final String imageUrl;
  final int id;
  final Map<String, String>? localizedNames; // Language code -> localized name

  EvolutionMember({
    required this.name,
    required this.imageUrl,
    required this.id,
    this.localizedNames,
  });

  factory EvolutionMember.fromJson(Map<String, dynamic> json) {
    Map<String, String>? localizedNames;
    if (json['localizedNames'] != null && json['localizedNames'] is Map) {
      localizedNames = Map<String, String>.from(json['localizedNames']);
    }

    return EvolutionMember(
      name: json['name'],
      imageUrl: json['imageUrl'],
      id: json['id'],
      localizedNames: localizedNames,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'id': id,
      if (localizedNames != null) 'localizedNames': localizedNames,
    };
  }
}

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> baseStats;
  final List<String> abilities;
  final int? generation;
  final List<EvolutionMember>? evolutionChain;
  final Map<String, String>? localizedNames; // Language code -> localized name

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    this.baseStats = const {},
    this.abilities = const [],
    this.generation,
    this.evolutionChain,
    this.localizedNames,
  });

  // Add a copyWith for convenience
  Pokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<String>? types,
    int? height,
    int? weight,
    Map<String, int>? baseStats,
    List<String>? abilities,
    int? generation,
    List<EvolutionMember>? evolutionChain,
    Map<String, String>? localizedNames,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      baseStats: baseStats ?? this.baseStats,
      abilities: abilities ?? this.abilities,
      generation: generation ?? this.generation,
      evolutionChain: evolutionChain ?? this.evolutionChain,
      localizedNames: localizedNames ?? this.localizedNames,
    );
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> pokemonTypes = [];

    // Handle data from API
    if (json['types'] != null && json['types'] is List) {
      for (var type in json['types']) {
        if (type is Map && type.containsKey('type')) {
          pokemonTypes.add(type['type']['name']);
        } else if (type is String) {
          // Handle stored JSON format
          pokemonTypes.add(type);
        }
      }
    }

    String imageUrl = '';
    if (json.containsKey('sprites') && json['sprites'] != null) {
      // From API
      imageUrl =
          json['sprites']['other']?['official-artwork']?['front_default'] ??
          json['sprites']['front_default'] ??
          '';
    } else if (json.containsKey('imageUrl')) {
      // From stored JSON
      imageUrl = json['imageUrl'] ?? '';
    }

    // Parse base stats
    Map<String, int> baseStats = {};
    if (json['stats'] != null && json['stats'] is List) {
      for (var stat in json['stats']) {
        if (stat is Map &&
            stat.containsKey('stat') &&
            stat.containsKey('base_stat')) {
          baseStats[stat['stat']['name']] = stat['base_stat'];
        }
      }
    } else if (json.containsKey('baseStats') && json['baseStats'] is Map) {
      baseStats = Map<String, int>.from(json['baseStats']);
    }

    // Parse abilities
    List<String> abilities = [];
    if (json['abilities'] != null && json['abilities'] is List) {
      for (var ability in json['abilities']) {
        if (ability is Map && ability.containsKey('ability')) {
          abilities.add(ability['ability']['name']);
        } else if (ability is String) {
          abilities.add(ability);
        }
      }
    } else if (json.containsKey('abilities') && json['abilities'] is List) {
      abilities = List<String>.from(json['abilities']);
    }

    // Always compute generation from id
    int? generation = _getGenerationForId(json['id']);

    // Parse evolution chain
    List<EvolutionMember>? evolutionChain;
    if (json.containsKey('evolutionChain') && json['evolutionChain'] is List) {
      evolutionChain = (json['evolutionChain'] as List).map((e) {
        final evolutionData = Map<String, dynamic>.from(
          (e as Map).map((k, v) => MapEntry(k.toString(), v)),
        );
        return EvolutionMember.fromJson(evolutionData);
      }).toList();
    }

    // Parse localized names
    Map<String, String>? localizedNames;
    if (json.containsKey('localizedNames') && json['localizedNames'] is Map) {
      localizedNames = Map<String, String>.from(json['localizedNames']);
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: imageUrl,
      types: pokemonTypes,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      baseStats: baseStats,
      abilities: abilities,
      generation: generation,
      evolutionChain: evolutionChain,
      localizedNames: localizedNames,
    );
  }

  // Helper to get generation from ID
  static int? _getGenerationForId(int id) {
    const generationRanges = {
      1: [1, 151],
      2: [152, 251],
      3: [252, 386],
      4: [387, 493],
      5: [494, 649],
      6: [650, 721],
      7: [722, 809],
      8: [810, 898],
      9: [899, 1010],
    };
    for (final entry in generationRanges.entries) {
      final range = entry.value;
      if (id >= range[0] && id <= range[1]) {
        return entry.key;
      }
    }
    return null;
  }

  String get capitalizedName {
    return name[0].toUpperCase() + name.substring(1);
  }

  // Get localized name based on language code, fallback to English/default
  String getLocalizedName(String languageCode) {
    if (localizedNames != null && localizedNames!.containsKey(languageCode)) {
      return localizedNames![languageCode]!;
    }
    // Fallback to English if available
    if (localizedNames != null && localizedNames!.containsKey('en')) {
      return localizedNames!['en']!;
    }
    // Final fallback to capitalized default name
    return capitalizedName;
  }

  String get typesString {
    return types
        .map((type) => type[0].toUpperCase() + type.substring(1))
        .join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'height': height,
      'weight': weight,
      'baseStats': baseStats,
      'abilities': abilities,
      if (generation != null) 'generation': generation,
      if (evolutionChain != null)
        'evolutionChain': evolutionChain!.map((e) => e.toJson()).toList(),
      if (localizedNames != null) 'localizedNames': localizedNames,
    };
  }
}
