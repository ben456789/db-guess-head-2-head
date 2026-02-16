// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Jogo de Adivinhação Head 2 Head';

  @override
  String get gameDescription =>
      'Adivinhe qual personagem Poké seu oponente escolheu antes que ele adivinhe o seu!';

  @override
  String get createGame => 'Criar Jogo';

  @override
  String get joinGame => 'Entrar no Jogo';

  @override
  String get settings => 'Configurações';

  @override
  String get howToPlay => 'Como Jogar';

  @override
  String get legalTerms => 'Termos Legais';

  @override
  String get close => 'Fechar';

  @override
  String get yourName => 'Seu Nome';

  @override
  String get selectGenerations => 'Selecione as gerações para o jogo';

  @override
  String get numberOfCharacters => 'Número de Personagens';

  @override
  String get generating => 'Gerando...';

  @override
  String get generateCodeQR => 'Gerar Código e QR';

  @override
  String get waitingForPlayer =>
      'Aguardando outro jogador escanear o código QR ou digitar o código...';

  @override
  String get gameCodeLabel => 'Código do Jogo';

  @override
  String get orScanQR => 'Ou escaneie este código QR';

  @override
  String get goToLobby => 'Ir para o Lobby';

  @override
  String get pleaseEnterName => 'Por favor, insira seu nome.';

  @override
  String get pleaseSelectGeneration =>
      'Por favor, selecione pelo menos uma geração.';

  @override
  String get failedToCreateGame => 'Falha ao criar o jogo';

  @override
  String get enterNameAndCode => 'Digite seu nome e o código de 6 dígitos.';

  @override
  String get gameCodeHint => 'ex: ABC123';

  @override
  String get failedToJoin => 'Falha ao entrar';

  @override
  String get failedToSignIn => 'Falha ao fazer login';

  @override
  String get leaveGame => 'Sair do Jogo?';

  @override
  String get leave => 'Sair';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectCharacter => 'Selecionar Personagem';

  @override
  String get opponentReady => 'Seu oponente está pronto!';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get gameOver => 'Fim de Jogo';

  @override
  String get questionSent => '✅ Pergunta enviada!';

  @override
  String get answerSent => '✅ Resposta enviada!';

  @override
  String get error => '❌ Erro';

  @override
  String get sendingAnswer => '📤 Enviando resposta';

  @override
  String get opponentLeft => 'Seu oponente saiu do jogo';

  @override
  String get guessTheCharacter => 'Adivinhe o Personagem!';

  @override
  String get askQuestion => 'Faça uma pergunta...';

  @override
  String get noCharacterToGuess =>
      'Nenhum personagem disponível para adivinhar';

  @override
  String get guess => 'Adivinhar';

  @override
  String get roundResult => 'Resultado da Rodada';

  @override
  String get language => 'Idioma';

  @override
  String get vibration => 'Vibração';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get iDontKnow => 'Não sei';

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
  String get eula => 'Contrato de Licença de Usuário Final (EULA)';

  @override
  String get eulaTitle => 'EULA';

  @override
  String get eulaContent =>
      'Este aplicativo é fornecido sob a Licença MIT. Ao usar este aplicativo, você concorda em cumprir os termos e condições estabelecidos na licença e quaisquer requisitos aplicáveis da loja de aplicativos.';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get termsOfServiceContent =>
      'Ao usar este aplicativo, você concorda em usá-lo apenas para fins de entretenimento e não para atividades ilegais. Consulte a Licença MIT para mais detalhes.';

  @override
  String get pokemonTrademarkNotice =>
      'Pokémon e os nomes dos personagens Pokémon são marcas comerciais da Nintendo.';

  @override
  String get creatingGame => 'Criando um Jogo';

  @override
  String get creatingGameDesc =>
      '1. Crie o jogo clicando no botão \'Criar Jogo\'\n2. Digite seu nome e escolha quais gerações e quantos personagens deseja incluir no jogo\n3. Gere um código de jogo ou código QR para compartilhar com seu oponente\n4. Compartilhe com seu oponente para que ele possa entrar';

  @override
  String get joiningGame => 'Entrando em um Jogo';

  @override
  String get joiningGameDesc =>
      '1. Entre em um jogo clicando no botão \'Entrar no Jogo\'\n2. Digite seu nome e o código do jogo ou escaneie o código QR\n3. Selecione seu personagem';

  @override
  String get playingGame => 'Jogando o Jogo';

  @override
  String get playingGameDesc =>
      '1. Um lançamento de moeda decide quem começa\n2. Alternem fazendo perguntas de sim/não pela interface de chat\n3. Elimine personagens com base nas respostas\n4. Adivinhe qual personagem seu oponente escolheu antes que ele adivinhe o seu!';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get privacyPolicyIntro =>
      'Este aplicativo usa serviços Firebase para fornecer funcionalidade multijogador e armazenar dados do jogo. Podemos coletar informações básicas como nomes de usuário, progresso do jogo e informações do dispositivo para fins de jogo e melhoria do aplicativo. Informações pessoais não são vendidas ou compartilhadas com terceiros, exceto conforme exigido pelo Firebase ou por lei.';

  @override
  String get dataCollected => 'Dados Coletados:';

  @override
  String get dataCollectedList =>
      '- Nomes de usuário e códigos de jogo\n- Progresso do jogo e pontuações\n- Informações do dispositivo (para análise/solução de problemas)';

  @override
  String get howWeUseData => 'Como Usamos os Dados:';

  @override
  String get howWeUseDataList =>
      '- Para permitir jogabilidade multijogador\n- Para salvar seu progresso\n- Para melhorar o desempenho e estabilidade do aplicativo';

  @override
  String get thirdPartyServices => 'Serviços de Terceiros:';

  @override
  String get thirdPartyServicesDesc =>
      'Usamos o Google Firebase para autenticação, banco de dados e análises. Por favor, leia a política de privacidade do Firebase para mais detalhes.';

  @override
  String get contact => 'Contato:';

  @override
  String get contactDesc =>
      'Se você tiver perguntas sobre privacidade, entre em contato com o desenvolvedor.';

  @override
  String get copyCode => 'Copiar Código';

  @override
  String get codeCopied =>
      'Código do jogo copiado para a área de transferência!';

  @override
  String get gameNotFound =>
      'Jogo não encontrado. Por favor, verifique o código.';

  @override
  String get scanQRCode => 'Escanear Código QR';

  @override
  String get joining => 'Entrando...';

  @override
  String get gen => 'Ger';

  @override
  String get createGameTitle => 'Criar Jogo';

  @override
  String get createGameHeading => 'Criar jogo';

  @override
  String get createGameDescription =>
      'Digite seu nome para gerar um código de 6 dígitos e um código QR para seu amigo entrar.';

  @override
  String get waitingForFriend => 'Aguardando amigo...';

  @override
  String get friendCanScanQR =>
      'Seu amigo pode escanear este código QR ou digitar o código para entrar.';

  @override
  String get score => 'Pontuação';

  @override
  String get joinAFriend => 'Entrar com um Amigo';

  @override
  String get enterNameAndCodeOrScan =>
      'Digite seu nome e o código de 6 dígitos ou escaneie o QR dele.';

  @override
  String get gameCode => 'Código do Jogo';

  @override
  String get gameCodeExample => 'ex: ABC123';

  @override
  String get qrScanningNotAvailableWeb =>
      'Escaneamento de QR não está disponível na web. Por favor, digite o código manualmente.';

  @override
  String get gameNotFoundCheckCode =>
      'Jogo não encontrado. Por favor, verifique o código.';

  @override
  String failedToJoinError(Object error) {
    return 'Falha ao entrar: $error';
  }

  @override
  String get leaveGameConfirmation =>
      'Tem certeza que deseja sair? O jogo será encerrado.';

  @override
  String playingAgainst(String opponentName) {
    return 'Jogando contra: $opponentName';
  }

  @override
  String get generationsInGame => 'Gerações neste jogo:';

  @override
  String get yourCharacter => 'Seu Personagem';

  @override
  String get chat => 'Chat';

  @override
  String get yourTurnToAnswer => 'Sua vez de responder';

  @override
  String get yourTurnToAsk => 'Sua vez de perguntar';

  @override
  String get waitingForAnswer => 'Aguardando resposta';

  @override
  String get waitingForQuestion => 'Aguardando pergunta';

  @override
  String get hideEliminated => 'Ocultar Eliminados';

  @override
  String charactersRemaining(String opponentName, int count) {
    return '$opponentName tem $count personagens restantes';
  }

  @override
  String get noAvailableCharacter =>
      'Nenhum personagem disponível para adivinhar';

  @override
  String get makeAGuess => 'Faça um Palpite!';

  @override
  String confirmGuess(String pokemonName) {
    return 'Tem certeza que deseja adivinhar $pokemonName?';
  }

  @override
  String get noMessagesYet => 'Ainda sem mensagens...';

  @override
  String get eliminateReminder =>
      'Não se esqueça de eliminar personagens! Eles estão no final da lista (A menos que estejam ocultos).';

  @override
  String get opponentTyping => 'Oponente digitando...';

  @override
  String get sendQuestion => 'Enviar Pergunta';

  @override
  String get guessCharacter => 'Adivinhar Personagem';

  @override
  String get waitingForAnswerEllipsis => 'Aguardando resposta...';

  @override
  String get waitingForQuestionEllipsis => 'Aguardando pergunta...';

  @override
  String get dontKnow => 'Não sei';

  @override
  String get youGoFirst => 'Você começa!';

  @override
  String playerGoesFirst(String playerName) {
    return '$playerName começa!';
  }

  @override
  String get correct => 'CORRETO!';

  @override
  String get timesUp => 'TEMPO ESGOTADO!';

  @override
  String get incorrect => 'INCORRETO!';

  @override
  String get nextRoundStarting => 'Próxima rodada começando...';

  @override
  String get startingNewRound => 'Iniciando nova rodada...';

  @override
  String get youWin => '🎉 VOCÊ VENCEU! 🎉';

  @override
  String get youSuccessfullyGuessed =>
      'Você adivinhou com sucesso o personagem do seu oponente!';

  @override
  String opponentWins(String opponentName) {
    return '$opponentName vence';
  }

  @override
  String opponentGuessedCorrectly(String opponentName) {
    return '$opponentName adivinhou seu personagem corretamente!';
  }

  @override
  String get charactersSelected => 'Personagens selecionados:';

  @override
  String wantsToPlayAgain(String playerName) {
    return '$playerName quer jogar novamente!';
  }

  @override
  String get waitingForOpponentToPlayAgain =>
      'Aguardando o oponente jogar novamente...';

  @override
  String get waitingForOpponentEllipsis => 'Aguardando oponente...';

  @override
  String get playAgain => 'Jogar Novamente';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Fogo';

  @override
  String get typeWater => 'Água';

  @override
  String get typeGrass => 'Planta';

  @override
  String get typeElectric => 'Elétrico';

  @override
  String get typeIce => 'Gelo';

  @override
  String get typeFighting => 'Lutador';

  @override
  String get typePoison => 'Veneno';

  @override
  String get typeGround => 'Terra';

  @override
  String get typeFlying => 'Voador';

  @override
  String get typePsychic => 'Psíquico';

  @override
  String get typeBug => 'Inseto';

  @override
  String get typeRock => 'Pedra';

  @override
  String get typeGhost => 'Fantasma';

  @override
  String get typeDragon => 'Dragão';

  @override
  String get typeDark => 'Sombrio';

  @override
  String get typeSteel => 'Aço';

  @override
  String get typeFairy => 'Fada';

  @override
  String get evolutionChain => 'Cadeia Evolutiva';

  @override
  String get type => 'Tipo';

  @override
  String get physicalStats => 'Estatísticas Físicas';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get baseStats => 'Estatísticas Base';

  @override
  String get abilities => 'Habilidades';

  @override
  String guessQuestion(String pokemonName) {
    return 'É $pokemonName?';
  }
}
