import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_state.dart';
import '../models/character.dart';
import '../services/character_service.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  GameState? _gameState;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<GameState?>? _gameSubscription;
  String? _playerId;
  String? _playerName;
  int _unreadMessageCount = 0;
  bool _rematchResetting = false;
  bool _isChatOpen = false;

  Future<void> updateEliminatedCharacterIds(List<int> eliminatedIds) async {
    if (_gameState == null || _playerId == null) return;
    await GameService.updateEliminatedCharacterIds(
      _gameState!.gameCode,
      _playerId!,
      eliminatedIds,
    );
  }

  // Backwards compatibility
  Future<void> updateEliminatedPokemonIds(List<int> eliminatedIds) async {
    return updateEliminatedCharacterIds(eliminatedIds);
  }

  GameState? get gameState => _gameState;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get playerId => _playerId;
  String? get playerName => _playerName;

  bool get isHost => _gameState?.hostId == _playerId;
  int get unreadMessageCount => _unreadMessageCount;
  Player? get currentUser =>
      _playerId != null ? _gameState?.players[_playerId!] : null;
  Player? get opponent {
    if (_gameState == null || _playerId == null) return null;
    try {
      return _gameState!.players.values.firstWhere(
        (player) => player.id != _playerId,
      );
    } catch (e) {
      return null;
    }
  }

  // --- Typing Indicator Logic ---
  Future<void> setTyping(bool isTyping) async {
    if (_gameState == null || _playerId == null) return;
    await GameService.setTypingStatus(
      _gameState!.gameCode,
      _playerId!,
      isTyping,
    );
  }

  Future<void> clearTyping() async {
    if (_gameState == null || _playerId == null) return;
    await GameService.clearTypingStatus(_gameState!.gameCode, _playerId!);
  }

  bool get isOpponentTyping {
    if (_gameState == null || _playerId == null) return false;
    final typingMap = _gameState!.playersTyping;
    final opponentId = _gameState!.players.keys.firstWhere(
      (id) => id != _playerId,
      orElse: () => '',
    );
    return typingMap[opponentId] == true;
  }

  void setPlayerInfo(String name) {
    // Use Firebase Auth UID for playerId
    // ignore: avoid_print
    print(
      'DEBUG: Setting _playerId to FirebaseAuth.currentUser?.uid = '
      '${FirebaseAuth.instance.currentUser?.uid}',
    );
    _playerId = FirebaseAuth.instance.currentUser?.uid;
    _playerName = name;
    notifyListeners();
  }

  void setChatOpen(bool isOpen) {
    _isChatOpen = isOpen;
    notifyListeners();
  }

  void setPlayerNames(String player1Name, String player2Name) {
    // Use Firebase Auth UID for playerId
    _playerId = FirebaseAuth.instance.currentUser?.uid;
    _playerName = player1Name;
    notifyListeners();
  }

  Future<GameState?> startGame() async {
    if (_playerId == null || _playerName == null) {
      _setError('Player info missing');
      return null;
    }

    _setLoading(true);
    _clearError();

    try {
      // Default categories (using empty list for random selection)
      final selectedCategories = <int>[];
      _gameState = await GameService.createGame(
        _playerId!,
        _playerName!,
        selectedCategories,
      );

      // Load characters
      final characters = await CharacterService.getMultipleRandomCharacters();
      await GameService.setCharacters(_gameState!.gameCode, characters);

      // Reset eliminated characters for this user
      await updateEliminatedCharacterIds([]);

      _listenToGameChanges(_gameState!.gameCode);
      return _gameState;
    } catch (e) {
      _setError('Failed to start game: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createGame(List<int> selectedCategories) async {
    if (_playerId == null || _playerName == null) return;

    _setLoading(true);
    _clearError();

    try {
      _gameState = await GameService.createGame(
        _playerId!,
        _playerName!,
        selectedCategories,
      );

      // Load characters — if the external API fails (e.g. CORS on web)
      // we still let the game be created and try the fetch silently.
      try {
        final characters = await CharacterService.getMultipleRandomCharacters();
        await GameService.setCharacters(_gameState!.gameCode, characters);
      } catch (charError) {
        // Characters failed to load (common on web due to CORS).
        // The game node is already created in Firebase; characters will be
        // empty. Log but don't block game creation.
        // ignore: avoid_print
        print('WARNING: Failed to load characters: $charError');
      }

      // Reset eliminated characters for this user
      await updateEliminatedCharacterIds([]);

      _listenToGameChanges(_gameState!.gameCode);
    } catch (e) {
      _setError('Failed to create game: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinGame(String gameCode) async {
    if (_playerId == null || _playerName == null) {
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _gameState = await GameService.joinGame(
        gameCode.toUpperCase(),
        _playerId!,
        _playerName!,
      );
      _listenToGameChanges(gameCode.toUpperCase());
    } catch (e) {
      _setError('Failed to join game: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _listenToGameChanges(String gameCode) {
    _gameSubscription?.cancel();
    bool isFirstUpdate = true;
    _gameSubscription = GameService.listenToGame(gameCode).listen(
      (gameState) {
        if (gameState != null) {
          // On first listener update, initialize unread count with opponent's messages
          if (isFirstUpdate) {
            // Initialize unread count with only opponent messages; pause if chat is open
            final myId = _playerId;
            final initialUnread = (myId == null || _isChatOpen)
                ? 0
                : gameState.questionsAndAnswers
                      .where((m) => m.senderId != myId)
                      .length;
            _unreadMessageCount = initialUnread;
            isFirstUpdate = false;
          } else if (_gameState != null) {
            // Count new messages since last update
            final previousCount = _gameState!.questionsAndAnswers.length;
            final newCount = gameState.questionsAndAnswers.length;
            if (newCount > previousCount) {
              // Only count new messages from opponent as unread; pause while chat is open
              if (!_isChatOpen) {
                final myId = _playerId;
                final newMessages = gameState.questionsAndAnswers.sublist(
                  previousCount,
                  newCount,
                );
                final opponentNew = myId == null
                    ? 0
                    : newMessages.where((m) => m.senderId != myId).length;
                _unreadMessageCount += opponentNew;
              } else {}
            }
            // Clear loading based on phase transitions
            if (_gameState!.currentPhase == GamePhase.gameOver &&
                gameState.currentPhase == GamePhase.characterSelection) {
              _setLoading(false);
            }
            if (gameState.currentPhase == GamePhase.inGame ||
                gameState.currentPhase == GamePhase.gameOver) {
              if (_isLoading) _setLoading(false);
            }
          }
          _gameState = gameState;
          notifyListeners();
        } else {
          _gameState = null;
          notifyListeners();
        }
      },
      onError: (error) {
        _setError('Connection error: $error');
      },
    );
  }

  void clearUnreadMessages() {
    _unreadMessageCount = 0;
    notifyListeners();
  }

  Future<void> chooseCharacter(Character character) async {
    if (_gameState == null || _playerId == null) return;

    try {
      await GameService.chooseCharacter(
        _gameState!.gameCode,
        _playerId!,
        character,
      );

      // Check if both players have chosen
      if (_gameState!.allPlayersChosen) {
        final firstPlayerId = _gameState!.players.keys.first;
        await GameService.startGame(_gameState!.gameCode, firstPlayerId);
      }
    } catch (e) {
      _setError('Failed to choose character: $e');
    }
  }

  // Backwards compatibility
  Future<void> choosePokemon(dynamic pokemon) async {
    if (pokemon is Character) {
      return chooseCharacter(pokemon);
    }
  }

  Future<void> sendQuestion(String question) async {
    if (_gameState == null || _playerId == null) {
      throw Exception('Game state or player ID is null');
    }

    try {
      final message = GameMessage(
        id: GameService.generateMessageId(),
        senderId: _playerId!,
        content: question,
        type: QuestionType.question,
        timestamp: DateTime.now(),
      );

      await GameService.sendMessage(_gameState!.gameCode, message);

      // Switch turn to the other player for answering
      final otherPlayerId = _gameState!.players.keys.firstWhere(
        (id) => id != _playerId,
      );
      await GameService.switchTurn(_gameState!.gameCode, otherPlayerId);
    } catch (e) {
      _setError('Failed to send question: $e');
      rethrow;
    }
  }

  Future<void> sendAnswer(bool? answer, String originalQuestionId) async {
    if (_gameState == null || _playerId == null) {
      throw Exception('Game state or player ID is null');
    }

    try {
      final message = GameMessage(
        id: GameService.generateMessageId(),
        senderId: _playerId!,
        content: answer == null ? "I don't know" : (answer ? 'Yes' : 'No'),
        type: QuestionType.answer,
        timestamp: DateTime.now(),
        answerValue: answer,
      );

      await GameService.sendMessage(_gameState!.gameCode, message);

      // If answer is "I don't know" (null), switch turn back to the questioner
      // so they can ask another question
      if (answer == null) {
        final otherPlayerId = _gameState!.players.keys.firstWhere(
          (id) => id != _playerId,
        );
        await GameService.switchTurn(_gameState!.gameCode, otherPlayerId);
      }
      // Otherwise, don't switch turn - the answerer now asks the next question
      // Turn will switch when they send their question
    } catch (e) {
      _setError('Failed to send answer: $e');
      rethrow;
    }
  }

  Future<void> makeFinalGuess(Character guessedCharacter) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final opponent = this.opponent;
      print('DEBUG makeFinalGuess: Current player ID = $_playerId');
      print(
        'DEBUG makeFinalGuess: Guessed Character ID = ${guessedCharacter.id}',
      );
      print(
        'DEBUG makeFinalGuess: Opponent chosen Character ID = ${opponent?.chosenCharacter?.id}',
      );

      if (opponent?.chosenCharacter?.id == guessedCharacter.id) {
        // Correct guess - increment score and end game
        print(
          'DEBUG makeFinalGuess: CORRECT GUESS! Setting winner to current player: $_playerId',
        );
        await GameService.incrementPlayerScore(
          _gameState!.gameCode,
          _playerId!,
        );
        await GameService.endGame(_gameState!.gameCode, _playerId!);
      } else {
        // Wrong guess - opponent wins
        final opponentId = _gameState!.players.keys.firstWhere(
          (id) => id != _playerId,
        );
        print(
          'DEBUG makeFinalGuess: WRONG GUESS! Setting winner to opponent: $opponentId',
        );
        await GameService.endGame(_gameState!.gameCode, opponentId);
      }
    } catch (e) {
      print('DEBUG makeFinalGuess: ERROR - $e');
      _setError('Failed to make final guess: $e');
    }
  }

  Future<void> eliminateCharacter(int characterId) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final currentUser = this.currentUser;
      if (currentUser != null) {
        currentUser.eliminateCharacter(characterId);
        await GameService.updateEliminatedCharacters(
          _gameState!.gameCode,
          _playerId!,
          currentUser.eliminatedCharacterIds,
        );
      }
    } catch (e) {
      _setError('Failed to eliminate Character: $e');
    }
  }

  // Backwards compatibility
  Future<void> eliminatePokemon(int id) => eliminateCharacter(id);

  Future<void> unEliminateCharacter(int characterId) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final currentUser = this.currentUser;
      if (currentUser != null) {
        currentUser.unEliminateCharacter(characterId);
        await GameService.updateEliminatedCharacters(
          _gameState!.gameCode,
          _playerId!,
          currentUser.eliminatedCharacterIds,
        );
      }
    } catch (e) {
      _setError('Failed to un-eliminate Character: $e');
    }
  }

  // Backwards compatibility
  Future<void> unEliminatePokemon(int id) => unEliminateCharacter(id);

  Future<void> leaveGame() async {
    try {
      if (_gameState != null) {
        // Delete the game from Firebase
        await GameService.deleteGame(_gameState!.gameCode);
      }
    } catch (e) {
    } finally {
      _gameSubscription?.cancel();
      _gameState = null;
      _playerId = null;
      _playerName = null;
      notifyListeners();
    }
  }

  void resetGame() {
    leaveGame();
    _clearError();
  }

  Future<void> setReadyToPlayAgain() async {
    if (_gameState == null || _playerId == null) return;

    try {
      await GameService.updateGameState(_gameState!.gameCode, {
        'playersReadyToPlayAgain': {
          ..._gameState!.playersReadyToPlayAgain,
          _playerId!: true,
        },
      });
    } catch (e) {
      _setError('Error updating play again status: $e');
    }
  }

  Future<void> resetGameForBothPlayers() async {
    if (_gameState == null) return;
    if (_rematchResetting) return;

    _rematchResetting = true;
    _setLoading(true);
    try {
      // Clear unread messages
      _unreadMessageCount = 0;

      // Only the host generates new characters to avoid duplicates
      if (isHost) {
        final characters = await CharacterService.getMultipleRandomCharacters();

        // Randomly select first player for the new round
        final playerIds = _gameState!.players.keys.toList();
        playerIds.shuffle();
        final newFirstPlayerId = playerIds.first;

        // Build updates map with basic game state reset
        final Map<String, dynamic> updates = {
          'currentPhase': GamePhase.characterSelection.name,
          'playersReadyToPlayAgain': {},
          'winner': null,
          'currentRound': 1,
          'messages': [],
          'createdAt': DateTime.now()
              .millisecondsSinceEpoch, // Refresh timestamp to prevent cleanup
          'availableCharacters': characters.map((c) => c.toJson()).toList(),
          'currentPlayerId': newFirstPlayerId, // Set new first player
        };

        // Reset eliminated character and chosen character for all players
        for (final playerId in _gameState!.players.keys) {
          updates['players/$playerId/eliminatedCharacterIds'] = [];
          updates['players/$playerId/eliminatedPokemonIds'] =
              []; // Backwards compatibility
          updates['players/$playerId/chosenCharacter'] = null;
          updates['players/$playerId/chosenPokemon'] =
              null; // Backwards compatibility
        }

        // Reset the game state to character selection phase
        await GameService.updateGameState(_gameState!.gameCode, updates);
        // UI should show the "first player" modal for 3 seconds after rematch
        // (handled in GameScreen UI logic)
        _setLoading(false);
      }
      // Guest stays in loading state until listener receives phase change
    } catch (e) {
      _setError('Error resetting game: $e');
      _setLoading(false);
    } finally {
      _rematchResetting = false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _gameSubscription?.cancel();
    super.dispose();
  }

  Future<void> submitQuestion(String question) async {
    await sendQuestion(question);
  }

  Future<void> submitAnswer(bool? isYes) async {
    await sendAnswer(isYes, '');
  }

  Future<bool> submitGuess(
    Character guessedCharacter,
    String localizedQuestion,
    String localizedNo,
  ) async {
    if (_gameState == null || _playerId == null) {
      throw Exception('Game state or player ID is null');
    }

    try {
      // Check if the guess is correct
      final opponent = this.opponent;
      final isCorrectGuess =
          opponent?.chosenCharacter?.id == guessedCharacter.id;

      if (isCorrectGuess) {
        // Correct guess - increment score and end the game with current player as winner
        await GameService.incrementPlayerScore(
          _gameState!.gameCode,
          _playerId!,
        );
        await GameService.endGame(_gameState!.gameCode, _playerId!);
        return true;
      } else {
        // Wrong guess - send as a question and switch turn
        final message = GameMessage(
          id: GameService.generateMessageId(),
          senderId: _playerId!,
          content: localizedQuestion,
          type: QuestionType.question,
          timestamp: DateTime.now(),
        );

        await GameService.sendMessage(_gameState!.gameCode, message);

        // Automatically send a "No" answer as the opponent
        final otherPlayerId = _gameState!.players.keys.firstWhere(
          (id) => id != _playerId,
        );
        final answerMessage = GameMessage(
          id: GameService.generateMessageId(),
          senderId: otherPlayerId,
          content: localizedNo,
          type: QuestionType.answer,
          timestamp: DateTime.now(),
          answerValue: false,
        );
        await GameService.sendMessage(_gameState!.gameCode, answerMessage);

        // Switch turn to the opponent (so they can ask the next question)
        await GameService.switchTurn(_gameState!.gameCode, otherPlayerId);
        return false;
      }
    } catch (e) {
      _setError('Failed to submit guess: $e');
      rethrow;
    }
  }
}
