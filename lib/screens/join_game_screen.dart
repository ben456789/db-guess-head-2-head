import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/settings_modal.dart';

String? _codeErrorText;

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  @override
  void initState() {
    super.initState();
    _codeErrorText = null;
  }

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  bool _joining = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join(GameProvider gameProvider) async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim().toUpperCase();

    if (name.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterNameAndCode)),
      );
      return;
    }

    // Ensure anonymous sign-in before joining
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.failedToSignIn}: $e'),
        ),
      );
      return;
    }

    setState(() => _joining = true);
    try {
      gameProvider.setPlayerInfo(name);
      await gameProvider.joinGame(code);
      if (!mounted) return;
      if (gameProvider.gameState == null) {
        setState(() {
          _codeErrorText = AppLocalizations.of(context)!.gameNotFoundCheckCode;
        });
        return;
      } else {
        setState(() {
          _codeErrorText = null;
        });
      }
      // Navigate to GameScreen — it will route to CharacterSelectionScreen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const GameScreen(selectedGenerations: []),
          ),
        );
      }
      return;
    } catch (e) {
      setState(() {
        _codeErrorText = '${AppLocalizations.of(context)!.failedToJoin}: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.failedToJoin}: $e'),
        ),
      );
    } finally {
      // Only set _joining to false here if we didn't already do it before navigation
      if (mounted && _joining) setState(() => _joining = false);
    }
  }

  Future<void> _scanCode() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.qrScanningNotAvailableWeb,
          ),
        ),
      );
      return;
    }

    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: MobileScanner(
            onDetect: (capture) async {
              final code = capture.barcodes.first.rawValue;
              if (code != null && code.length >= 6) {
                Navigator.of(context).pop(code.trim().toUpperCase());
              }
            },
          ),
        );
      },
    );

    if (code != null && code.length >= 6) {
      _codeController.text = code;
      // Only auto-join if name is filled
      if (_nameController.text.trim().isNotEmpty) {
        if (_joining) {
          return;
        }
        // Add a short delay to ensure context is stable after modal pop
        await Future.delayed(const Duration(milliseconds: 100));
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        setState(() => _joining = true);
        try {
          await _join(gameProvider);
        } finally {
          if (mounted) setState(() => _joining = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(AppLocalizations.of(context)!.joinGame),
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
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.joinAFriend,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.enterNameAndCodeOrScan,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _codeController,
                      style: const TextStyle(color: Colors.white),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [UpperCaseTextFormatter()],
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.gameCode,
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: AppLocalizations.of(context)!.gameCodeExample,
                        hintStyle: const TextStyle(color: Colors.white70),
                        errorText: _codeErrorText,
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(
                          Icons.key,
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
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white70,
                          ),
                          onPressed: kIsWeb ? null : _scanCode,
                        ),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _joining ? null : () => _join(gameProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: _joining
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
                          : const Icon(Icons.login),
                      label: Text(
                        _joining
                            ? AppLocalizations.of(context)!.generating
                            : AppLocalizations.of(context)!.joinGame,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    // Banner Ad
                    const BannerAdWidget(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
