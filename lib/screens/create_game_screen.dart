import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../services/game_service.dart';
import 'game_screen.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/settings_modal.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _isCreating = false;
  bool _isWaitingForPlayer = false;
  String? _gameCode;
  StreamSubscription? _gameStateSubscription;
  final Set<int> _selectedGenerations = {};
  final _gameCodeCardKey = GlobalKey();
  int _characterCount = 36; // Default to 36 characters

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    _gameStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _createGame(GameProvider gameProvider) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterName)),
      );
      return;
    }

    if (_selectedGenerations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectGeneration),
        ),
      );
      return;
    }

    /// Ensures the user is signed in anonymously if not already signed in.
    Future<void> ensureSignedIn() async {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
    }

    // Ensure user is authenticated
    await ensureSignedIn();

    // DEBUG: Print current Firebase Auth UID
    print(
      'DEBUG: FirebaseAuth.currentUser?.uid = '
      '${FirebaseAuth.instance.currentUser?.uid}',
    );

    setState(() => _isCreating = true);
    try {
      gameProvider.setPlayerInfo(name);
      // Print the playerId from gameProvider (public getter)
      print('DEBUG: gameProvider.playerId = ${gameProvider.playerId}');
      await gameProvider
          .createGame(
            _selectedGenerations.toList(),
            characterCount: _characterCount,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException(
                'Game creation took too long. Please try again.',
              );
            },
          );

      if (gameProvider.gameState == null) {
        throw Exception(gameProvider.error ?? 'Game could not be created');
      }

      setState(() {
        _gameCode = gameProvider.gameState!.gameCode;
        _isWaitingForPlayer = true;
      });

      // Scroll to the game code card after the frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          _gameCodeCardKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });

      // Start listening for other player joining
      _listenForOtherPlayer(gameProvider);
    } catch (e) {
      final message = gameProvider.error ?? e.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.failedToCreateGame}: $message',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _listenForOtherPlayer(GameProvider gameProvider) {
    if (_gameCode == null) return;

    _gameStateSubscription?.cancel();
    _gameStateSubscription = GameService.listenToGame(_gameCode!).listen((
      gameState,
    ) {
      if (!mounted) return;

      // If both players have joined, navigate to game screen
      if (gameState != null && gameState.players.length >= 2) {
        _gameStateSubscription?.cancel();
        _goToGame();
      }
    }, onError: (error) {});
  }

  void _goToGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            GameScreen(selectedGenerations: _selectedGenerations.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(AppLocalizations.of(context)!.createGameTitle),
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Consumer<GameProvider>(
                builder: (context, gameProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.createGameHeading,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.createGameDescription,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        style: const TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.yourName,
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          counterStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.selectGenerations,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 60,
                            ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          final gen = index + 1;
                          final regions = {
                            1: 'Kanto',
                            2: 'Johto',
                            3: 'Hoenn',
                            4: 'Sinnoh',
                            5: 'Unova',
                            6: 'Kalos',
                            7: 'Alola',
                            8: 'Galar',
                            9: 'Paldea',
                          };
                          final region = regions[gen] ?? '';
                          final isSelected = _selectedGenerations.contains(gen);
                          return GestureDetector(
                            onTap: () {
                              _nameFocus.unfocus();
                              setState(() {
                                if (isSelected) {
                                  _selectedGenerations.remove(gen);
                                } else {
                                  _selectedGenerations.add(gen);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF53E848)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF53E848)
                                      : Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.gen} $gen',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      region,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.numberOfCharacters,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: DropdownButton<int>(
                          value: _characterCount,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: const Color(0xFF1C7ED6),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          items: const [
                            DropdownMenuItem(value: 36, child: Text('36')),
                            DropdownMenuItem(value: 48, child: Text('48')),
                            DropdownMenuItem(value: 64, child: Text('64')),
                            DropdownMenuItem(value: 80, child: Text('80')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _characterCount = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _isCreating
                            ? null
                            : () {
                                _nameFocus.unfocus();
                                _createGame(gameProvider);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: _isCreating
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : const Icon(Icons.qr_code_2),
                        label: Text(
                          _isCreating
                              ? AppLocalizations.of(context)!.generating
                              : AppLocalizations.of(context)!.generateCodeQR,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_gameCode != null) ...[
                        Card(
                          key: _gameCodeCardKey,
                          color: Colors.white,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SelectableText(
                                  _gameCode!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontFamily:
                                            'FiraMono', // Distinguishes 0 and o well
                                        fontFamilyFallback: const [
                                          'RobotoMono',
                                          'monospace',
                                        ],
                                        fontSize: 36,
                                        letterSpacing: 4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: _gameCode!),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.codeCopied,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.copyCode,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                QrImageView(
                                  data: _gameCode!,
                                  version: QrVersions.auto,
                                  size: 180,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                if (_isWaitingForPlayer)
                                  Column(
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.waitingForFriend,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.friendCanScanQR,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.black),
                                  ),
                                const SizedBox(height: 16),
                                if (!_isWaitingForPlayer)
                                  ElevatedButton.icon(
                                    onPressed: _goToGame,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                    icon: const Icon(Icons.videogame_asset),
                                    label: Text(
                                      AppLocalizations.of(context)!.goToLobby,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
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
}
