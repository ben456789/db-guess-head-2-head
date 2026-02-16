import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import '../models/game_state.dart';
import '../models/character.dart';

class GameService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static const String _gamesPath = 'games';
  static final Uuid _uuid = Uuid();

  // Update eliminated Character IDs for a player
  static Future<void> updateEliminatedCharacterIds(
    String gameCode,
    String playerId,
    List<int> eliminatedIds,
  ) async {
    final gameRef = _database.ref(
      '$_gamesPath/$gameCode/players/$playerId/eliminatedCharacterIds',
    );
    await gameRef.set(eliminatedIds);
    // Also update old field for backwards compatibility
    final oldGameRef = _database.ref(
      '$_gamesPath/$gameCode/players/$playerId/eliminatedPokemonIds',
    );
    await oldGameRef.set(eliminatedIds);
  }

  // Update eliminated Pokemon IDs for a player (backwards compatibility)
  static Future<void> updateEliminatedPokemonIds(
    String gameCode,
    String playerId,
    List<int> eliminatedIds,
  ) async {
    return updateEliminatedCharacterIds(gameCode, playerId, eliminatedIds);
  }

  // Set typing status for a player
  static Future<void> setTypingStatus(
    String gameCode,
    String playerId,
    bool isTyping,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode/playersTyping');
    await gameRef.update({playerId: isTyping});
  }

  // Clear typing status for a player (set to false)
  static Future<void> clearTypingStatus(
    String gameCode,
    String playerId,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode/playersTyping');
    await gameRef.update({playerId: false});
  }

  // Clean up games older than 1 hour
  static Future<void> cleanupOldGames() async {
    try {
      final gamesRef = _database.ref(_gamesPath);
      final snapshot = await gamesRef.get();

      if (!snapshot.exists) return;

      final now = DateTime.now();
      final oneHourAgo = now.subtract(Duration(hours: 1));

      final games = Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in games.entries) {
        final gameCode = entry.key;
        final gameData = Map<String, dynamic>.from(entry.value as Map);

        final createdAtMs = gameData['createdAt'] as int?;
        if (createdAtMs != null) {
          final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMs);

          if (createdAt.isBefore(oneHourAgo)) {
            await _database.ref('$_gamesPath/$gameCode').remove();
          }
        }
      }
    } catch (e) {}
  }

  // Generate a 6-character game code
  static String generateGameCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Create a new game
  static Future<GameState> createGame(
    String hostId,
    String hostName,
    List<int> categories,
  ) async {
    // Clean up old games before creating a new one
    await cleanupOldGames();

    final gameCode = generateGameCode();

    final hostPlayer = Player(
      id: hostId,
      name: hostName,
      role: PlayerRole.host,
    );

    final gameState = GameState(
      gameCode: gameCode,
      hostId: hostId,
      selectedCategories: categories,
      currentPhase: GamePhase.waitingForPlayers,
    );

    gameState.addPlayer(hostPlayer);

    final gameRef = _database.ref('$_gamesPath/$gameCode');
    // DEBUG: Print the JSON being written to Firebase
    print('DEBUG: Writing to /games/$gameCode: ${gameState.toJson()}');
    await gameRef.set(gameState.toJson());

    return gameState;
  }

  // Join an existing game
  static Future<GameState?> joinGame(
    String gameCode,
    String playerId,
    String playerName,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    final snapshot = await gameRef.get();

    if (!snapshot.exists) {
      throw Exception('Game not found');
    }

    final raw = snapshot.value as Map<Object?, Object?>;
    final gameData = Map<String, dynamic>.from(
      raw.map((key, value) => MapEntry(key.toString(), value)),
    );
    final gameState = GameState.fromJson(gameData);

    // Check if game is too old (over 1 hour)
    final oneHourAgo = DateTime.now().subtract(Duration(hours: 1));
    if (gameState.createdAt.isBefore(oneHourAgo)) {
      await gameRef.remove();
      throw Exception('Game has expired');
    }

    if (gameState.players.length >= 2) {
      throw Exception('Game is full');
    }

    final guestPlayer = Player(
      id: playerId,
      name: playerName,
      role: PlayerRole.guest,
    );

    gameState.addPlayer(guestPlayer);

    if (gameState.isGameReady) {
      gameState.currentPhase = GamePhase.characterSelection;
    }

    await gameRef.set(gameState.toJson());

    return gameState;
  }

  // Listen to game changes
  static Stream<GameState?> listenToGame(String gameCode) {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    return gameRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }

      final raw = event.snapshot.value as Map<Object?, Object?>;
      final gameData = Map<String, dynamic>.from(
        raw.map((key, value) => MapEntry(key.toString(), value)),
      );
      final gameState = GameState.fromJson(gameData);
      return gameState;
    });
  }

  // Listen to game changes with per-player delay
  static Stream<GameState?> listenToGameWithPlayer(
    String gameCode,
    String? playerId,
  ) {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    final controller = StreamController<GameState?>.broadcast();
    String? lastSeenMessageId;
    late StreamSubscription<DatabaseEvent> sub;

    sub = gameRef.onValue.listen((event) async {
      if (!event.snapshot.exists) {
        controller.add(null);
        return;
      }

      final raw = event.snapshot.value as Map<Object?, Object?>;
      final gameData = Map<String, dynamic>.from(
        raw.map((key, value) => MapEntry(key.toString(), value)),
      );
      final gameState = GameState.fromJson(gameData);

      // Find the latest message
      final messages = gameState.questionsAndAnswers;
      final latest = messages.isNotEmpty ? messages.last : null;

      bool shouldDelay = false;
      if (playerId != null && latest != null) {
        if (latest.senderId != playerId && latest.id != lastSeenMessageId) {
          shouldDelay = true;
        }
      }
      if (shouldDelay) {
        await Future.delayed(const Duration(seconds: 2));
      }
      if (latest != null) {
        lastSeenMessageId = latest.id;
      }
      controller.add(gameState);
    });

    controller.onCancel = () {
      sub.cancel();
    };

    return controller.stream;
  }

  // Update game state
  static Future<void> updateGame(GameState gameState) async {
    final gameRef = _database.ref('$_gamesPath/${gameState.gameCode}');
    await gameRef.set(gameState.toJson());
  }

  // Partially update game fields without overwriting the whole document
  static Future<void> updateGameState(
    String gameCode,
    Map<String, dynamic> updates,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');
    await gameRef.update({
      ...updates,
      'lastActivity': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Set available Characters for the game
  static Future<void> setCharacters(
    String gameCode,
    List<Character> characters,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode/availableCharacters');
    await gameRef.set(characters.map((c) => c.toJson()).toList());
    // Also set old field for backwards compatibility
    final oldGameRef = _database.ref('$_gamesPath/$gameCode/availablePokemon');
    await oldGameRef.set(characters.map((c) => c.toJson()).toList());
  }

  // Set available Pokemon for the game (backwards compatibility)
  static Future<void> setPokemon(String gameCode, List<dynamic> pokemon) async {
    if (pokemon.isNotEmpty && pokemon.first is Character) {
      return setCharacters(gameCode, pokemon.cast<Character>());
    }
    // Legacy support if somehow Pokemon objects are still used
    final gameRef = _database.ref('$_gamesPath/$gameCode/availablePokemon');
    await gameRef.set(pokemon.map((p) => (p as dynamic).toJson()).toList());
  }

  // Choose Character for a player
  static Future<void> chooseCharacter(
    String gameCode,
    String playerId,
    Character character,
  ) async {
    final playerRef = _database.ref('$_gamesPath/$gameCode/players/$playerId');
    await playerRef.update({
      'chosenCharacter': character.toJson(),
      'chosenPokemon': character.toJson(), // Backwards compatibility
    });
  }

  // Choose Pokemon for a player (backwards compatibility)
  static Future<void> choosePokemon(
    String gameCode,
    String playerId,
    dynamic pokemon,
  ) async {
    if (pokemon is Character) {
      return chooseCharacter(gameCode, playerId, pokemon);
    }
    // Legacy support
    final playerRef = _database.ref('$_gamesPath/$gameCode/players/$playerId');
    await playerRef.update({'chosenPokemon': (pokemon as dynamic).toJson()});
  }

  // Send a message/question
  static Future<void> sendMessage(String gameCode, GameMessage message) async {
    final messagesRef = _database.ref('$_gamesPath/$gameCode/messages');
    await messagesRef.push().set(message.toJson());
  }

  // Update player's eliminated Characters
  static Future<void> updateEliminatedCharacters(
    String gameCode,
    String playerId,
    List<int> eliminatedIds,
  ) async {
    final playerRef = _database.ref('$_gamesPath/$gameCode/players/$playerId');
    await playerRef.update({
      'eliminatedCharacterIds': eliminatedIds,
      'eliminatedPokemonIds': eliminatedIds, // Backwards compatibility
    });
  }

  // Update player's eliminated Pokemon (backwards compatibility)
  static Future<void> updateEliminatedPokemon(
    String gameCode,
    String playerId,
    List<int> eliminatedIds,
  ) async {
    return updateEliminatedCharacters(gameCode, playerId, eliminatedIds);
  }

  // Switch turn
  static Future<void> switchTurn(
    String gameCode,
    String newCurrentPlayerId,
  ) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    await gameRef.update({
      'currentPlayerId': newCurrentPlayerId,
      'lastActivity': DateTime.now().millisecondsSinceEpoch,
    });

    // Update player turn status
    final playersRef = _database.ref('$_gamesPath/$gameCode/players');
    final playersSnapshot = await playersRef.get();

    if (playersSnapshot.exists) {
      final players = Map<String, dynamic>.from(playersSnapshot.value as Map);

      for (final playerId in players.keys) {
        await playersRef.child(playerId).update({
          'isCurrentTurn': playerId == newCurrentPlayerId,
        });
      }
    }
  }

  // Start the game
  static Future<void> startGame(String gameCode, String firstPlayerId) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    await gameRef.update({
      'currentPhase': GamePhase.inGame.name,
      'currentPlayerId': firstPlayerId,
      'lastActivity': DateTime.now().millisecondsSinceEpoch,
    });

    // Set turn status
    await switchTurn(gameCode, firstPlayerId);
  }

  // Increment a player's score by 1
  static Future<void> incrementPlayerScore(
    String gameCode,
    String playerId,
  ) async {
    final playerRef = _database.ref(
      '$_gamesPath/$gameCode/players/$playerId/score',
    );

    final snapshot = await playerRef.get();
    int currentScore = 0;
    if (snapshot.exists && snapshot.value is int) {
      currentScore = snapshot.value as int;
    }

    await playerRef.set(currentScore + 1);
  }

  // End game
  static Future<void> endGame(String gameCode, String winnerId) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');

    print(
      'DEBUG endGame: Setting winner in Firebase for game $gameCode to: $winnerId',
    );

    await gameRef.update({
      'currentPhase': GamePhase.gameOver.name,
      'winner': winnerId,
      'lastActivity': DateTime.now().millisecondsSinceEpoch,
    });

    print('DEBUG endGame: Firebase update complete');
  }

  // Delete game
  static Future<void> deleteGame(String gameCode) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');
    await gameRef.remove();
  }

  // Generate unique message ID
  static String generateMessageId() {
    return _uuid.v4();
  }

  // Generate unique player ID
  static String generatePlayerId() {
    return _uuid.v4();
  }

  // Check if game exists
  static Future<bool> gameExists(String gameCode) async {
    final gameRef = _database.ref('$_gamesPath/$gameCode');
    final snapshot = await gameRef.get();
    return snapshot.exists;
  }
}
