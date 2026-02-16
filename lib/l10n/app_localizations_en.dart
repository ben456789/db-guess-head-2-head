// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Head 2 Head Guessing Game';

  @override
  String get gameDescription =>
      'Guess which Poké character your opponent has chosen before they guess yours!';

  @override
  String get createGame => 'Create Game';

  @override
  String get joinGame => 'Join Game';

  @override
  String get settings => 'Settings';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get legalTerms => 'Legal & Terms';

  @override
  String get close => 'Close';

  @override
  String get yourName => 'Your name';

  @override
  String get selectGenerations => 'Select Generations for the game';

  @override
  String get numberOfCharacters => 'Number of Characters';

  @override
  String get generating => 'Creating...';

  @override
  String get generateCodeQR => 'Generate Code & QR';

  @override
  String get waitingForPlayer =>
      'Waiting for another player to scan QR or enter code...';

  @override
  String get gameCodeLabel => 'Game Code';

  @override
  String get orScanQR => 'Or scan this QR code';

  @override
  String get goToLobby => 'Go to Lobby';

  @override
  String get pleaseEnterName => 'Please enter your name.';

  @override
  String get pleaseSelectGeneration => 'Please select at least one generation.';

  @override
  String get failedToCreateGame => 'Failed to create game';

  @override
  String get enterNameAndCode => 'Enter your name and the 6-digit code.';

  @override
  String get gameCodeHint => 'e.g. ABC123';

  @override
  String get failedToJoin => 'Failed to join';

  @override
  String get failedToSignIn => 'Failed to sign in';

  @override
  String get leaveGame => 'Leave Game?';

  @override
  String get leave => 'Leave';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectCharacter => 'Select Character';

  @override
  String get opponentReady => 'Your opponent is ready!';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get gameOver => 'Game Over';

  @override
  String get questionSent => '✅ Question sent!';

  @override
  String get answerSent => '✅ Answer sent!';

  @override
  String get error => '❌ Error';

  @override
  String get sendingAnswer => '📤 Sending answer';

  @override
  String get opponentLeft => 'Your opponent left the game';

  @override
  String get guessTheCharacter => 'Guess the character!';

  @override
  String get askQuestion => 'Ask a question...';

  @override
  String get noCharacterToGuess => 'No available Character to guess';

  @override
  String get guess => 'Guess';

  @override
  String get roundResult => 'Round Result';

  @override
  String get language => 'Language';

  @override
  String get vibration => 'Vibration';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get iDontKnow => 'I don\'t know';

  @override
  String get kanto => 'Kanto';

  @override
  String get johto => 'Johto';

  @override
  String get hoenn => 'Hoenn';

  @override
  String get sinnoh => 'Sinnoh';

  @override
  String get unova => 'Unova';

  @override
  String get kalos => 'Kalos';

  @override
  String get alola => 'Alola';

  @override
  String get galar => 'Galar';

  @override
  String get paldea => 'Paldea';

  @override
  String get eula => 'End User License Agreement (EULA)';

  @override
  String get eulaTitle => 'EULA';

  @override
  String get eulaContent =>
      'This app is provided under the MIT License. By using this app, you agree to abide by the terms and conditions set forth in the license and any applicable app store requirements.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceContent =>
      'By using this app, you agree to use it for entertainment purposes only and not for any unlawful activity. See the MIT License for more details.';

  @override
  String get pokemonTrademarkNotice =>
      'Pokémon and Pokémon character names are trademarks of Nintendo.';

  @override
  String get creatingGame => 'Creating a game';

  @override
  String get creatingGameDesc =>
      '1. Create the game by pressing the \"Create Game\" button\n2. Enter your name and select which generations and how many characters you want to include in the match\n3. Generate a game code or QR code to share with your opponent\n4. Share with your opponent for them to join';

  @override
  String get joiningGame => 'Joining a game';

  @override
  String get joiningGameDesc =>
      '1. Join a game by pressing the \"Join Game\" button\n2. Enter your name and the game code or scan the QR code\n3. Choose your character';

  @override
  String get playingGame => 'Playing the game';

  @override
  String get playingGameDesc =>
      '1. A coin flip is decided as to who goes first\n2. Take turns asking yes/no questions using the chat interface\n3. Eliminate characters based on the answers\n4. Guess which character your opponent has chosen before they guess yours!';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyIntro =>
      'This app uses Firebase services to provide multiplayer features and store game data. We may collect basic information such as usernames, game progress, and device information for the purpose of gameplay and improving the app. No personal information is sold or shared with third parties except as required by Firebase or by law.';

  @override
  String get dataCollected => 'Data Collected:';

  @override
  String get dataCollectedList =>
      '- Usernames and game codes\n- Game progress and scores\n- Device information (for analytics/debugging)';

  @override
  String get howWeUseData => 'How We Use Data:';

  @override
  String get howWeUseDataList =>
      '- To enable multiplayer gameplay\n- To save your progress\n- To improve app performance and stability';

  @override
  String get thirdPartyServices => 'Third-Party Services:';

  @override
  String get thirdPartyServicesDesc =>
      'We use Google Firebase for authentication, database, and analytics. Please refer to Firebase\'s privacy policy for more details.';

  @override
  String get contact => 'Contact:';

  @override
  String get contactDesc =>
      'If you have questions about privacy, contact the developer.';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get codeCopied => 'Game code copied to clipboard!';

  @override
  String get gameNotFound => 'Game not found. Please check the code.';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get joining => 'Joining...';

  @override
  String get gen => 'Gen';

  @override
  String get createGameTitle => 'Create Game';

  @override
  String get createGameHeading => 'Create game';

  @override
  String get createGameDescription =>
      'Enter your name to generate a 6-digit code and QR for your friend to join.';

  @override
  String get waitingForFriend => 'Waiting for friend to join...';

  @override
  String get friendCanScanQR =>
      'Friend can scan this QR or enter the code to join.';

  @override
  String get score => 'Score';

  @override
  String get joinAFriend => 'Join a friend';

  @override
  String get enterNameAndCodeOrScan =>
      'Enter your name and the 6-digit code, or scan their QR.';

  @override
  String get gameCode => 'Game code';

  @override
  String get gameCodeExample => 'e.g. ABC123';

  @override
  String get qrScanningNotAvailableWeb =>
      'QR scanning is not available on web. Please enter the code manually.';

  @override
  String get gameNotFoundCheckCode => 'Game not found. Please check the code.';

  @override
  String failedToJoinError(Object error) {
    return 'Failed to join: $error';
  }

  @override
  String get leaveGameConfirmation =>
      'Are you sure you want to leave? The game will be terminated.';

  @override
  String playingAgainst(String opponentName) {
    return 'Playing against: $opponentName';
  }

  @override
  String get generationsInGame => 'Generations in this game:';

  @override
  String get yourCharacter => 'Your Character';

  @override
  String get chat => 'Chat';

  @override
  String get yourTurnToAnswer => 'Your turn to answer';

  @override
  String get yourTurnToAsk => 'Your turn to ask';

  @override
  String get waitingForAnswer => 'Waiting for answer';

  @override
  String get waitingForQuestion => 'Waiting for question';

  @override
  String get hideEliminated => 'Hide Eliminated';

  @override
  String charactersRemaining(String opponentName, int count) {
    return '$opponentName has $count characters remaining';
  }

  @override
  String get noAvailableCharacter => 'No available Character to guess';

  @override
  String get makeAGuess => 'Make a Guess!';

  @override
  String confirmGuess(String pokemonName) {
    return 'Are you sure you want to guess $pokemonName?';
  }

  @override
  String get noMessagesYet => 'No messages yet...';

  @override
  String get eliminateReminder =>
      'Don\'t forget to eliminate characters! They can be found at the end of the list (Unless Hidden).';

  @override
  String get opponentTyping => 'Opponent is typing...';

  @override
  String get sendQuestion => 'Send Question';

  @override
  String get guessCharacter => 'Guess Character';

  @override
  String get waitingForAnswerEllipsis => 'Waiting for answer...';

  @override
  String get waitingForQuestionEllipsis => 'Waiting for question...';

  @override
  String get dontKnow => 'Don\'t know';

  @override
  String get youGoFirst => 'You go first!';

  @override
  String playerGoesFirst(String playerName) {
    return '$playerName goes first!';
  }

  @override
  String get correct => 'CORRECT!';

  @override
  String get timesUp => 'TIME\'S UP!';

  @override
  String get incorrect => 'INCORRECT!';

  @override
  String get nextRoundStarting => 'Next round starting...';

  @override
  String get startingNewRound => 'Starting new round...';

  @override
  String get youWin => '🎉 YOU WIN! 🎉';

  @override
  String get youSuccessfullyGuessed =>
      'You successfully guessed your opponent\'s Character!';

  @override
  String opponentWins(String opponentName) {
    return '$opponentName wins';
  }

  @override
  String opponentGuessedCorrectly(String opponentName) {
    return '$opponentName guessed your Character correctly!';
  }

  @override
  String get charactersSelected => 'Characters Selected:';

  @override
  String wantsToPlayAgain(String playerName) {
    return '$playerName wants to play again!';
  }

  @override
  String get waitingForOpponentToPlayAgain =>
      'Waiting for opponent to play again...';

  @override
  String get waitingForOpponentEllipsis => 'Waiting for opponent...';

  @override
  String get playAgain => 'Play again';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Fire';

  @override
  String get typeWater => 'Water';

  @override
  String get typeGrass => 'Grass';

  @override
  String get typeElectric => 'Electric';

  @override
  String get typeIce => 'Ice';

  @override
  String get typeFighting => 'Fighting';

  @override
  String get typePoison => 'Poison';

  @override
  String get typeGround => 'Ground';

  @override
  String get typeFlying => 'Flying';

  @override
  String get typePsychic => 'Psychic';

  @override
  String get typeBug => 'Bug';

  @override
  String get typeRock => 'Rock';

  @override
  String get typeGhost => 'Ghost';

  @override
  String get typeDragon => 'Dragon';

  @override
  String get typeDark => 'Dark';

  @override
  String get typeSteel => 'Steel';

  @override
  String get typeFairy => 'Fairy';

  @override
  String get evolutionChain => 'Evolution Chain';

  @override
  String get type => 'Type';

  @override
  String get physicalStats => 'Physical Stats';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get baseStats => 'Base Stats';

  @override
  String get abilities => 'Abilities';

  @override
  String guessQuestion(String pokemonName) {
    return 'Is it $pokemonName?';
  }
}
