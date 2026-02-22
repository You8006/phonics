// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Phonics Sense';

  @override
  String get gameSelectTitle => 'エクササイズ';

  @override
  String get selectGame => 'エクササイズ';

  @override
  String get selectGameSubtitle => '練習したいエクササイズを選択';

  @override
  String get beginner => '初級';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '上級';

  @override
  String get game2Choice => '2択クイズ';

  @override
  String get gameSprint => 'スプリント';

  @override
  String get gameStandard => 'スタンダード';

  @override
  String get gameSingleFocus => '単文字に集中';

  @override
  String get gameDigraphs => '複文字に集中';

  @override
  String get gameDrill => '集中ドリル';

  @override
  String get gameIpaQuiz => 'IPAクイズ';

  @override
  String get gameIpaQuizDesc => '音を聞いて正しい発音記号を選択';

  @override
  String get gameIpaSprint => 'IPAスプリント';

  @override
  String get game4Choice => '4択チャレンジ';

  @override
  String get gameMarathon => 'マラソン';

  @override
  String get practiceLab => 'プラクティスラボ';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get score => '得点';

  @override
  String get correct => '正解';

  @override
  String get streak => '連続記録';

  @override
  String get resultPerfect => 'パーフェクト';

  @override
  String get resultGreat => '素晴らしい';

  @override
  String get resultGood => 'よくできました';

  @override
  String get resultKeep => '続けてみましょう';

  @override
  String get soundToLetterSubtitle => '音を聞いて正しい文字を選択してください';

  @override
  String get soundToIpaSubtitle => '音を聞いて正しい発音記号を選択してください';

  @override
  String get soundToLetterTitle => 'Sound Game';

  @override
  String get soundToIpaTitle => 'IPA Game';

  @override
  String get play => '再生';

  @override
  String get playAgainBtn => 'もう一度プレイ';

  @override
  String get listenSound => '音を聞く';

  @override
  String get groupTitle0 => 'Step 1: はじめての音';

  @override
  String get groupDesc0 => 'sat, pin などの単語を学習';

  @override
  String get groupTitle1 => 'Step 2: 便利な子音';

  @override
  String get groupDesc1 => 'hen, red などの単語を学習';

  @override
  String get groupTitle2 => 'Step 3: 身近な単語';

  @override
  String get groupDesc2 => 'dog, bus などの単語を学習';

  @override
  String get groupTitle3 => 'Step 4: 長い母音 1';

  @override
  String get groupDesc3 => 'rain, boat などの単語を学習';

  @override
  String get groupTitle4 => 'Step 5: 長い母音 2';

  @override
  String get groupDesc4 => 'book, moon などの単語を学習';

  @override
  String get groupTitle5 => 'Step 6: 難しい音';

  @override
  String get groupDesc5 => 'ship, thin などの単語を学習';

  @override
  String get groupTitle6 => 'Step 7: 最後の仕上げ';

  @override
  String get groupDesc6 => 'queen, car などの単語を学習';

  @override
  String get gameNewVariations => '新しいゲーム';

  @override
  String get gameBingo => 'サウンドビンゴ';

  @override
  String get gameCapitalMatch => '大文字・小文字';

  @override
  String get gameSoundQuiz => 'サウンドクイズ';

  @override
  String get gameSoundQuizDesc => '音を聞いて正しい文字を選択';

  @override
  String get gameBingoDesc => 'ビンゴカードを完成させる';

  @override
  String get gameCapitalMatchDesc => '大文字と小文字をマッチ';

  @override
  String get shortVowels => '短母音';

  @override
  String get basicConsonants => '子音';

  @override
  String get digraphsLabel => '二重字';

  @override
  String get settingsLabel => '設定';

  @override
  String get choicesLabel => '選択肢の数';

  @override
  String get questionsLabel => '問題数';

  @override
  String get gridSizeLabel => 'マス目';

  @override
  String get modeLabel => 'モード';

  @override
  String get selectSoundsHint => '音を選択して開始';

  @override
  String get gameBlending => 'ブレンディング';

  @override
  String get gameBlendingDesc => '音をつなげて単語を構成';

  @override
  String get gameWordChaining => 'ワードチェイン';

  @override
  String get gameWordChainingDesc => '1音を変えて次の単語を作成';

  @override
  String get gameMinimalPairs => 'リスニング';

  @override
  String get gameMinimalPairsDesc => '似た音の聞き分け練習';

  @override
  String get gameFillInBlank => '穴うめクイズ';

  @override
  String get gameFillInBlankDesc => '音を聞いて空白のフォニックスを選択';

  @override
  String get audioLibrary => '単語ライブラリー';

  @override
  String get audioLibraryDesc => '100の基本単語を確認';

  @override
  String get lessons => 'レッスン';

  @override
  String get games => 'ゲーム';

  @override
  String get library => 'ライブラリー';

  @override
  String get settings => '設定';

  @override
  String get searchWords => '単語を検索...';

  @override
  String get allCategories => 'すべて';

  @override
  String get tapToListen => 'タップして発音を確認';

  @override
  String get masterSounds => '42の英語の音をマスター';

  @override
  String phaseLabel(String phase) {
    return 'フェーズ $phase';
  }

  @override
  String srsReview(int count) {
    return '復習 ($count)';
  }

  @override
  String get customizePrefs => 'アプリの設定をカスタマイズ';

  @override
  String get voiceSettings => '音声設定';

  @override
  String get changeVoiceType => '音声タイプを変更';

  @override
  String get about => 'アプリ情報';

  @override
  String get appVersion => 'Phonics Sense v1.0.0';

  @override
  String masteredPercent(int percent) {
    return '$percent% 習得済み';
  }

  @override
  String get learn => '学習';

  @override
  String get exampleWords => '例文';

  @override
  String get playSound => '音を再生';

  @override
  String get wordsTab => '単語';

  @override
  String get phonicsTab => 'フォニックス';

  @override
  String get wordLibrary => '単語ライブラリー';

  @override
  String nWords(int count) {
    return '$count 語';
  }

  @override
  String get phonicsSoundDict => 'フォニックス音辞典';

  @override
  String nSounds(int count) {
    return '$count 音';
  }

  @override
  String get tapSpellingToSeeWords => 'スペリングをタップして単語を表示';

  @override
  String get groupLabel => 'グループ:';

  @override
  String wordsWithSpelling(String spelling) {
    return '「$spelling」の単語';
  }

  @override
  String practiceLabTitle(String group) {
    return '$group — プラクティスラボ';
  }

  @override
  String get practiceLabTitleDefault => 'プラクティスラボ';

  @override
  String get allSoundsMix => '全サウンドミックス (42)';

  @override
  String get practiceAllSounds => '42のフォニックス音をランダムに練習';

  @override
  String get vowelSoundFocus => '母音フォーカス';

  @override
  String get focusOnVowels => '母音に集中して練習';

  @override
  String get consonantSoundFocus => '子音フォーカス';

  @override
  String get focusOnConsonants => '子音に集中して練習';

  @override
  String get blendingBuilder => 'ブレンディングビルダー';

  @override
  String get buildWordsByArranging => '文字を並べて単語を構築';

  @override
  String get wordChainingTitle => 'ワードチェイン';

  @override
  String get changeOneSoundNewWord => '1音変えて新しい単語を作成';

  @override
  String get minimalPairListening => 'ミニマルペアリスニング';

  @override
  String get distinguishSounds => '似た音を聞き分ける';

  @override
  String blendingRound(int round, int total) {
    return 'ブレンディング $round / $total';
  }

  @override
  String get slow => 'ゆっくり';

  @override
  String get normal => '通常';

  @override
  String get buildWordYouHear => '聞こえた単語を組み立てる';

  @override
  String get undo => '元に戻す';

  @override
  String get reset => 'リセット';

  @override
  String get check => '確認';

  @override
  String wordChainingRound(int round, int total) {
    return 'ワードチェイン $round / $total';
  }

  @override
  String get changeOneSound => '1音を変更';

  @override
  String minimalPairsRound(int round, int total) {
    return 'ミニマルペア $round / $total';
  }

  @override
  String get whichWordDoYouHear => 'どちらの単語が聞こえますか？';

  @override
  String focusOn(String focus) {
    return 'フォーカス: $focus';
  }

  @override
  String get tapToPlay => 'タップして再生';

  @override
  String get bingoWin => 'ビンゴ';

  @override
  String get newGame => '新しいゲーム';

  @override
  String missCount(int count) {
    return 'ミス: $count';
  }

  @override
  String get fillInBlankTitle => '穴うめ問題';

  @override
  String get noQuestionsAvailable => '問題がありません';

  @override
  String get chooseCorrectSpelling => '正しいスペリングを選択';

  @override
  String get next => '次へ';

  @override
  String get tryAgain => 'もう一度';

  @override
  String selectAtLeastSounds(int count) {
    return '$count個以上の音を選択してください';
  }

  @override
  String get playBtn => 'プレイ';

  @override
  String get allLabel => 'すべて';

  @override
  String get listenAndChoose => '聞いて選ぶ';

  @override
  String get lessonComplete => 'レッスン完了！';

  @override
  String lessonCompleteDesc(String group) {
    return '$group のすべてのカードを学習しました。';
  }

  @override
  String get tryQuiz => 'クイズに挑戦';

  @override
  String get nextLesson => '次のレッスンへ';

  @override
  String get lessonDone => '完了';

  @override
  String get selectVoice => '音声を選択';

  @override
  String get voiceFemale => '女性';

  @override
  String get voiceFemaleDesc => 'Jenny — 温かく明瞭な声';

  @override
  String get voiceMale => '男性';

  @override
  String get voiceMaleDesc => 'Andrew — 深く自然な声';

  @override
  String get voiceYoung => 'ヤングスピーカー';

  @override
  String get voiceYoungDesc => 'Ana — 若い声';
}
