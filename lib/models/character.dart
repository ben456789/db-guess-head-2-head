class TransformationMember {
  final String name;
  final String imageUrl;
  final int id;
  final String? ki;

  TransformationMember({
    required this.name,
    required this.imageUrl,
    required this.id,
    this.ki,
  });

  factory TransformationMember.fromJson(Map<String, dynamic> json) {
    return TransformationMember(
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      id: json['id'] ?? 0,
      ki: json['ki'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'id': id,
      if (ki != null) 'ki': ki,
    };
  }
}

class Character {
  final int id;
  final String name;
  final String imageUrl;
  final String race;
  final String gender;
  final String ki;
  final String maxKi;
  final String affiliation;
  final String description;
  final List<TransformationMember>? transformations;

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.race,
    required this.gender,
    required this.ki,
    required this.maxKi,
    required this.affiliation,
    required this.description,
    this.transformations,
  });

  Character copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? race,
    String? gender,
    String? ki,
    String? maxKi,
    String? affiliation,
    String? description,
    List<TransformationMember>? transformations,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      race: race ?? this.race,
      gender: gender ?? this.gender,
      ki: ki ?? this.ki,
      maxKi: maxKi ?? this.maxKi,
      affiliation: affiliation ?? this.affiliation,
      description: description ?? this.description,
      transformations: transformations ?? this.transformations,
    );
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    // Parse transformations
    List<TransformationMember>? transformations;
    if (json['transformations'] != null && json['transformations'] is List) {
      transformations = (json['transformations'] as List)
          .map((t) => TransformationMember.fromJson(t as Map<String, dynamic>))
          .toList();
    }

    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      race: json['race'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      ki: json['ki']?.toString() ?? '0',
      maxKi: json['maxKi']?.toString() ?? '0',
      affiliation: json['affiliation'] ?? 'Unknown',
      description: json['description'] ?? '',
      transformations: transformations,
    );
  }

  String get capitalizedName {
    return name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : name;
  }

  String getLocalizedName(String languageCode) {
    // Dragon Ball API doesn't provide localized names by default
    // Return the standard name
    return capitalizedName;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'race': race,
      'gender': gender,
      'ki': ki,
      'maxKi': maxKi,
      'affiliation': affiliation,
      'description': description,
      if (transformations != null)
        'transformations': transformations!.map((t) => t.toJson()).toList(),
    };
  }
}
