import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vibration/vibration.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../models/pokemon.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/interstitial_ad_widget.dart';
import '../widgets/settings_modal.dart';
import '../services/settings_service.dart';
import '../l10n/app_localizations.dart';

class GameOverScreen extends StatelessWidget {
  final GameState gameState;

  const GameOverScreen({super.key, required this.gameState});

  // Helper to get Pokemon name in current locale
  String _getLocalizedPokemonName(Pokemon pokemon, BuildContext context) {
    final locale = Localizations.localeOf(context);
    return pokemon.getLocalizedName(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final currentPlayerId = gameProvider.playerId;

    // Vibrate to signal game over (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SettingsService.isVibrationEnabled().then((enabled) {
        if (enabled) {
          Vibration.vibrate(duration: 300, amplitude: 255);
          Future.delayed(const Duration(milliseconds: 400), () {
            Vibration.vibrate(duration: 300, amplitude: 255);
          });
        }
      });
    });

    // Show loading screen while resetting game
    if (gameProvider.isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E90FF), Color(0xFF1C7ED6), Color(0xFF1864AB)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.gameOver),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsModal(),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.startingNewRound,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Load and show interstitial ad during loading
              const InterstitialAdWidget(),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            child: const SafeArea(child: BannerAdWidget()),
          ),
        ),
      );
    }

    // Determine winner from game state
    // The winner field should always be set by the backend when the game ends
    var winnerId = gameState.isTied ? null : gameState.winner;
    // Determine if current player won based on winnerId
    final isCurrentPlayerWinner =
        winnerId != null && currentPlayerId == winnerId;

    // Get winner player - check both player one and player two
    Player? winnerPlayer;
    if (winnerId == gameState.playerOne.id) {
      winnerPlayer = gameState.playerOne;
    } else if (winnerId == gameState.playerTwo?.id) {
      winnerPlayer = gameState.playerTwo;
    }

    // If we can't find the winner player but we know it's not the current player,
    // then the opponent must be the winner
    if (winnerPlayer == null && winnerId != null && !isCurrentPlayerWinner) {
      winnerPlayer = gameState.playerOne.id != currentPlayerId
          ? gameState.playerOne
          : gameState.playerTwo;
    }

    // Get both players' chosen character
    final playerOneChosenPokemon = gameState.playerOne.chosenPokemon;
    final playerTwoChosenPokemon = gameState.playerTwo?.chosenPokemon;

    // Get both players' scores
    final playerOneScore = gameState.playerOne.score;
    final playerTwoScore = gameState.playerTwo?.score ?? 0;

    // Check if both players are ready to play again
    final currentPlayerReady =
        gameState.playersReadyToPlayAgain[currentPlayerId] ?? false;
    final otherPlayerId = currentPlayerId == gameState.playerOne.id
        ? gameState.playerTwo?.id
        : gameState.playerOne.id;
    final otherPlayerReady = otherPlayerId != null
        ? gameState.playersReadyToPlayAgain[otherPlayerId] ?? false
        : false;
    final bothReady = currentPlayerReady && otherPlayerReady;

    // If both players are ready, navigate back to character selection
    if (bothReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.resetGameForBothPlayers();
      });
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E90FF), Color(0xFF1C7ED6), Color(0xFF1864AB)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.gameOver),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SettingsModal(),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Winner/Loser message
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              if (isCurrentPlayerWinner) ...[
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.emoji_events,
                                    size: 80,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.youWin,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF53E848),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.youSuccessfullyGuessed,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ] else ...[
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.close,
                                    size: 80,
                                    color: Color(0xFFd11149),
                                    weight: 900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.opponentWins(
                                    winnerPlayer?.name ?? 'Opponent',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.opponentGuessedCorrectly(
                                    winnerPlayer?.name ?? 'Opponent',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],

                              const SizedBox(height: 32),

                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.charactersSelected,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: _buildPokemonResultCard(
                                      gameState.playerOne.name,
                                      playerOneChosenPokemon,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildPokemonResultCard(
                                      gameState.playerTwo?.name ?? 'Player 2',
                                      playerTwoChosenPokemon,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Scoreboard (always visible)
                      Card(
                        color: Colors.white.withOpacity(0.1),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.score,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        gameState.playerOne.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        playerOneScore.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        gameState.playerTwo?.name ?? 'Player 2',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        playerTwoScore.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Show waiting message or play again button
                      if (otherPlayerReady && !currentPlayerReady)
                        Card(
                          color: Colors.green,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.wantsToPlayAgain(
                                      winnerPlayer?.name ?? 'Player',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentPlayerReady && !otherPlayerReady)
                        Card(
                          color: const Color(0xFFe6c229),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.waitingForOpponentToPlayAgain,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (!bothReady)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              if (currentPlayerReady || otherPlayerReady)
                                const SizedBox(height: 16),
                              Consumer<GameProvider>(
                                builder: (context, gameProvider, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: !currentPlayerReady
                                          ? () => gameProvider
                                                .setReadyToPlayAgain()
                                          : null,
                                      icon: const Icon(Icons.refresh),
                                      label: Text(
                                        currentPlayerReady
                                            ? AppLocalizations.of(
                                                context,
                                              )!.waitingForOpponentEllipsis
                                            : AppLocalizations.of(
                                                context,
                                              )!.playAgain,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentPlayerReady
                                            ? Colors.grey
                                            : Colors.white,
                                        foregroundColor: const Color(
                                          0xFF363636,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Banner Ad at the bottom
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: const SafeArea(child: BannerAdWidget()),
        ),
      ),
    );
  }

  Widget _buildPokemonResultCard(String playerName, Pokemon? pokemon) {
    return Builder(
      builder: (context) {
        return Card(
          color: const Color(0xFFffffff),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (pokemon != null)
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getLocalizedPokemonName(pokemon, context),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  const SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(fontSize: 40, color: Colors.white30),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
