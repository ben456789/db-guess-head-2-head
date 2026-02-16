import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  GameState? _gameState;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<GameState?>? _gameSubscription;
  String? _playerId;
  String? _playerName;

  GameState? get gameState => _gameState;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get playerId => _playerId;
  String? get playerName => _playerName;

  bool get isHost => _gameState?.hostId == _playerId;
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

  void setPlayerInfo(String name) {
    _playerId = GameService.generatePlayerId();
    _playerName = name;
    notifyListeners();
  }

  Future<void> createGame(List<int> selectedGenerations) async {
    if (_playerId == null || _playerName == null) return;

    _setLoading(true);
    _clearError();

    try {
      _gameState = await GameService.createGame(
        _playerId!,
        _playerName!,
        selectedGenerations,
      );

      // Load Pokemon for selected generations
      final pokemon = await PokemonService.getPokemonByGenerations(
        selectedGenerations,
        36,
      );
      await GameService.setPokemon(_gameState!.gameCode, pokemon);

      _listenToGameChanges(_gameState!.gameCode);
    } catch (e) {
      _setError('Failed to create game: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinGame(String gameCode) async {
    if (_playerId == null || _playerName == null) return;

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
    _gameSubscription = GameService.listenToGame(gameCode).listen(
      (gameState) {
        if (gameState != null) {
          _gameState = gameState;
          notifyListeners();
        }
      },
      onError: (error) {
        _setError('Connection error: $error');
      },
    );
  }

  Future<void> choosePokemon(Pokemon pokemon) async {
    if (_gameState == null || _playerId == null) return;

    try {
      await GameService.choosePokemon(
        _gameState!.gameCode,
        _playerId!,
        pokemon,
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

  Future<void> sendQuestion(String question) async {
    if (_gameState == null || _playerId == null) return;

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
    }
  }

  Future<void> sendAnswer(bool answer, String originalQuestionId) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final message = GameMessage(
        id: GameService.generateMessageId(),
        senderId: _playerId!,
        content: answer ? 'Yes' : 'No',
        type: QuestionType.answer,
        timestamp: DateTime.now(),
        answerValue: answer,
      );

      await GameService.sendMessage(_gameState!.gameCode, message);

      // Switch turn back to the question asker
      final otherPlayerId = _gameState!.players.keys.firstWhere(
        (id) => id != _playerId,
      );
      await GameService.switchTurn(_gameState!.gameCode, otherPlayerId);
    } catch (e) {
      _setError('Failed to send answer: $e');
    }
  }

  Future<void> makeFinalGuess(Pokemon guessedPokemon) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final opponent = this.opponent;
      if (opponent?.chosenPokemon?.id == guessedPokemon.id) {
        // Correct guess - player wins
        await GameService.endGame(_gameState!.gameCode, _playerId!);
      } else {
        // Wrong guess - opponent wins
        final opponentId = _gameState!.players.keys.firstWhere(
          (id) => id != _playerId,
        );
        await GameService.endGame(_gameState!.gameCode, opponentId);
      }
    } catch (e) {
      _setError('Failed to make final guess: $e');
    }
  }

  Future<void> eliminatePokemon(int pokemonId) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final currentUser = this.currentUser;
      if (currentUser != null) {
        currentUser.eliminatePokemon(pokemonId);
        await GameService.updateEliminatedPokemon(
          _gameState!.gameCode,
          _playerId!,
          currentUser.eliminatedPokemonIds,
        );
      }
    } catch (e) {
      _setError('Failed to eliminate Pokemon: $e');
    }
  }

  Future<void> unEliminatePokemon(int pokemonId) async {
    if (_gameState == null || _playerId == null) return;

    try {
      final currentUser = this.currentUser;
      if (currentUser != null) {
        currentUser.unEliminatePokemon(pokemonId);
        await GameService.updateEliminatedPokemon(
          _gameState!.gameCode,
          _playerId!,
          currentUser.eliminatedPokemonIds,
        );
      }
    } catch (e) {
      _setError('Failed to un-eliminate Pokemon: $e');
    }
  }

  void leaveGame() {
    _gameSubscription?.cancel();
    _gameState = null;
    _playerId = null;
    _playerName = null;
    notifyListeners();
  }

  void resetGame() {
    leaveGame();
    _clearError();
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
}
