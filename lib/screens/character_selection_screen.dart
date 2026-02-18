import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../models/character.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/settings_modal.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final GameState gameState;

  const CharacterSelectionScreen({super.key, required this.gameState});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  void _showLeaveConfirmation(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.leaveGame),
        content: Text(AppLocalizations.of(context)!.leaveGameConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              gameProvider.leaveGame().then((_) {
                // Navigate back to home screen
                if (!mounted) return;
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
            child: Text(
              AppLocalizations.of(context)!.leave,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showCharacterConfirmation(
    BuildContext context,
    Character character,
    GameProvider gameProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          _getLocalizedCharacterName(character, context),
          style: const TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: character.imageUrl,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              gameProvider.choosePokemon(character);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 255, 120, 30),
            Color.fromARGB(255, 214, 133, 28),
            Color.fromARGB(255, 171, 83, 24),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectCharacter),
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
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                final gameProvider = context.read<GameProvider>();
                _showLeaveConfirmation(context, gameProvider);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                final currentPlayer =
                    gameProvider.playerId == widget.gameState.playerOne.id
                    ? widget.gameState.playerOne
                    : widget.gameState.playerTwo;
                final opponentPlayer =
                    gameProvider.playerId == widget.gameState.playerOne.id
                    ? widget.gameState.playerTwo
                    : widget.gameState.playerOne;

                // --- Persistent Snackbar Logic ---
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final hasOpponentChosen =
                      opponentPlayer?.chosenPokemon != null;
                  final hasCurrentChosen = currentPlayer?.chosenPokemon != null;
                  final messenger = ScaffoldMessenger.of(context);
                  final snackBarKey = ValueKey('opponent_ready_snackbar');
                  // Only show if opponent is ready and current player is not
                  if (hasOpponentChosen && !hasCurrentChosen) {
                    // Only show if not already shown
                    if (ModalRoute.of(context)?.isCurrent ?? true) {
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.opponentReady,
                          ),
                          duration: const Duration(
                            days: 365,
                          ), // Effectively persistent
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          key: snackBarKey,
                          action: SnackBarAction(
                            label: AppLocalizations.of(context)!.dismiss,
                            textColor: Colors.white,
                            onPressed: () {
                              messenger.clearSnackBars();
                            },
                          ),
                        ),
                      );
                    }
                  } else {
                    messenger.clearSnackBars();
                  }
                });
                // --- End Persistent Snackbar Logic ---

                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.playingAgainst(
                        gameProvider.playerId == widget.gameState.playerOne.id
                            ? (widget.gameState.playerTwo?.name ?? "Opponent")
                            : widget.gameState.playerOne.name,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 4 : 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: widget.gameState.availableCharacters.length,
                        itemBuilder: (context, index) {
                          final character =
                              widget.gameState.availableCharacters[index];
                          final isSelected =
                              currentPlayer?.chosenCharacter?.id ==
                              character.id;
                          return _buildCharacterTile(
                            character,
                            gameProvider,
                            isSelected,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Banner Ad at the bottom
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: const SafeArea(child: BannerAdWidget()),
        ),
      ),
    );
  }

  // Helper to get Character name in current locale
  String _getLocalizedCharacterName(Character character, BuildContext context) {
    final locale = Localizations.localeOf(context);
    return character.getLocalizedName(locale.languageCode);
  }

  Widget _buildCharacterTile(
    Character character,
    GameProvider gameProvider,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _showCharacterConfirmation(context, character, gameProvider);
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: character.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLocalizedCharacterName(character, context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
