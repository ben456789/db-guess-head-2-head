import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('pt'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Head 2 Head Guessing Game'**
  String get appTitle;

  /// Main game description
  ///
  /// In en, this message translates to:
  /// **'Guess which Poké character your opponent has chosen before they guess yours!'**
  String get gameDescription;

  /// Button to create a new game
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame;

  /// Button to join an existing game
  ///
  /// In en, this message translates to:
  /// **'Join Game'**
  String get joinGame;

  /// Settings button label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// How to play button label
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// Legal and terms button label
  ///
  /// In en, this message translates to:
  /// **'Legal & Terms'**
  String get legalTerms;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Your name input label
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// Label for generation selection
  ///
  /// In en, this message translates to:
  /// **'Select Generations for the game'**
  String get selectGenerations;

  /// Label for character count selection
  ///
  /// In en, this message translates to:
  /// **'Number of Characters'**
  String get numberOfCharacters;

  /// Creating game progress text
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get generating;

  /// Button to generate game code
  ///
  /// In en, this message translates to:
  /// **'Generate Code & QR'**
  String get generateCodeQR;

  /// Waiting for player message
  ///
  /// In en, this message translates to:
  /// **'Waiting for another player to scan QR or enter code...'**
  String get waitingForPlayer;

  /// Game code label
  ///
  /// In en, this message translates to:
  /// **'Game Code'**
  String get gameCodeLabel;

  /// QR code instruction
  ///
  /// In en, this message translates to:
  /// **'Or scan this QR code'**
  String get orScanQR;

  /// Go to lobby button
  ///
  /// In en, this message translates to:
  /// **'Go to Lobby'**
  String get goToLobby;

  /// Error message for empty name
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get pleaseEnterName;

  /// Error message for no generation selected
  ///
  /// In en, this message translates to:
  /// **'Please select at least one generation.'**
  String get pleaseSelectGeneration;

  /// Error message for game creation failure
  ///
  /// In en, this message translates to:
  /// **'Failed to create game'**
  String get failedToCreateGame;

  /// Instruction for joining game
  ///
  /// In en, this message translates to:
  /// **'Enter your name and the 6-digit code.'**
  String get enterNameAndCode;

  /// Game code input hint
  ///
  /// In en, this message translates to:
  /// **'e.g. ABC123'**
  String get gameCodeHint;

  /// Error message for join failure
  ///
  /// In en, this message translates to:
  /// **'Failed to join'**
  String get failedToJoin;

  /// Error message for sign in failure
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in'**
  String get failedToSignIn;

  /// Leave game dialog title
  ///
  /// In en, this message translates to:
  /// **'Leave Game?'**
  String get leaveGame;

  /// Leave button
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Select character screen title
  ///
  /// In en, this message translates to:
  /// **'Select Character'**
  String get selectCharacter;

  /// Opponent ready message
  ///
  /// In en, this message translates to:
  /// **'Your opponent is ready!'**
  String get opponentReady;

  /// Dismiss button
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Game over screen title
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Question sent confirmation
  ///
  /// In en, this message translates to:
  /// **'✅ Question sent!'**
  String get questionSent;

  /// Answer sent confirmation
  ///
  /// In en, this message translates to:
  /// **'✅ Answer sent!'**
  String get answerSent;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'❌ Error'**
  String get error;

  /// Sending answer message
  ///
  /// In en, this message translates to:
  /// **'📤 Sending answer'**
  String get sendingAnswer;

  /// Opponent left notification
  ///
  /// In en, this message translates to:
  /// **'Your opponent left the game'**
  String get opponentLeft;

  /// Game screen title
  ///
  /// In en, this message translates to:
  /// **'Guess the character!'**
  String get guessTheCharacter;

  /// Ask question input hint
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get askQuestion;

  /// No character available message
  ///
  /// In en, this message translates to:
  /// **'No available Character to guess'**
  String get noCharacterToGuess;

  /// Guess button
  ///
  /// In en, this message translates to:
  /// **'Guess'**
  String get guess;

  /// Round result title
  ///
  /// In en, this message translates to:
  /// **'Round Result'**
  String get roundResult;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Vibration setting label
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Yes answer
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No answer
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Don't know answer
  ///
  /// In en, this message translates to:
  /// **'I don\'t know'**
  String get iDontKnow;

  /// Kanto region name
  ///
  /// In en, this message translates to:
  /// **'Kanto'**
  String get kanto;

  /// Johto region name
  ///
  /// In en, this message translates to:
  /// **'Johto'**
  String get johto;

  /// Hoenn region name
  ///
  /// In en, this message translates to:
  /// **'Hoenn'**
  String get hoenn;

  /// Sinnoh region name
  ///
  /// In en, this message translates to:
  /// **'Sinnoh'**
  String get sinnoh;

  /// Unova region name
  ///
  /// In en, this message translates to:
  /// **'Unova'**
  String get unova;

  /// Kalos region name
  ///
  /// In en, this message translates to:
  /// **'Kalos'**
  String get kalos;

  /// Alola region name
  ///
  /// In en, this message translates to:
  /// **'Alola'**
  String get alola;

  /// Galar region name
  ///
  /// In en, this message translates to:
  /// **'Galar'**
  String get galar;

  /// Paldea region name
  ///
  /// In en, this message translates to:
  /// **'Paldea'**
  String get paldea;

  /// EULA menu item
  ///
  /// In en, this message translates to:
  /// **'End User License Agreement (EULA)'**
  String get eula;

  /// EULA dialog title
  ///
  /// In en, this message translates to:
  /// **'EULA'**
  String get eulaTitle;

  /// EULA content text
  ///
  /// In en, this message translates to:
  /// **'This app is provided under the MIT License. By using this app, you agree to abide by the terms and conditions set forth in the license and any applicable app store requirements.'**
  String get eulaContent;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service content text
  ///
  /// In en, this message translates to:
  /// **'By using this app, you agree to use it for entertainment purposes only and not for any unlawful activity. See the MIT License for more details.'**
  String get termsOfServiceContent;

  /// Trademark notice shown at bottom of legal screen
  ///
  /// In en, this message translates to:
  /// **'Pokémon and Pokémon character names are trademarks of Nintendo.'**
  String get pokemonTrademarkNotice;

  /// How to play: Creating game title
  ///
  /// In en, this message translates to:
  /// **'Creating a game'**
  String get creatingGame;

  /// How to play: Creating game description
  ///
  /// In en, this message translates to:
  /// **'1. Create the game by pressing the \"Create Game\" button\n2. Enter your name and select which generations and how many characters you want to include in the match\n3. Generate a game code or QR code to share with your opponent\n4. Share with your opponent for them to join'**
  String get creatingGameDesc;

  /// How to play: Joining game title
  ///
  /// In en, this message translates to:
  /// **'Joining a game'**
  String get joiningGame;

  /// How to play: Joining game description
  ///
  /// In en, this message translates to:
  /// **'1. Join a game by pressing the \"Join Game\" button\n2. Enter your name and the game code or scan the QR code\n3. Choose your character'**
  String get joiningGameDesc;

  /// How to play: Playing game title
  ///
  /// In en, this message translates to:
  /// **'Playing the game'**
  String get playingGame;

  /// How to play: Playing game description
  ///
  /// In en, this message translates to:
  /// **'1. A coin flip is decided as to who goes first\n2. Take turns asking yes/no questions using the chat interface\n3. Eliminate characters based on the answers\n4. Guess which character your opponent has chosen before they guess yours!'**
  String get playingGameDesc;

  /// Privacy policy page title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// Privacy policy introduction
  ///
  /// In en, this message translates to:
  /// **'This app uses Firebase services to provide multiplayer features and store game data. We may collect basic information such as usernames, game progress, and device information for the purpose of gameplay and improving the app. No personal information is sold or shared with third parties except as required by Firebase or by law.'**
  String get privacyPolicyIntro;

  /// Data collected section title
  ///
  /// In en, this message translates to:
  /// **'Data Collected:'**
  String get dataCollected;

  /// Data collected list
  ///
  /// In en, this message translates to:
  /// **'- Usernames and game codes\n- Game progress and scores\n- Device information (for analytics/debugging)'**
  String get dataCollectedList;

  /// How we use data section title
  ///
  /// In en, this message translates to:
  /// **'How We Use Data:'**
  String get howWeUseData;

  /// How we use data list
  ///
  /// In en, this message translates to:
  /// **'- To enable multiplayer gameplay\n- To save your progress\n- To improve app performance and stability'**
  String get howWeUseDataList;

  /// Third party services section title
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services:'**
  String get thirdPartyServices;

  /// Third party services description
  ///
  /// In en, this message translates to:
  /// **'We use Google Firebase for authentication, database, and analytics. Please refer to Firebase\'s privacy policy for more details.'**
  String get thirdPartyServicesDesc;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact:'**
  String get contact;

  /// Contact description
  ///
  /// In en, this message translates to:
  /// **'If you have questions about privacy, contact the developer.'**
  String get contactDesc;

  /// Copy code button
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// Code copied confirmation
  ///
  /// In en, this message translates to:
  /// **'Game code copied to clipboard!'**
  String get codeCopied;

  /// Game not found error
  ///
  /// In en, this message translates to:
  /// **'Game not found. Please check the code.'**
  String get gameNotFound;

  /// Scan QR code button
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// Joining game progress text
  ///
  /// In en, this message translates to:
  /// **'Joining...'**
  String get joining;

  /// Short for Generation (Pokemon generation)
  ///
  /// In en, this message translates to:
  /// **'Gen'**
  String get gen;

  /// Create game page title
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGameTitle;

  /// Create game heading
  ///
  /// In en, this message translates to:
  /// **'Create game'**
  String get createGameHeading;

  /// Create game description
  ///
  /// In en, this message translates to:
  /// **'Enter your name to generate a 6-digit code and QR for your friend to join.'**
  String get createGameDescription;

  /// Waiting for friend message
  ///
  /// In en, this message translates to:
  /// **'Waiting for friend to join...'**
  String get waitingForFriend;

  /// Friend can scan QR message
  ///
  /// In en, this message translates to:
  /// **'Friend can scan this QR or enter the code to join.'**
  String get friendCanScanQR;

  /// Score label on game over screen
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Join game screen heading
  ///
  /// In en, this message translates to:
  /// **'Join a friend'**
  String get joinAFriend;

  /// Join game screen description
  ///
  /// In en, this message translates to:
  /// **'Enter your name and the 6-digit code, or scan their QR.'**
  String get enterNameAndCodeOrScan;

  /// Game code input label
  ///
  /// In en, this message translates to:
  /// **'Game code'**
  String get gameCode;

  /// Game code hint text
  ///
  /// In en, this message translates to:
  /// **'e.g. ABC123'**
  String get gameCodeExample;

  /// QR scanning web error message
  ///
  /// In en, this message translates to:
  /// **'QR scanning is not available on web. Please enter the code manually.'**
  String get qrScanningNotAvailableWeb;

  /// Game not found error message
  ///
  /// In en, this message translates to:
  /// **'Game not found. Please check the code.'**
  String get gameNotFoundCheckCode;

  /// Failed to join with error message
  ///
  /// In en, this message translates to:
  /// **'Failed to join: {error}'**
  String failedToJoinError(Object error);

  /// Leave game confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave? The game will be terminated.'**
  String get leaveGameConfirmation;

  /// Playing against message
  ///
  /// In en, this message translates to:
  /// **'Playing against: {opponentName}'**
  String playingAgainst(String opponentName);

  /// Generations in game label
  ///
  /// In en, this message translates to:
  /// **'Generations in this game:'**
  String get generationsInGame;

  /// Your character label
  ///
  /// In en, this message translates to:
  /// **'Your Character'**
  String get yourCharacter;

  /// Chat button label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Your turn to answer status
  ///
  /// In en, this message translates to:
  /// **'Your turn to answer'**
  String get yourTurnToAnswer;

  /// Your turn to ask status
  ///
  /// In en, this message translates to:
  /// **'Your turn to ask'**
  String get yourTurnToAsk;

  /// Waiting for answer status
  ///
  /// In en, this message translates to:
  /// **'Waiting for answer'**
  String get waitingForAnswer;

  /// Waiting for question status
  ///
  /// In en, this message translates to:
  /// **'Waiting for question'**
  String get waitingForQuestion;

  /// Hide eliminated checkbox label
  ///
  /// In en, this message translates to:
  /// **'Hide Eliminated'**
  String get hideEliminated;

  /// Characters remaining message
  ///
  /// In en, this message translates to:
  /// **'{opponentName} has {count} characters remaining'**
  String charactersRemaining(String opponentName, int count);

  /// No available character error
  ///
  /// In en, this message translates to:
  /// **'No available Character to guess'**
  String get noAvailableCharacter;

  /// Make a guess title
  ///
  /// In en, this message translates to:
  /// **'Make a Guess!'**
  String get makeAGuess;

  /// Confirm guess message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to guess {pokemonName}?'**
  String confirmGuess(String pokemonName);

  /// No messages empty state
  ///
  /// In en, this message translates to:
  /// **'No messages yet...'**
  String get noMessagesYet;

  /// Eliminate characters reminder
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to eliminate characters! They can be found at the end of the list (Unless Hidden).'**
  String get eliminateReminder;

  /// Opponent typing indicator
  ///
  /// In en, this message translates to:
  /// **'Opponent is typing...'**
  String get opponentTyping;

  /// Send question button
  ///
  /// In en, this message translates to:
  /// **'Send Question'**
  String get sendQuestion;

  /// Guess character button
  ///
  /// In en, this message translates to:
  /// **'Guess Character'**
  String get guessCharacter;

  /// Waiting for answer with ellipsis
  ///
  /// In en, this message translates to:
  /// **'Waiting for answer...'**
  String get waitingForAnswerEllipsis;

  /// Waiting for question with ellipsis
  ///
  /// In en, this message translates to:
  /// **'Waiting for question...'**
  String get waitingForQuestionEllipsis;

  /// Don't know answer
  ///
  /// In en, this message translates to:
  /// **'Don\'t know'**
  String get dontKnow;

  /// You go first message
  ///
  /// In en, this message translates to:
  /// **'You go first!'**
  String get youGoFirst;

  /// Player goes first message
  ///
  /// In en, this message translates to:
  /// **'{playerName} goes first!'**
  String playerGoesFirst(String playerName);

  /// Correct result
  ///
  /// In en, this message translates to:
  /// **'CORRECT!'**
  String get correct;

  /// Time's up result
  ///
  /// In en, this message translates to:
  /// **'TIME\'S UP!'**
  String get timesUp;

  /// Incorrect result
  ///
  /// In en, this message translates to:
  /// **'INCORRECT!'**
  String get incorrect;

  /// Next round starting message
  ///
  /// In en, this message translates to:
  /// **'Next round starting...'**
  String get nextRoundStarting;

  /// Starting new round loading message
  ///
  /// In en, this message translates to:
  /// **'Starting new round...'**
  String get startingNewRound;

  /// You win message
  ///
  /// In en, this message translates to:
  /// **'🎉 YOU WIN! 🎉'**
  String get youWin;

  /// Success message for guessing correctly
  ///
  /// In en, this message translates to:
  /// **'You successfully guessed your opponent\'s Character!'**
  String get youSuccessfullyGuessed;

  /// Opponent wins message
  ///
  /// In en, this message translates to:
  /// **'{opponentName} wins'**
  String opponentWins(String opponentName);

  /// Message when opponent guesses correctly
  ///
  /// In en, this message translates to:
  /// **'{opponentName} guessed your Character correctly!'**
  String opponentGuessedCorrectly(String opponentName);

  /// Characters selected label
  ///
  /// In en, this message translates to:
  /// **'Characters Selected:'**
  String get charactersSelected;

  /// Player wants to play again message
  ///
  /// In en, this message translates to:
  /// **'{playerName} wants to play again!'**
  String wantsToPlayAgain(String playerName);

  /// Waiting for opponent to play again message
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent to play again...'**
  String get waitingForOpponentToPlayAgain;

  /// Waiting for opponent with ellipsis
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent...'**
  String get waitingForOpponentEllipsis;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// Normal type
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get typeNormal;

  /// Fire type
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get typeFire;

  /// Water type
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get typeWater;

  /// Grass type
  ///
  /// In en, this message translates to:
  /// **'Grass'**
  String get typeGrass;

  /// Electric type
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get typeElectric;

  /// Ice type
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get typeIce;

  /// Fighting type
  ///
  /// In en, this message translates to:
  /// **'Fighting'**
  String get typeFighting;

  /// Poison type
  ///
  /// In en, this message translates to:
  /// **'Poison'**
  String get typePoison;

  /// Ground type
  ///
  /// In en, this message translates to:
  /// **'Ground'**
  String get typeGround;

  /// Flying type
  ///
  /// In en, this message translates to:
  /// **'Flying'**
  String get typeFlying;

  /// Psychic type
  ///
  /// In en, this message translates to:
  /// **'Psychic'**
  String get typePsychic;

  /// Bug type
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get typeBug;

  /// Rock type
  ///
  /// In en, this message translates to:
  /// **'Rock'**
  String get typeRock;

  /// Ghost type
  ///
  /// In en, this message translates to:
  /// **'Ghost'**
  String get typeGhost;

  /// Dragon type
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get typeDragon;

  /// Dark type
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get typeDark;

  /// Steel type
  ///
  /// In en, this message translates to:
  /// **'Steel'**
  String get typeSteel;

  /// Fairy type
  ///
  /// In en, this message translates to:
  /// **'Fairy'**
  String get typeFairy;

  /// Label for Pokemon evolution chain section
  ///
  /// In en, this message translates to:
  /// **'Evolution Chain'**
  String get evolutionChain;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Physical stats label
  ///
  /// In en, this message translates to:
  /// **'Physical Stats'**
  String get physicalStats;

  /// Height label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Weight label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Base stats label
  ///
  /// In en, this message translates to:
  /// **'Base Stats'**
  String get baseStats;

  /// Abilities label
  ///
  /// In en, this message translates to:
  /// **'Abilities'**
  String get abilities;

  /// Question format when making a guess
  ///
  /// In en, this message translates to:
  /// **'Is it {pokemonName}?'**
  String guessQuestion(String pokemonName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'ja',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
