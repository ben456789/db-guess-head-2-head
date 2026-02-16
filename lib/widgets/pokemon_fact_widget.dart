import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Displays a random Pokémon fact from https://pokefacts.vercel.app/
/// Only shows content when the current locale is English.
class PokemonFactWidget extends StatefulWidget {
  const PokemonFactWidget({super.key});

  @override
  State<PokemonFactWidget> createState() => _PokemonFactWidgetState();
}

class _PokemonFactWidgetState extends State<PokemonFactWidget> {
  String? _fact;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupFetchingForLocale();
  }

  void _setupFetchingForLocale() {
    final locale = Localizations.localeOf(context);
    final isEnglish = locale.languageCode == 'en';

    if (!isEnglish) {
      // Stop any ongoing periodic fetches and clear the fact.
      _timer?.cancel();
      _timer = null;
      if (_fact != null) {
        setState(() {
          _fact = null;
        });
      }
      return;
    }

    // Already set up for English; nothing more to do.
    if (_timer != null) {
      return;
    }

    // Fetch immediately, then every 20 seconds.
    _fetchAndSetFact();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      _fetchAndSetFact();
    });
  }

  Future<void> _fetchAndSetFact() async {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode != 'en') return;

    final newFact = await _fetchPokemonFact();
    if (!mounted) return;

    if (newFact == null || newFact.isEmpty) return;

    setState(() {
      _fact = newFact;
    });
  }

  Future<String?> _fetchPokemonFact() async {
    try {
      final uri = Uri.parse('https://pokefacts.vercel.app/');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];
        if (data is List && data.isNotEmpty && data.first is String) {
          return data.first as String;
        }
      }
    } catch (_) {
      // Silently fail; we simply won't show a fact.
    }
    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    // Do not show anything for non-English locales.
    if (locale.languageCode != 'en') {
      return const SizedBox.shrink();
    }

    if (_fact == null || _fact!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lightbulb_outline, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Did you know?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _fact!,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
