import 'package:flutter/material.dart';
import '../services/character_service.dart';
import '../models/character.dart';

/// Test screen to verify Dragon Ball API integration
/// This can be used to test character fetching before integrating into the game
class CharacterApiTestScreen extends StatefulWidget {
  const CharacterApiTestScreen({super.key});

  @override
  State<CharacterApiTestScreen> createState() => _CharacterApiTestScreenState();
}

class _CharacterApiTestScreenState extends State<CharacterApiTestScreen> {
  List<Character>? _characters;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final characters = await CharacterService.getMultipleRandomCharacters(10);
      setState(() {
        _characters = characters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dragon Ball API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCharacters,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Dragon Ball characters...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCharacters,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_characters == null || _characters!.isEmpty) {
      return const Center(child: Text('No characters loaded'));
    }

    return ListView.builder(
      itemCount: _characters!.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final character = _characters![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      character.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 40),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('ID: ${character.id}'),
                          Text('Race: ${character.race}'),
                          Text('Gender: ${character.gender}'),
                          Text('Affiliation: ${character.affiliation}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Base KI',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              character.ki,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Max KI',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              character.maxKi,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (character.transformations != null &&
                    character.transformations!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Transformations: ${character.transformations!.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  character.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
