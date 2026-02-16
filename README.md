# Dragon Ball Character Head 2 Head 🎯

A multiplayer "Guess Who" style game with Dragon Ball characters! Players take turns asking yes/no questions to guess their opponent's chosen character.

## Features

- **Multiplayer Gameplay**: Real-time communication between two devices
- **Dragon Ball Characters**: 58 characters from the Dragon Ball universe
- **QR Code Game Joining**: Easy game joining via QR code or manual code entry
- **Grid-Based Character Display**: Visual grid of all available characters
- **Yes/No Question System**: Ask strategic questions to eliminate characters
- **Character Elimination**: Toggle off characters as you narrow down possibilities

## How to Play

1. **Create Game**: Player 1 creates a game
2. **Join Game**: Player 2 joins via QR code scan or manual code entry
3. **Character Selection**: 36 characters from the Dragon Ball universe are displayed
4. **Choose Character**: Each player secretly selects their character
5. **Ask Questions**: Take turns asking yes/no questions about opponent's character
6. **Eliminate Characters**: Use answers to eliminate characters from the grid
7. **Final Guess**: Make your final guess when you think you know their character
8. **Win Condition**: First player to correctly guess wins!

## Game Screens

- **Setup Screen**: Enter player names and view game rules
- **Game Screen**: View character images and make guesses
- **Result Screen**: See if your guess was correct and learn about the character
- **Game Over**: Final scores and play again option

## Technical Features

- Built with Flutter for cross-platform compatibility
- Uses Provider for state management
- Integrates with Dragon Ball API (https://web.dragonball-api.com/) for character data
- Cached network images for better performance
- Smooth animations and transitions
- Responsive design for different screen sizes

## API Integration

This game uses the Dragon Ball API to fetch character data:

- **Base URL**: https://dragonball-api.com/api/characters
- **Total Characters**: 58
- **Character Attributes**: Name, race, gender, KI, affiliation, transformations, and more

## Getting Started

### Prerequisites

- Flutter SDK (3.10.7 or higher)
- Android Studio / Xcode for device testing
- Internet connection (required for character API)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd db-guess-head-2-head
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### For Android:

- Connect an Android device or start an emulator
- Run `flutter run` to install and launch the app

### For iOS:

- Open the project in Xcode (requires macOS)
- Connect an iOS device or use the iOS Simulator
- Run `flutter run` to install and launch the app

## Dependencies

- **flutter**: The core Flutter framework
- **http**: For making API requests to Dragon Ball API
- **provider**: State management solution
- **cached_network_image**: Efficient image loading and caching
- **firebase_core**: Firebase integration
- **firebase_database**: Real-time database for multiplayer
- **firebase_auth**: User authentication
- **cupertino_icons**: iOS-style icons

## API Used

This game uses the [Dragon Ball API](https://web.dragonball-api.com/) - a free RESTful API providing comprehensive character data including:

- Character names and IDs
- High-quality character artwork
- Race information (Saiyan, Human, Namekian, etc.)
- Power levels (KI)
- Affiliations (Z Fighter, Army of Frieza, etc.)
- Character transformations
- Physical characteristics and descriptions

## Game Flow

```
Setup Screen → Character Selection → Game Screen → Result Screen → Game Over Screen
     ↑                                                                    ↓
     ←←←←←←←←←←←←←←← Play Again Button ←←←←←←←←←←←←←←←←←←←←←←←←←←←
```

## Screenshots

The app features a modern, colorful design with:

- Gradient backgrounds
- Card-based layouts
- Smooth animations
- Responsive character image display
- Real-time multiplayer via Firebase
- Clear score tracking

## Contributing

Feel free to contribute to this project by:

- Adding new game modes
- Improving the UI/UX
- Adding sound effects
- Implementing difficulty levels
- Adding character filters (by race/affiliation)

## Acknowledgments

- Dragon Ball characters and artwork © their respective owners
- Dragon Ball API by Antonio Alvarez (https://antonioalvarez.dev/)
- This is a fan-made game and is not officially associated with Dragon Ball

## License

This project is open source and available under the MIT License.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter clean
flutter pub get
flutter run
flutter run -d web-server

#e6c229 - 0xFFe6c229
#f17105 - 0xFFf17105
#d11149 - 0xFFd11149
#6610f2 - 0xFF6610f2
#1a8fe3 - 0xFF1a8fe3
