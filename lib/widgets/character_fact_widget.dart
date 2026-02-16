import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

/// Displays a random Dragon Ball character fact
class CharacterFactWidget extends StatefulWidget {
  const CharacterFactWidget({super.key});

  @override
  State<CharacterFactWidget> createState() => _CharacterFactWidgetState();
}

class _CharacterFactWidgetState extends State<CharacterFactWidget> {
  String? _currentFact;
  bool _isLoading = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _loadFact();
  }

  Future<void> _loadFact() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final newFact = await _fetchCharacterFact();

    if (!mounted) return;

    setState(() {
      _currentFact = newFact;
      _isLoading = false;
      _isVisible = true;
    });
  }

  Future<void> _refreshFact() async {
    setState(() {
      _isVisible = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final newFact = await _fetchCharacterFact();

    if (!mounted) return;

    setState(() {
      _currentFact = newFact;
      _isVisible = true;
    });
  }

  Future<String?> _fetchCharacterFact() async {
    try {
      // Fetch a random character from the Dragon Ball API
      final randomId = Random().nextInt(58) + 1; // 1-58 characters
      final response = await http
          .get(Uri.parse('https://dragonball-api.com/api/characters/$randomId'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = data['name'] ?? 'Unknown';
        final race = data['race'] ?? 'Unknown';
        final affiliation = data['affiliation'] ?? 'Unknown';
        final ki = data['ki'] ?? '0';

        // Create interesting facts from the character data
        final facts = [
          '$name is a $race.',
          '$name\'s affiliation is $affiliation.',
          '$name has a base KI of $ki.',
          'Did you know? $name is one of the 58 characters in the Dragon Ball universe!',
        ];

        // Return a random fact about this character
        return facts[Random().nextInt(facts.length)];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _currentFact == null) {
      return const SizedBox.shrink();
    }

    if (_currentFact == null) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.withOpacity(0.2),
              Colors.red.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _currentFact!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.orange,
              iconSize: 20,
              onPressed: _refreshFact,
              tooltip: 'New fact',
            ),
          ],
        ),
      ),
    );
  }
}

// Backwards compatibility
class PokemonFactWidget extends CharacterFactWidget {
  const PokemonFactWidget({super.key});
}
