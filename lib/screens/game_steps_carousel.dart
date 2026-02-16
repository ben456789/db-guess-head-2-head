import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class GameStepsCarousel extends StatefulWidget {
  const GameStepsCarousel({super.key});

  @override
  State<GameStepsCarousel> createState() => _GameStepsCarouselState();
}

class _GameStepsCarouselState extends State<GameStepsCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'title': AppLocalizations.of(context)!.creatingGame,
        'desc': AppLocalizations.of(context)!.creatingGameDesc,
      },
      {
        'title': AppLocalizations.of(context)!.joiningGame,
        'desc': AppLocalizations.of(context)!.joiningGameDesc,
      },
      {
        'title': AppLocalizations.of(context)!.playingGame,
        'desc': AppLocalizations.of(context)!.playingGameDesc,
      },
    ];
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: steps.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        step['desc']!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _currentPage > 0
                  ? () => _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    )
                  : null,
            ),
            ...List.generate(
              steps.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentPage ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _currentPage < steps.length - 1
                  ? () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
