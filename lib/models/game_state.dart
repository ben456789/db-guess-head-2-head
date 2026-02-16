import 'character.dart';

enum GamePhase {
  menu,
  creatingGame,
  joiningGame,
  waitingForPlayers,
  characterSelection,
  characterChosen,
  playerOneGuessing,
  playerTwoGuessing,
  roundResult,
  inGame,
  gameOver,
}

enum PlayerRole { host, guest }

enum QuestionType { question, answer, finalGuess }

enum GuessResult { correct, incorrect, timeout }

class GameMessage {
  final String id;
  final String senderId;
  final String content;
  final QuestionType type;
  final DateTime timestamp;
  final bool? answerValue; // true for yes, false for no, null for questions
  GameMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.answerValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'answerValue': answerValue,
    };
  }

  factory GameMessage.fromJson(Map<String, dynamic> json) {
    return GameMessage(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      type: QuestionType.values.byName(json['type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      answerValue: json['answerValue'],
    );
  }
}

class Player {
  final String id;
  final String name;
  final PlayerRole role;
  Character? chosenCharacter;
  List<int> eliminatedCharacterIds;
  bool isCurrentTurn;
  int score;

  // Backward-compatible aliases expected by UI code
  Character? get currentCharacter => chosenCharacter;
  Character? get chosenPokemon => chosenCharacter; // Backwards compatibility
  Character? get currentPokemon => chosenCharacter; // Backwards compatibility

  Player({
    required this.id,
    required this.name,
    required this.role,
    this.chosenCharacter,
    List<int>? eliminatedCharacterIds,
    this.isCurrentTurn = false,
    this.score = 0,
  }) : eliminatedCharacterIds = eliminatedCharacterIds ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.name,
      'chosenCharacter': chosenCharacter?.toJson(),
      'chosenPokemon': chosenCharacter?.toJson(), // Backwards compatibility
      'eliminatedCharacterIds': eliminatedCharacterIds,
      'eliminatedPokemonIds': eliminatedCharacterIds, // Backwards compatibility
      'isCurrentTurn': isCurrentTurn,
      'score': score,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    Character? chosenCharacter;
    // Check both new and old field names for backwards compatibility
    final characterJson = json['chosenCharacter'] ?? json['chosenPokemon'];
    if (characterJson != null) {
      final characterData = Map<String, dynamic>.from(
        (characterJson as Map).map((k, v) => MapEntry(k.toString(), v)),
      );
      chosenCharacter = Character.fromJson(characterData);
    }

    return Player(
      id: json['id'],
      name: json['name'],
      role: PlayerRole.values.byName(json['role']),
      chosenCharacter: chosenCharacter,
      eliminatedCharacterIds: List<int>.from(
        json['eliminatedCharacterIds'] ?? json['eliminatedPokemonIds'] ?? [],
      ),
      isCurrentTurn: json['isCurrentTurn'] ?? false,
      score: json['score'] ?? 0,
    );
  }

  void eliminateCharacter(int characterId) {
    if (!eliminatedCharacterIds.contains(characterId)) {
      eliminatedCharacterIds.add(characterId);
    }
  }

  void unEliminateCharacter(int characterId) {
    eliminatedCharacterIds.remove(characterId);
  }

  bool isCharacterEliminated(int characterId) {
    return eliminatedCharacterIds.contains(characterId);
  }

  // Backwards compatibility methods
  void eliminatePokemon(int id) => eliminateCharacter(id);
  void unEliminatePokemon(int id) => unEliminateCharacter(id);
  bool isPokemonEliminated(int id) => isCharacterEliminated(id);
}

class GameState {
  final String gameCode;
  final String hostId;
  final List<int> selectedCategories; // races/affiliations for Dragon Ball
  final List<Character> availableCharacters;
  final Map<String, Player> players;

  // Backwards compatibility
  List<int> get selectedGenerations => selectedCategories;
  List<Character> get availablePokemon => availableCharacters;
  final List<GameMessage> messages;
  GamePhase currentPhase;
  String? currentPlayerId;
  String? winner;
  DateTime? lastActivity;
  DateTime createdAt;
  int timeLeft;
  int currentRound;
  int maxRounds;
  GuessResult? lastGuessResult;
  String? currentGuess;
  Map<String, bool>
  playersReadyToPlayAgain; // Track which players want to play again
  Map<String, bool> playersTyping; // Track which players are currently typing

  GameState({
    required this.gameCode,
    required this.hostId,
    required this.selectedCategories,
    List<Character>? availableCharacters,
    Map<String, Player>? players,
    List<GameMessage>? messages,
    this.currentPhase = GamePhase.waitingForPlayers,
    this.currentPlayerId,
    this.winner,
    this.lastActivity,
    DateTime? createdAt,
    this.timeLeft = 30,
    this.currentRound = 1,
    this.maxRounds = 20,
    this.lastGuessResult,
    this.currentGuess,
    Map<String, bool>? playersReadyToPlayAgain,
    Map<String, bool>? playersTyping,
  }) : availableCharacters = availableCharacters ?? [],
       players = players ?? {},
       messages = messages ?? [],
       createdAt = createdAt ?? DateTime.now(),
       playersReadyToPlayAgain = playersReadyToPlayAgain ?? {},
       playersTyping = playersTyping ?? {};

  bool get isGameReady => players.length == 2;

  bool get allPlayersChosen =>
      players.values.every((p) => p.chosenCharacter != null);

  Player? get currentPlayer =>
      currentPlayerId != null ? players[currentPlayerId] : null;

  Player? get hostPlayer => players[hostId];

  Player? get guestPlayer {
    try {
      return players.values.firstWhere((p) => p.role == PlayerRole.guest);
    } catch (e) {
      return null;
    }
  }

  // Backward-compatible getters expected by UI
  Player get playerOne => hostPlayer ?? players.values.first;
  Player? get playerTwo => guestPlayer;

  bool get isTied {
    // If a winner is explicitly set, it's not a tie
    if (winner != null) return false;
    final p1 = playerOne;
    final p2 = playerTwo;
    if (p2 == null) return false;
    return p1.score == p2.score;
  }

  List<GameMessage> get questionsAndAnswers => messages
      .where(
        (m) => m.type == QuestionType.question || m.type == QuestionType.answer,
      )
      .toList();

  Map<String, dynamic> toJson() {
    return {
      'gameCode': gameCode,
      'hostId': hostId,
      'selectedCategories': selectedCategories,
      'selectedGenerations': selectedCategories, // Backwards compatibility
      'availableCharacters': availableCharacters
          .map((c) => c.toJson())
          .toList(),
      'availablePokemon': availableCharacters
          .map((c) => c.toJson())
          .toList(), // Backwards compatibility
      'players': players.map((key, player) => MapEntry(key, player.toJson())),
      'messages': messages.map((m) => m.toJson()).toList(),
      'currentPhase': currentPhase.name,
      'currentPlayerId': currentPlayerId,
      'winner': winner,
      'lastActivity': lastActivity?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'timeLeft': timeLeft,
      'currentRound': currentRound,
      'maxRounds': maxRounds,
      'lastGuessResult': lastGuessResult?.name,
      'currentGuess': currentGuess,
      'playersReadyToPlayAgain': playersReadyToPlayAgain,
      'playersTyping': playersTyping,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    // Support both new and old field names for backwards compatibility
    final charactersJson =
        json['availableCharacters'] ?? json['availablePokemon'];
    final availableCharacters =
        (charactersJson as List?)?.map((p) {
          final characterData = Map<String, dynamic>.from(
            (p as Map).map((k, v) => MapEntry(k.toString(), v)),
          );
          return Character.fromJson(characterData);
        }).toList() ??
        [];

    final playersRaw = json['players'] as Map?;
    final players =
        playersRaw?.map((key, value) {
          final playerData = Map<String, dynamic>.from(
            (value as Map).map((k, v) => MapEntry(k.toString(), v)),
          );
          return MapEntry(key.toString(), Player.fromJson(playerData));
        }) ??
        <String, Player>{};

    final messagesRaw = json['messages'];
    final messages = <GameMessage>[];
    if (messagesRaw != null) {
      if (messagesRaw is List) {
        // Handle array format
        for (var m in messagesRaw) {
          final messageData = Map<String, dynamic>.from(
            (m as Map).map((k, v) => MapEntry(k.toString(), v)),
          );
          messages.add(GameMessage.fromJson(messageData));
        }
      } else if (messagesRaw is Map) {
        // Handle Firebase push() format (map with auto-generated keys)
        for (var entry in messagesRaw.entries) {
          if (entry.value is Map) {
            final messageData = Map<String, dynamic>.from(
              (entry.value as Map).map((k, v) => MapEntry(k.toString(), v)),
            );
            messages.add(GameMessage.fromJson(messageData));
          }
        }
      }
      // Sort messages by timestamp to ensure correct order
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    return GameState(
      gameCode: json['gameCode'],
      hostId: json['hostId'],
      selectedCategories:
          (json['selectedCategories'] as List?)?.cast<int>() ??
          (json['selectedGenerations'] as List?)?.cast<int>() ??
          [],
      availableCharacters: availableCharacters,
      players: players,
      messages: messages,
      currentPhase: GamePhase.values.byName(json['currentPhase']),
      currentPlayerId: json['currentPlayerId'],
      winner: () {
        print('DEBUG GameState.fromJson: winner field = ${json['winner']}');
        return json['winner'];
      }(),
      lastActivity: json['lastActivity'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastActivity'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : DateTime.now(),
      timeLeft: json['timeLeft'] ?? 30,
      currentRound: json['currentRound'] ?? 1,
      maxRounds: json['maxRounds'] ?? 5,
      lastGuessResult: json['lastGuessResult'] != null
          ? GuessResult.values.byName(json['lastGuessResult'])
          : null,
      currentGuess: json['currentGuess'],
      playersReadyToPlayAgain: json['playersReadyToPlayAgain'] != null
          ? Map<String, bool>.from(json['playersReadyToPlayAgain'])
          : {},
      playersTyping: json['playersTyping'] != null
          ? Map<String, bool>.from(json['playersTyping'])
          : {},
    );
  }

  void addPlayer(Player player) {
    players[player.id] = player;
    lastActivity = DateTime.now();
  }

  void removePlayer(String playerId) {
    players.remove(playerId);
    lastActivity = DateTime.now();
  }

  void addMessage(GameMessage message) {
    messages.add(message);
    lastActivity = DateTime.now();
  }

  void switchTurn() {
    if (players.length == 2) {
      final currentPlayer = this.currentPlayer;
      if (currentPlayer != null) {
        final otherPlayerId = players.keys.firstWhere(
          (id) => id != currentPlayerId,
        );
        currentPlayerId = otherPlayerId;

        // Update turn status
        for (final player in players.values) {
          player.isCurrentTurn = player.id == currentPlayerId;
        }
      }
    }
    lastActivity = DateTime.now();
  }

  void startGame() {
    if (allPlayersChosen && players.length == 2) {
      currentPhase = GamePhase.inGame;
      // Randomly select first player
      final playerIds = players.keys.toList();
      currentPlayerId = playerIds[DateTime.now().millisecond % 2];

      // Set turn status
      for (final player in players.values) {
        player.isCurrentTurn = player.id == currentPlayerId;
      }

      lastActivity = DateTime.now();
    }
  }

  void endGame(String winnerId) {
    winner = winnerId;
    currentPhase = GamePhase.gameOver;
    lastActivity = DateTime.now();
  }
}
