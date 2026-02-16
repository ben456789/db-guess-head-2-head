// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Juego de Adivinanzas Head 2 Head';

  @override
  String get gameDescription =>
      '¡Adivina qué personaje Poké ha elegido tu oponente antes de que adivine el tuyo!';

  @override
  String get createGame => 'Crear Juego';

  @override
  String get joinGame => 'Unirse al Juego';

  @override
  String get settings => 'Configuración';

  @override
  String get howToPlay => 'Cómo Jugar';

  @override
  String get legalTerms => 'Legal y Términos';

  @override
  String get close => 'Cerrar';

  @override
  String get yourName => 'Tu nombre';

  @override
  String get selectGenerations => 'Selecciona Generaciones para el juego';

  @override
  String get numberOfCharacters => 'Número de Personajes';

  @override
  String get generating => 'Creando...';

  @override
  String get generateCodeQR => 'Generar Código y QR';

  @override
  String get waitingForPlayer =>
      'Esperando a que otro jugador escanee el QR o ingrese el código...';

  @override
  String get gameCodeLabel => 'Código del Juego';

  @override
  String get orScanQR => 'O escanea este código QR';

  @override
  String get goToLobby => 'Ir al Lobby';

  @override
  String get pleaseEnterName => 'Por favor ingresa tu nombre.';

  @override
  String get pleaseSelectGeneration =>
      'Por favor selecciona al menos una generación.';

  @override
  String get failedToCreateGame => 'Error al crear el juego';

  @override
  String get enterNameAndCode => 'Ingresa tu nombre y el código de 6 dígitos.';

  @override
  String get gameCodeHint => 'ej. ABC123';

  @override
  String get failedToJoin => 'Error al unirse';

  @override
  String get failedToSignIn => 'Error al iniciar sesión';

  @override
  String get leaveGame => '¿Salir del Juego?';

  @override
  String get leave => 'Salir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectCharacter => 'Seleccionar Personaje';

  @override
  String get opponentReady => '¡Tu oponente está listo!';

  @override
  String get dismiss => 'Descartar';

  @override
  String get gameOver => 'Fin del Juego';

  @override
  String get questionSent => '✅ ¡Pregunta enviada!';

  @override
  String get answerSent => '✅ ¡Respuesta enviada!';

  @override
  String get error => '❌ Error';

  @override
  String get sendingAnswer => '📤 Enviando respuesta';

  @override
  String get opponentLeft => 'Tu oponente abandonó el juego';

  @override
  String get guessTheCharacter => '¡Adivina el personaje!';

  @override
  String get askQuestion => 'Haz una pregunta...';

  @override
  String get noCharacterToGuess => 'No hay personaje disponible para adivinar';

  @override
  String get guess => 'Adivinar';

  @override
  String get roundResult => 'Resultado de la Ronda';

  @override
  String get language => 'Idioma';

  @override
  String get vibration => 'Vibración';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get iDontKnow => 'No sé';

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
  String get eula => 'Acuerdo de Licencia de Usuario Final (EULA)';

  @override
  String get eulaTitle => 'EULA';

  @override
  String get eulaContent =>
      'Esta aplicación se proporciona bajo la Licencia MIT. Al usar esta aplicación, acepta cumplir con los términos y condiciones establecidos en la licencia y cualquier requisito aplicable de la tienda de aplicaciones.';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get termsOfServiceContent =>
      'Al usar esta aplicación, acepta usarla solo con fines de entretenimiento y no para ninguna actividad ilegal. Consulte la Licencia MIT para más detalles.';

  @override
  String get pokemonTrademarkNotice =>
      'Pokémon y los nombres de los personajes de Pokémon son marcas comerciales de Nintendo.';

  @override
  String get creatingGame => 'Creando un juego';

  @override
  String get creatingGameDesc =>
      '1. Crea el juego presionando el botón \"Crear Juego\"\n2. Ingresa tu nombre y selecciona qué generaciones y cuántos personajes quieres incluir en la partida\n3. Genera un código de juego o código QR para compartir con tu oponente\n4. Comparte con tu oponente para que se una';

  @override
  String get joiningGame => 'Uniéndose a un juego';

  @override
  String get joiningGameDesc =>
      '1. Únete a un juego presionando el botón \"Unirse al Juego\"\n2. Ingresa tu nombre y el código del juego o escanea el código QR\n3. Elige tu personaje';

  @override
  String get playingGame => 'Jugando el juego';

  @override
  String get playingGameDesc =>
      '1. Se decide con un lanzamiento de moneda quién va primero\n2. Túrnense para hacer preguntas de sí/no usando la interfaz de chat\n3. Elimina personajes según las respuestas\n4. ¡Adivina qué personaje eligió tu oponente antes de que adivine el tuyo!';

  @override
  String get privacyPolicyTitle => 'Política de Privacidad';

  @override
  String get privacyPolicyIntro =>
      'Esta aplicación utiliza servicios de Firebase para proporcionar funciones multijugador y almacenar datos del juego. Podemos recopilar información básica como nombres de usuario, progreso del juego e información del dispositivo con el propósito del juego y mejorar la aplicación. No se vende ni comparte información personal con terceros excepto según lo requiera Firebase o la ley.';

  @override
  String get dataCollected => 'Datos Recopilados:';

  @override
  String get dataCollectedList =>
      '- Nombres de usuario y códigos de juego\n- Progreso y puntuaciones del juego\n- Información del dispositivo (para análisis/depuración)';

  @override
  String get howWeUseData => 'Cómo Usamos los Datos:';

  @override
  String get howWeUseDataList =>
      '- Para habilitar el juego multijugador\n- Para guardar tu progreso\n- Para mejorar el rendimiento y estabilidad de la aplicación';

  @override
  String get thirdPartyServices => 'Servicios de Terceros:';

  @override
  String get thirdPartyServicesDesc =>
      'Usamos Google Firebase para autenticación, base de datos y análisis. Consulte la política de privacidad de Firebase para más detalles.';

  @override
  String get contact => 'Contacto:';

  @override
  String get contactDesc =>
      'Si tiene preguntas sobre privacidad, contacte al desarrollador.';

  @override
  String get copyCode => 'Copiar Código';

  @override
  String get codeCopied => '¡Código del juego copiado al portapapeles!';

  @override
  String get gameNotFound =>
      'Juego no encontrado. Por favor verifica el código.';

  @override
  String get scanQRCode => 'Escanear Código QR';

  @override
  String get joining => 'Uniéndose...';

  @override
  String get gen => 'Gen';

  @override
  String get createGameTitle => 'Crear Juego';

  @override
  String get createGameHeading => 'Crear juego';

  @override
  String get createGameDescription =>
      'Ingresa tu nombre para generar un código de 6 dígitos y un QR para que tu amigo se una.';

  @override
  String get waitingForFriend => 'Esperando a que tu amigo se una...';

  @override
  String get friendCanScanQR =>
      'Tu amigo puede escanear este QR o ingresar el código para unirse.';

  @override
  String get score => 'Puntuación';

  @override
  String get joinAFriend => 'Unirse a un amigo';

  @override
  String get enterNameAndCodeOrScan =>
      'Ingresa tu nombre y el código de 6 dígitos, o escanea su QR.';

  @override
  String get gameCode => 'Código del juego';

  @override
  String get gameCodeExample => 'ej. ABC123';

  @override
  String get qrScanningNotAvailableWeb =>
      'El escaneo QR no está disponible en web. Por favor, ingresa el código manualmente.';

  @override
  String get gameNotFoundCheckCode =>
      'Juego no encontrado. Por favor, verifica el código.';

  @override
  String failedToJoinError(Object error) {
    return 'Error al unirse: $error';
  }

  @override
  String get leaveGameConfirmation =>
      '¿Estás seguro de que quieres salir? El juego será terminado.';

  @override
  String playingAgainst(String opponentName) {
    return 'Jugando contra: $opponentName';
  }

  @override
  String get generationsInGame => 'Generaciones en este juego:';

  @override
  String get yourCharacter => 'Tu Personaje';

  @override
  String get chat => 'Chat';

  @override
  String get yourTurnToAnswer => 'Tu turno de responder';

  @override
  String get yourTurnToAsk => 'Tu turno de preguntar';

  @override
  String get waitingForAnswer => 'Esperando respuesta';

  @override
  String get waitingForQuestion => 'Esperando pregunta';

  @override
  String get hideEliminated => 'Ocultar Eliminados';

  @override
  String charactersRemaining(String opponentName, int count) {
    return '$opponentName tiene $count personajes restantes';
  }

  @override
  String get noAvailableCharacter =>
      'No hay personajes disponibles para adivinar';

  @override
  String get makeAGuess => '¡Haz una Suposición!';

  @override
  String confirmGuess(String pokemonName) {
    return '¿Estás seguro de que quieres adivinar $pokemonName?';
  }

  @override
  String get noMessagesYet => 'Aún no hay mensajes...';

  @override
  String get eliminateReminder =>
      '¡No olvides eliminar personajes! Se encuentran al final de la lista (A menos que estén ocultos).';

  @override
  String get opponentTyping => 'El oponente está escribiendo...';

  @override
  String get sendQuestion => 'Enviar Pregunta';

  @override
  String get guessCharacter => 'Adivinar Personaje';

  @override
  String get waitingForAnswerEllipsis => 'Esperando respuesta...';

  @override
  String get waitingForQuestionEllipsis => 'Esperando pregunta...';

  @override
  String get dontKnow => 'No sé';

  @override
  String get youGoFirst => '¡Tú vas primero!';

  @override
  String playerGoesFirst(String playerName) {
    return '¡$playerName va primero!';
  }

  @override
  String get correct => '¡CORRECTO!';

  @override
  String get timesUp => '¡SE ACABÓ EL TIEMPO!';

  @override
  String get incorrect => '¡INCORRECTO!';

  @override
  String get nextRoundStarting => 'Comenzando siguiente ronda...';

  @override
  String get startingNewRound => 'Iniciando nueva ronda...';

  @override
  String get youWin => '🎉 ¡GANASTE! 🎉';

  @override
  String get youSuccessfullyGuessed =>
      '¡Adivinaste correctamente el Personaje de tu oponente!';

  @override
  String opponentWins(String opponentName) {
    return '$opponentName gana';
  }

  @override
  String opponentGuessedCorrectly(String opponentName) {
    return '¡$opponentName adivino tu Personaje correctamente!';
  }

  @override
  String get charactersSelected => 'Personajes Seleccionados:';

  @override
  String wantsToPlayAgain(String playerName) {
    return '¡$playerName quiere jugar de nuevo!';
  }

  @override
  String get waitingForOpponentToPlayAgain =>
      'Esperando a que el oponente juegue de nuevo...';

  @override
  String get waitingForOpponentEllipsis => 'Esperando al oponente...';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Fuego';

  @override
  String get typeWater => 'Agua';

  @override
  String get typeGrass => 'Planta';

  @override
  String get typeElectric => 'Eléctrico';

  @override
  String get typeIce => 'Hielo';

  @override
  String get typeFighting => 'Lucha';

  @override
  String get typePoison => 'Veneno';

  @override
  String get typeGround => 'Tierra';

  @override
  String get typeFlying => 'Volador';

  @override
  String get typePsychic => 'Psíquico';

  @override
  String get typeBug => 'Bicho';

  @override
  String get typeRock => 'Roca';

  @override
  String get typeGhost => 'Fantasma';

  @override
  String get typeDragon => 'Dragón';

  @override
  String get typeDark => 'Siniestro';

  @override
  String get typeSteel => 'Acero';

  @override
  String get typeFairy => 'Hada';

  @override
  String get evolutionChain => 'Cadena Evolutiva';

  @override
  String get type => 'Tipo';

  @override
  String get physicalStats => 'Estadísticas Físicas';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get baseStats => 'Estadísticas Base';

  @override
  String get abilities => 'Habilidades';

  @override
  String guessQuestion(String pokemonName) {
    return '¿Es $pokemonName?';
  }
}
