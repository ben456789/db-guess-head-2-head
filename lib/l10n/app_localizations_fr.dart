// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Jeu de Devinettes Head 2 Head';

  @override
  String get gameDescription =>
      'Devinez quel personnage Poké votre adversaire a choisi avant qu\'il ne devine le vôtre !';

  @override
  String get createGame => 'Créer une Partie';

  @override
  String get joinGame => 'Rejoindre une Partie';

  @override
  String get settings => 'Paramètres';

  @override
  String get howToPlay => 'Comment Jouer';

  @override
  String get legalTerms => 'Mentions Légales';

  @override
  String get close => 'Fermer';

  @override
  String get yourName => 'Votre nom';

  @override
  String get selectGenerations => 'Sélectionnez les Générations pour le jeu';

  @override
  String get numberOfCharacters => 'Nombre de Personnages';

  @override
  String get generating => 'Création...';

  @override
  String get generateCodeQR => 'Générer le Code et QR';

  @override
  String get waitingForPlayer =>
      'En attente qu\'un autre joueur scanne le QR ou entre le code...';

  @override
  String get gameCodeLabel => 'Code de Jeu';

  @override
  String get orScanQR => 'Ou scannez ce code QR';

  @override
  String get goToLobby => 'Aller au Lobby';

  @override
  String get pleaseEnterName => 'Veuillez entrer votre nom.';

  @override
  String get pleaseSelectGeneration =>
      'Veuillez sélectionner au moins une génération.';

  @override
  String get failedToCreateGame => 'Échec de la création du jeu';

  @override
  String get enterNameAndCode => 'Entrez votre nom et le code à 6 chiffres.';

  @override
  String get gameCodeHint => 'ex. ABC123';

  @override
  String get failedToJoin => 'Échec de la connexion';

  @override
  String get failedToSignIn => 'Échec de la connexion';

  @override
  String get leaveGame => 'Quitter le Jeu?';

  @override
  String get leave => 'Quitter';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get selectCharacter => 'Sélectionner le Personnage';

  @override
  String get opponentReady => 'Votre adversaire est prêt!';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get gameOver => 'Fin de Partie';

  @override
  String get questionSent => '✅ Question envoyée !';

  @override
  String get answerSent => '✅ Réponse envoyée !';

  @override
  String get error => '❌ Erreur';

  @override
  String get sendingAnswer => '📤 Envoi de la réponse';

  @override
  String get opponentLeft => 'Votre adversaire a quitté le jeu';

  @override
  String get guessTheCharacter => 'Devinez le personnage!';

  @override
  String get askQuestion => 'Posez une question...';

  @override
  String get noCharacterToGuess => 'Aucun personnage disponible à deviner';

  @override
  String get guess => 'Deviner';

  @override
  String get roundResult => 'Résultat du Tour';

  @override
  String get language => 'Langue';

  @override
  String get vibration => 'Vibration';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get iDontKnow => 'Je ne sais pas';

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
  String get eula => 'Contrat de Licence Utilisateur Final (CLUF)';

  @override
  String get eulaTitle => 'CLUF';

  @override
  String get eulaContent =>
      'Cette application est fournie sous la Licence MIT. En utilisant cette application, vous acceptez de respecter les termes et conditions énoncés dans la licence et toutes les exigences applicables des magasins d\'applications.';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get termsOfServiceContent =>
      'En utilisant cette application, vous acceptez de l\'utiliser à des fins de divertissement uniquement et non pour toute activité illégale. Voir la Licence MIT pour plus de détails.';

  @override
  String get pokemonTrademarkNotice =>
      'Pokémon et les noms des personnages Pokémon sont des marques déposées de Nintendo.';

  @override
  String get creatingGame => 'Création d\'une partie';

  @override
  String get creatingGameDesc =>
      '1. Créez le jeu en appuyant sur le bouton \"Créer une Partie\"\n2. Entrez votre nom et sélectionnez quelles générations et combien de personnages vous voulez inclure dans le match\n3. Générez un code de jeu ou un code QR à partager avec votre adversaire\n4. Partagez avec votre adversaire pour qu\'il rejoigne';

  @override
  String get joiningGame => 'Rejoindre une partie';

  @override
  String get joiningGameDesc =>
      '1. Rejoignez un jeu en appuyant sur le bouton \"Rejoindre une Partie\"\n2. Entrez votre nom et le code du jeu ou scannez le code QR\n3. Choisissez votre personnage';

  @override
  String get playingGame => 'Jouer au jeu';

  @override
  String get playingGameDesc =>
      '1. Un lancer de pièce décide qui commence\n2. Posez des questions oui/non à tour de rôle en utilisant l\'interface de chat\n3. Éliminez les personnages en fonction des réponses\n4. Devinez quel personnage votre adversaire a choisi avant qu\'il ne devine le vôtre !';

  @override
  String get privacyPolicyTitle => 'Politique de Confidentialité';

  @override
  String get privacyPolicyIntro =>
      'Cette application utilise les services Firebase pour fournir des fonctionnalités multijoueurs et stocker les données de jeu. Nous pouvons collecter des informations de base telles que les noms d\'utilisateur, la progression du jeu et les informations sur l\'appareil dans le but du jeu et d\'améliorer l\'application. Aucune information personnelle n\'est vendue ou partagée avec des tiers sauf selon les exigences de Firebase ou de la loi.';

  @override
  String get dataCollected => 'Données Collectées :';

  @override
  String get dataCollectedList =>
      '- Noms d\'utilisateur et codes de jeu\n- Progression et scores du jeu\n- Informations sur l\'appareil (pour l\'analyse/débogage)';

  @override
  String get howWeUseData => 'Comment Nous Utilisons les Données :';

  @override
  String get howWeUseDataList =>
      '- Pour activer le jeu multijoueur\n- Pour enregistrer votre progression\n- Pour améliorer les performances et la stabilité de l\'application';

  @override
  String get thirdPartyServices => 'Services Tiers :';

  @override
  String get thirdPartyServicesDesc =>
      'Nous utilisons Google Firebase pour l\'authentification, la base de données et l\'analyse. Veuillez consulter la politique de confidentialité de Firebase pour plus de détails.';

  @override
  String get contact => 'Contact :';

  @override
  String get contactDesc =>
      'Si vous avez des questions sur la confidentialité, contactez le développeur.';

  @override
  String get copyCode => 'Copier le Code';

  @override
  String get codeCopied => 'Code de jeu copié dans le presse-papiers !';

  @override
  String get gameNotFound => 'Jeu introuvable. Veuillez vérifier le code.';

  @override
  String get scanQRCode => 'Scanner le Code QR';

  @override
  String get joining => 'Connexion...';

  @override
  String get gen => 'Gén';

  @override
  String get createGameTitle => 'Créer une Partie';

  @override
  String get createGameHeading => 'Créer une partie';

  @override
  String get createGameDescription =>
      'Entrez votre nom pour générer un code à 6 chiffres et un QR pour que votre ami puisse rejoindre.';

  @override
  String get waitingForFriend => 'En attente de votre ami...';

  @override
  String get friendCanScanQR =>
      'Votre ami peut scanner ce QR ou entrer le code pour rejoindre.';

  @override
  String get score => 'Score';

  @override
  String get joinAFriend => 'Rejoindre un ami';

  @override
  String get enterNameAndCodeOrScan =>
      'Entrez votre nom et le code à 6 chiffres, ou scannez leur QR.';

  @override
  String get gameCode => 'Code du jeu';

  @override
  String get gameCodeExample => 'ex. ABC123';

  @override
  String get qrScanningNotAvailableWeb =>
      'Le scan QR n\'est pas disponible sur le web. Veuillez entrer le code manuellement.';

  @override
  String get gameNotFoundCheckCode =>
      'Jeu introuvable. Veuillez vérifier le code.';

  @override
  String failedToJoinError(Object error) {
    return 'Échec de rejoindre: $error';
  }

  @override
  String get leaveGameConfirmation =>
      'Êtes-vous sûr de vouloir partir? La partie sera terminée.';

  @override
  String playingAgainst(String opponentName) {
    return 'Jouer contre: $opponentName';
  }

  @override
  String get generationsInGame => 'Générations dans ce jeu:';

  @override
  String get yourCharacter => 'Votre Personnage';

  @override
  String get chat => 'Chat';

  @override
  String get yourTurnToAnswer => 'Votre tour de répondre';

  @override
  String get yourTurnToAsk => 'Votre tour de demander';

  @override
  String get waitingForAnswer => 'En attente de réponse';

  @override
  String get waitingForQuestion => 'En attente de question';

  @override
  String get hideEliminated => 'Masquer Éliminés';

  @override
  String charactersRemaining(String opponentName, int count) {
    return '$opponentName a $count personnages restants';
  }

  @override
  String get noAvailableCharacter => 'Aucun personnage disponible à deviner';

  @override
  String get makeAGuess => 'Faites une Supposition!';

  @override
  String confirmGuess(String pokemonName) {
    return 'Êtes-vous sûr de vouloir deviner $pokemonName?';
  }

  @override
  String get noMessagesYet => 'Pas encore de messages...';

  @override
  String get eliminateReminder =>
      'N\'oubliez pas d\'éliminer les personnages! Ils se trouvent à la fin de la liste (Sauf si masqués).';

  @override
  String get opponentTyping => 'L\'adversaire écrit...';

  @override
  String get sendQuestion => 'Envoyer la Question';

  @override
  String get guessCharacter => 'Deviner le Personnage';

  @override
  String get waitingForAnswerEllipsis => 'En attente de réponse...';

  @override
  String get waitingForQuestionEllipsis => 'En attente de question...';

  @override
  String get dontKnow => 'Je ne sais pas';

  @override
  String get youGoFirst => 'Vous commencez!';

  @override
  String playerGoesFirst(String playerName) {
    return '$playerName commence!';
  }

  @override
  String get correct => 'CORRECT!';

  @override
  String get timesUp => 'TEMPS ÉCOULÉ!';

  @override
  String get incorrect => 'INCORRECT!';

  @override
  String get nextRoundStarting => 'Prochain tour commence...';

  @override
  String get startingNewRound => 'Démarrage d\'un nouveau tour...';

  @override
  String get youWin => '🎉 VOUS GAGNEZ! 🎉';

  @override
  String get youSuccessfullyGuessed =>
      'Vous avez deviné le Personnage de votre adversaire avec succès!';

  @override
  String opponentWins(String opponentName) {
    return '$opponentName gagne';
  }

  @override
  String opponentGuessedCorrectly(String opponentName) {
    return '$opponentName a deviné votre Personnage correctement!';
  }

  @override
  String get charactersSelected => 'Personnages Sélectionnés:';

  @override
  String wantsToPlayAgain(String playerName) {
    return '$playerName veut rejouer!';
  }

  @override
  String get waitingForOpponentToPlayAgain =>
      'En attente que l\'adversaire rejoue...';

  @override
  String get waitingForOpponentEllipsis => 'En attente de l\'adversaire...';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Feu';

  @override
  String get typeWater => 'Eau';

  @override
  String get typeGrass => 'Plante';

  @override
  String get typeElectric => 'Électrik';

  @override
  String get typeIce => 'Glace';

  @override
  String get typeFighting => 'Combat';

  @override
  String get typePoison => 'Poison';

  @override
  String get typeGround => 'Sol';

  @override
  String get typeFlying => 'Vol';

  @override
  String get typePsychic => 'Psy';

  @override
  String get typeBug => 'Insecte';

  @override
  String get typeRock => 'Roche';

  @override
  String get typeGhost => 'Spectre';

  @override
  String get typeDragon => 'Dragon';

  @override
  String get typeDark => 'Ténèbres';

  @override
  String get typeSteel => 'Acier';

  @override
  String get typeFairy => 'Fée';

  @override
  String get evolutionChain => 'Chaîne d\'Évolution';

  @override
  String get type => 'Type';

  @override
  String get physicalStats => 'Statistiques Physiques';

  @override
  String get height => 'Taille';

  @override
  String get weight => 'Poids';

  @override
  String get baseStats => 'Statistiques de Base';

  @override
  String get abilities => 'Capacités';

  @override
  String guessQuestion(String pokemonName) {
    return 'Est-ce $pokemonName ?';
  }
}
