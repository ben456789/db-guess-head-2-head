// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Head 2 Head 推測ゲーム';

  @override
  String get gameDescription => '相手があなたのキャラクターを推測する前に、相手が選んだポケキャラを推測しよう！';

  @override
  String get createGame => 'ゲームを作成';

  @override
  String get joinGame => 'ゲームに参加';

  @override
  String get settings => '設定';

  @override
  String get howToPlay => '遊び方';

  @override
  String get legalTerms => '法的情報';

  @override
  String get close => '閉じる';

  @override
  String get yourName => 'あなたの名前';

  @override
  String get selectGenerations => 'ゲーム用の世代を選択';

  @override
  String get numberOfCharacters => 'キャラクター数';

  @override
  String get generating => '作成中...';

  @override
  String get generateCodeQR => 'コードとQRを生成';

  @override
  String get waitingForPlayer => '他のプレイヤーがQRをスキャンまたはコードを入力するのを待っています...';

  @override
  String get gameCodeLabel => 'ゲームコード';

  @override
  String get orScanQR => 'またはこのQRコードをスキャン';

  @override
  String get goToLobby => 'ロビーへ';

  @override
  String get pleaseEnterName => '名前を入力してください。';

  @override
  String get pleaseSelectGeneration => '少なくとも1つの世代を選択してください。';

  @override
  String get failedToCreateGame => 'ゲームの作成に失敗しました';

  @override
  String get enterNameAndCode => '名前と6桁のコードを入力してください。';

  @override
  String get gameCodeHint => '例: ABC123';

  @override
  String get failedToJoin => '参加に失敗しました';

  @override
  String get failedToSignIn => 'サインインに失敗しました';

  @override
  String get leaveGame => 'ゲームを退出?';

  @override
  String get leave => '退出';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get selectCharacter => 'キャラクターを選択';

  @override
  String get opponentReady => '対戦相手の準備ができました！';

  @override
  String get dismiss => '閉じる';

  @override
  String get gameOver => 'ゲーム終了';

  @override
  String get questionSent => '✅ 質問を送信しました！';

  @override
  String get answerSent => '✅ 回答を送信しました！';

  @override
  String get error => '❌ エラー';

  @override
  String get sendingAnswer => '📤 回答を送信中';

  @override
  String get opponentLeft => '対戦相手がゲームを退出しました';

  @override
  String get guessTheCharacter => 'キャラクターを当てよう！';

  @override
  String get askQuestion => '質問してください...';

  @override
  String get noCharacterToGuess => '推測できるキャラクターがありません';

  @override
  String get guess => '推測';

  @override
  String get roundResult => 'ラウンド結果';

  @override
  String get language => '言語';

  @override
  String get vibration => '振動';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get iDontKnow => 'わかりません';

  @override
  String get kanto => 'カントー';

  @override
  String get johto => 'ジョウト';

  @override
  String get hoenn => 'ホウエン';

  @override
  String get sinnoh => 'シンオウ';

  @override
  String get unova => 'イッシュ';

  @override
  String get kalos => 'カロス';

  @override
  String get alola => 'アローラ';

  @override
  String get galar => 'ガラル';

  @override
  String get paldea => 'パルデア';

  @override
  String get eula => 'エンドユーザー使用許諾契約（EULA）';

  @override
  String get eulaTitle => 'EULA';

  @override
  String get eulaContent =>
      'このアプリはMITライセンスの下で提供されています。このアプリを使用することにより、ライセンスに定められた利用規約および該当するアプリストアの要件を遵守することに同意したものとみなされます。';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsOfServiceContent =>
      'このアプリを使用することにより、娯楽目的のみに使用し、違法な活動には使用しないことに同意したものとみなされます。詳細については、MITライセンスを参照してください。';

  @override
  String get pokemonTrademarkNotice => '「ポケモン」およびポケモンのキャラクター名は任天堂の商標です。';

  @override
  String get creatingGame => 'ゲームの作成';

  @override
  String get creatingGameDesc =>
      '1. \"ゲームを作成\"ボタンを押してゲームを作成します\n2. 名前を入力し、マッチに含める世代とキャラクター数を選択します\n3. 対戦相手と共有するためのゲームコードまたはQRコードを生成します\n4. 対戦相手と共有して参加してもらいます';

  @override
  String get joiningGame => 'ゲームへの参加';

  @override
  String get joiningGameDesc =>
      '1. \"ゲームに参加\"ボタンを押してゲームに参加します\n2. 名前とゲームコードを入力するか、QRコードをスキャンします\n3. キャラクターを選択します';

  @override
  String get playingGame => 'ゲームのプレイ';

  @override
  String get playingGameDesc =>
      '1. コイントスでどちらが先攻か決まります\n2. チャットインターフェースを使用して交代ではい/いいえの質問をします\n3. 回答に基づいてキャラクターを除外します\n4. 相手があなたのキャラクターを推測する前に、相手が選んだキャラクターを推測しましょう！';

  @override
  String get privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get privacyPolicyIntro =>
      'このアプリはFirebaseサービスを使用してマルチプレイヤー機能を提供し、ゲームデータを保存します。ゲームプレイとアプリの改善のために、ユーザー名、ゲームの進行状況、デバイス情報などの基本情報を収集する場合があります。Firebaseまたは法律で必要とされる場合を除き、個人情報が第三者に販売または共有されることはありません。';

  @override
  String get dataCollected => '収集されるデータ：';

  @override
  String get dataCollectedList =>
      '- ユーザー名とゲームコード\n- ゲームの進行状況とスコア\n- デバイス情報（分析/デバッグ用）';

  @override
  String get howWeUseData => 'データの使用方法：';

  @override
  String get howWeUseDataList =>
      '- マルチプレイヤーゲームプレイを有効にするため\n- 進行状況を保存するため\n- アプリのパフォーマンスと安定性を向上させるため';

  @override
  String get thirdPartyServices => 'サードパーティサービス：';

  @override
  String get thirdPartyServicesDesc =>
      '認証、データベース、分析にはGoogle Firebaseを使用しています。詳細についてはFirebaseのプライバシーポリシーを参照してください。';

  @override
  String get contact => 'お問い合わせ：';

  @override
  String get contactDesc => 'プライバシーに関する質問がある場合は、開発者にお問い合わせください。';

  @override
  String get copyCode => 'コードをコピー';

  @override
  String get codeCopied => 'ゲームコードがクリップボードにコピーされました！';

  @override
  String get gameNotFound => 'ゲームが見つかりません。コードを確認してください。';

  @override
  String get scanQRCode => 'QRコードをスキャン';

  @override
  String get joining => '参加中...';

  @override
  String get gen => '第';

  @override
  String get createGameTitle => 'ゲーム作成';

  @override
  String get createGameHeading => 'ゲームを作成';

  @override
  String get createGameDescription => '名前を入力して、友達が参加できる6桁のコードとQRを生成してください。';

  @override
  String get waitingForFriend => '友達の参加を待っています...';

  @override
  String get friendCanScanQR => '友達はこのQRをスキャンするか、コードを入力して参加できます。';

  @override
  String get score => 'スコア';

  @override
  String get joinAFriend => '友達に参加';

  @override
  String get enterNameAndCodeOrScan => '名前と6桁のコードを入力するか、QRをスキャンしてください。';

  @override
  String get gameCode => 'ゲームコード';

  @override
  String get gameCodeExample => '例: ABC123';

  @override
  String get qrScanningNotAvailableWeb =>
      'QRスキャンはウェブでは利用できません。手動でコードを入力してください。';

  @override
  String get gameNotFoundCheckCode => 'ゲームが見つかりません。コードを確認してください。';

  @override
  String failedToJoinError(Object error) {
    return '参加に失敗しました: $error';
  }

  @override
  String get leaveGameConfirmation => '本当に退出しますか？ゲームは終了されます。';

  @override
  String playingAgainst(String opponentName) {
    return '対戦相手: $opponentName';
  }

  @override
  String get generationsInGame => 'このゲームの世代:';

  @override
  String get yourCharacter => 'あなたのキャラクター';

  @override
  String get chat => 'チャット';

  @override
  String get yourTurnToAnswer => 'あなたの答える番';

  @override
  String get yourTurnToAsk => 'あなたの質問する番';

  @override
  String get waitingForAnswer => '答えを待っています';

  @override
  String get waitingForQuestion => '質問を待っています';

  @override
  String get hideEliminated => '除外を非表示';

  @override
  String charactersRemaining(String opponentName, int count) {
    return '$opponentNameは$count体のキャラクターが残っています';
  }

  @override
  String get noAvailableCharacter => '推測できるキャラクターがありません';

  @override
  String get makeAGuess => '推測してください！';

  @override
  String confirmGuess(String pokemonName) {
    return '$pokemonNameを推測しますか？';
  }

  @override
  String get noMessagesYet => 'まだメッセージがありません...';

  @override
  String get eliminateReminder =>
      'キャラクターを除外することを忘れないでください！リストの最後にあります（非表示にしていない限り）。';

  @override
  String get opponentTyping => '対戦相手が入力中...';

  @override
  String get sendQuestion => '質問を送信';

  @override
  String get guessCharacter => 'キャラクターを推測';

  @override
  String get waitingForAnswerEllipsis => '答えを待っています...';

  @override
  String get waitingForQuestionEllipsis => '質問を待っています...';

  @override
  String get dontKnow => 'わかりません';

  @override
  String get youGoFirst => 'あなたが先攻！';

  @override
  String playerGoesFirst(String playerName) {
    return '$playerNameが先攻！';
  }

  @override
  String get correct => '正解！';

  @override
  String get timesUp => 'タイムアップ！';

  @override
  String get incorrect => '不正解！';

  @override
  String get nextRoundStarting => '次のラウンドが始まります...';

  @override
  String get startingNewRound => '新しいラウンドを開始しています...';

  @override
  String get youWin => '🎉 あなたの勝ち！ 🎉';

  @override
  String get youSuccessfullyGuessed => '相手のキャラクターを正しく推測しました！';

  @override
  String opponentWins(String opponentName) {
    return '$opponentNameの勝ち';
  }

  @override
  String opponentGuessedCorrectly(String opponentName) {
    return '$opponentNameがあなたのキャラクターを正しく推測しました！';
  }

  @override
  String get charactersSelected => '選択されたキャラクター：';

  @override
  String wantsToPlayAgain(String playerName) {
    return '$playerNameがもう一度プレイしたいです！';
  }

  @override
  String get waitingForOpponentToPlayAgain => '相手がもう一度プレイするのを待っています...';

  @override
  String get waitingForOpponentEllipsis => '相手を待っています...';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get typeNormal => 'ノーマル';

  @override
  String get typeFire => 'ほのお';

  @override
  String get typeWater => 'みず';

  @override
  String get typeGrass => 'くさ';

  @override
  String get typeElectric => 'でんき';

  @override
  String get typeIce => 'こおり';

  @override
  String get typeFighting => 'かくとう';

  @override
  String get typePoison => 'どく';

  @override
  String get typeGround => 'じめん';

  @override
  String get typeFlying => 'ひこう';

  @override
  String get typePsychic => 'エスパー';

  @override
  String get typeBug => 'むし';

  @override
  String get typeRock => 'いわ';

  @override
  String get typeGhost => 'ゴースト';

  @override
  String get typeDragon => 'ドラゴン';

  @override
  String get typeDark => 'あく';

  @override
  String get typeSteel => 'はがね';

  @override
  String get typeFairy => 'フェアリー';

  @override
  String get evolutionChain => '進化系統';

  @override
  String get type => 'タイプ';

  @override
  String get physicalStats => '物理ステータス';

  @override
  String get height => '高さ';

  @override
  String get weight => '重さ';

  @override
  String get baseStats => '基礎ステータス';

  @override
  String get abilities => '特性';

  @override
  String guessQuestion(String pokemonName) {
    return 'それは$pokemonNameですか？';
  }
}
