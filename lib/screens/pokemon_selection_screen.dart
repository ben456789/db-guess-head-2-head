import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../models/pokemon.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/settings_modal.dart';

class PokemonSelectionScreen extends StatefulWidget {
  final GameState gameState;

  const PokemonSelectionScreen({super.key, required this.gameState});

  @override
  State<PokemonSelectionScreen> createState() => _PokemonSelectionScreenState();
}

class _PokemonSelectionScreenState extends State<PokemonSelectionScreen> {
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

  void _showPokemonConfirmation(
    BuildContext context,
    Pokemon pokemon,
    GameProvider gameProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          _getLocalizedPokemonName(pokemon, context),
          style: const TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
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
              gameProvider.choosePokemon(pokemon);
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
          colors: [Color(0xFF1E90FF), Color(0xFF1C7ED6), Color(0xFF1864AB)],
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

                // Compose generations text
                final selectedGens = widget.gameState.selectedGenerations;
                final genRanges = {
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
                final sortedGens =
                    (selectedGens
                        .where((g) => genRanges.containsKey(g))
                        .toList()
                      ..sort());

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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.generationsInGame,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: sortedGens.map((gen) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.gen} $gen',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 4 : 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: widget.gameState.availablePokemon.length,
                        itemBuilder: (context, index) {
                          final pokemon =
                              widget.gameState.availablePokemon[index];
                          final isSelected =
                              currentPlayer?.chosenPokemon?.id == pokemon.id;
                          return _buildPokemonTile(
                            pokemon,
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

  // Helper to get Pokemon name in current locale
  String _getLocalizedPokemonName(Pokemon pokemon, BuildContext context) {
    final locale = Localizations.localeOf(context);
    return pokemon.getLocalizedName(locale.languageCode);
  }

  Widget _buildPokemonTile(
    Pokemon pokemon,
    GameProvider gameProvider,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _showPokemonConfirmation(context, pokemon, gameProvider);
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLocalizedPokemonName(pokemon, context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2,
                    children: pokemon.types.map((type) {
                      final typeColor = _getTypeColor(type);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getLocalizedTypeName(type, context),
                          style: const TextStyle(
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fire':
        return const Color(0xFFF08030);
      case 'water':
        return const Color(0xFF6890F0);
      case 'grass':
        return const Color(0xFF78C850);
      case 'electric':
        return const Color(0xFFF8D030);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'dark':
        return const Color(0xFF705848);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return const Color(0xFF808080);
    }
  }

  String _getLocalizedTypeName(String type, BuildContext context) {
    switch (type.toLowerCase()) {
      case 'normal':
        return AppLocalizations.of(context)!.typeNormal;
      case 'fire':
        return AppLocalizations.of(context)!.typeFire;
      case 'water':
        return AppLocalizations.of(context)!.typeWater;
      case 'grass':
        return AppLocalizations.of(context)!.typeGrass;
      case 'electric':
        return AppLocalizations.of(context)!.typeElectric;
      case 'ice':
        return AppLocalizations.of(context)!.typeIce;
      case 'fighting':
        return AppLocalizations.of(context)!.typeFighting;
      case 'poison':
        return AppLocalizations.of(context)!.typePoison;
      case 'ground':
        return AppLocalizations.of(context)!.typeGround;
      case 'flying':
        return AppLocalizations.of(context)!.typeFlying;
      case 'psychic':
        return AppLocalizations.of(context)!.typePsychic;
      case 'bug':
        return AppLocalizations.of(context)!.typeBug;
      case 'rock':
        return AppLocalizations.of(context)!.typeRock;
      case 'ghost':
        return AppLocalizations.of(context)!.typeGhost;
      case 'dragon':
        return AppLocalizations.of(context)!.typeDragon;
      case 'dark':
        return AppLocalizations.of(context)!.typeDark;
      case 'steel':
        return AppLocalizations.of(context)!.typeSteel;
      case 'fairy':
        return AppLocalizations.of(context)!.typeFairy;
      default:
        return type[0].toUpperCase() + type.substring(1);
    }
  }
}
