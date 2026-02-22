import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

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
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'Phonics Sense'**
  String get appTitle;

  /// No description provided for @gameSelectTitle.
  ///
  /// In ja, this message translates to:
  /// **'エクササイズ'**
  String get gameSelectTitle;

  /// No description provided for @selectGame.
  ///
  /// In ja, this message translates to:
  /// **'エクササイズ'**
  String get selectGame;

  /// No description provided for @selectGameSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'練習したいエクササイズを選択'**
  String get selectGameSubtitle;

  /// No description provided for @beginner.
  ///
  /// In ja, this message translates to:
  /// **'初級'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In ja, this message translates to:
  /// **'中級'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In ja, this message translates to:
  /// **'上級'**
  String get advanced;

  /// No description provided for @game2Choice.
  ///
  /// In ja, this message translates to:
  /// **'2択クイズ'**
  String get game2Choice;

  /// No description provided for @gameSprint.
  ///
  /// In ja, this message translates to:
  /// **'スプリント'**
  String get gameSprint;

  /// No description provided for @gameStandard.
  ///
  /// In ja, this message translates to:
  /// **'スタンダード'**
  String get gameStandard;

  /// No description provided for @gameSingleFocus.
  ///
  /// In ja, this message translates to:
  /// **'単文字に集中'**
  String get gameSingleFocus;

  /// No description provided for @gameDigraphs.
  ///
  /// In ja, this message translates to:
  /// **'複文字に集中'**
  String get gameDigraphs;

  /// No description provided for @gameDrill.
  ///
  /// In ja, this message translates to:
  /// **'集中ドリル'**
  String get gameDrill;

  /// No description provided for @gameIpaQuiz.
  ///
  /// In ja, this message translates to:
  /// **'IPAクイズ'**
  String get gameIpaQuiz;

  /// No description provided for @gameIpaQuizDesc.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい発音記号を選択'**
  String get gameIpaQuizDesc;

  /// No description provided for @gameIpaSprint.
  ///
  /// In ja, this message translates to:
  /// **'IPAスプリント'**
  String get gameIpaSprint;

  /// No description provided for @game4Choice.
  ///
  /// In ja, this message translates to:
  /// **'4択チャレンジ'**
  String get game4Choice;

  /// No description provided for @gameMarathon.
  ///
  /// In ja, this message translates to:
  /// **'マラソン'**
  String get gameMarathon;

  /// No description provided for @practiceLab.
  ///
  /// In ja, this message translates to:
  /// **'プラクティスラボ'**
  String get practiceLab;

  /// No description provided for @backToHome.
  ///
  /// In ja, this message translates to:
  /// **'ホームに戻る'**
  String get backToHome;

  /// No description provided for @playAgain.
  ///
  /// In ja, this message translates to:
  /// **'もう一度プレイ'**
  String get playAgain;

  /// No description provided for @score.
  ///
  /// In ja, this message translates to:
  /// **'得点'**
  String get score;

  /// No description provided for @correct.
  ///
  /// In ja, this message translates to:
  /// **'正解'**
  String get correct;

  /// No description provided for @streak.
  ///
  /// In ja, this message translates to:
  /// **'連続記録'**
  String get streak;

  /// No description provided for @resultPerfect.
  ///
  /// In ja, this message translates to:
  /// **'パーフェクト'**
  String get resultPerfect;

  /// No description provided for @resultGreat.
  ///
  /// In ja, this message translates to:
  /// **'素晴らしい'**
  String get resultGreat;

  /// No description provided for @resultGood.
  ///
  /// In ja, this message translates to:
  /// **'よくできました'**
  String get resultGood;

  /// No description provided for @resultKeep.
  ///
  /// In ja, this message translates to:
  /// **'続けてみましょう'**
  String get resultKeep;

  /// No description provided for @soundToLetterSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい文字を選択してください'**
  String get soundToLetterSubtitle;

  /// No description provided for @soundToIpaSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい発音記号を選択してください'**
  String get soundToIpaSubtitle;

  /// No description provided for @soundToLetterTitle.
  ///
  /// In ja, this message translates to:
  /// **'Sound Game'**
  String get soundToLetterTitle;

  /// No description provided for @soundToIpaTitle.
  ///
  /// In ja, this message translates to:
  /// **'IPA Game'**
  String get soundToIpaTitle;

  /// No description provided for @play.
  ///
  /// In ja, this message translates to:
  /// **'再生'**
  String get play;

  /// No description provided for @playAgainBtn.
  ///
  /// In ja, this message translates to:
  /// **'もう一度プレイ'**
  String get playAgainBtn;

  /// No description provided for @listenSound.
  ///
  /// In ja, this message translates to:
  /// **'音を聞く'**
  String get listenSound;

  /// No description provided for @groupTitle0.
  ///
  /// In ja, this message translates to:
  /// **'Step 1: はじめての音'**
  String get groupTitle0;

  /// No description provided for @groupDesc0.
  ///
  /// In ja, this message translates to:
  /// **'sat, pin などの単語を学習'**
  String get groupDesc0;

  /// No description provided for @groupTitle1.
  ///
  /// In ja, this message translates to:
  /// **'Step 2: 便利な子音'**
  String get groupTitle1;

  /// No description provided for @groupDesc1.
  ///
  /// In ja, this message translates to:
  /// **'hen, red などの単語を学習'**
  String get groupDesc1;

  /// No description provided for @groupTitle2.
  ///
  /// In ja, this message translates to:
  /// **'Step 3: 身近な単語'**
  String get groupTitle2;

  /// No description provided for @groupDesc2.
  ///
  /// In ja, this message translates to:
  /// **'dog, bus などの単語を学習'**
  String get groupDesc2;

  /// No description provided for @groupTitle3.
  ///
  /// In ja, this message translates to:
  /// **'Step 4: 長い母音 1'**
  String get groupTitle3;

  /// No description provided for @groupDesc3.
  ///
  /// In ja, this message translates to:
  /// **'rain, boat などの単語を学習'**
  String get groupDesc3;

  /// No description provided for @groupTitle4.
  ///
  /// In ja, this message translates to:
  /// **'Step 5: 長い母音 2'**
  String get groupTitle4;

  /// No description provided for @groupDesc4.
  ///
  /// In ja, this message translates to:
  /// **'book, moon などの単語を学習'**
  String get groupDesc4;

  /// No description provided for @groupTitle5.
  ///
  /// In ja, this message translates to:
  /// **'Step 6: 難しい音'**
  String get groupTitle5;

  /// No description provided for @groupDesc5.
  ///
  /// In ja, this message translates to:
  /// **'ship, thin などの単語を学習'**
  String get groupDesc5;

  /// No description provided for @groupTitle6.
  ///
  /// In ja, this message translates to:
  /// **'Step 7: 最後の仕上げ'**
  String get groupTitle6;

  /// No description provided for @groupDesc6.
  ///
  /// In ja, this message translates to:
  /// **'queen, car などの単語を学習'**
  String get groupDesc6;

  /// No description provided for @gameNewVariations.
  ///
  /// In ja, this message translates to:
  /// **'新しいゲーム'**
  String get gameNewVariations;

  /// No description provided for @gameBingo.
  ///
  /// In ja, this message translates to:
  /// **'サウンドビンゴ'**
  String get gameBingo;

  /// No description provided for @gameCapitalMatch.
  ///
  /// In ja, this message translates to:
  /// **'大文字・小文字'**
  String get gameCapitalMatch;

  /// No description provided for @gameSoundQuiz.
  ///
  /// In ja, this message translates to:
  /// **'サウンドクイズ'**
  String get gameSoundQuiz;

  /// No description provided for @gameSoundQuizDesc.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい文字を選択'**
  String get gameSoundQuizDesc;

  /// No description provided for @gameBingoDesc.
  ///
  /// In ja, this message translates to:
  /// **'ビンゴカードを完成させる'**
  String get gameBingoDesc;

  /// No description provided for @gameCapitalMatchDesc.
  ///
  /// In ja, this message translates to:
  /// **'大文字と小文字をマッチ'**
  String get gameCapitalMatchDesc;

  /// No description provided for @shortVowels.
  ///
  /// In ja, this message translates to:
  /// **'短母音'**
  String get shortVowels;

  /// No description provided for @basicConsonants.
  ///
  /// In ja, this message translates to:
  /// **'子音'**
  String get basicConsonants;

  /// No description provided for @digraphsLabel.
  ///
  /// In ja, this message translates to:
  /// **'二重字'**
  String get digraphsLabel;

  /// No description provided for @settingsLabel.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsLabel;

  /// No description provided for @choicesLabel.
  ///
  /// In ja, this message translates to:
  /// **'選択肢の数'**
  String get choicesLabel;

  /// No description provided for @questionsLabel.
  ///
  /// In ja, this message translates to:
  /// **'問題数'**
  String get questionsLabel;

  /// No description provided for @gridSizeLabel.
  ///
  /// In ja, this message translates to:
  /// **'マス目'**
  String get gridSizeLabel;

  /// No description provided for @modeLabel.
  ///
  /// In ja, this message translates to:
  /// **'モード'**
  String get modeLabel;

  /// No description provided for @selectSoundsHint.
  ///
  /// In ja, this message translates to:
  /// **'音を選択して開始'**
  String get selectSoundsHint;

  /// No description provided for @gameBlending.
  ///
  /// In ja, this message translates to:
  /// **'ブレンディング'**
  String get gameBlending;

  /// No description provided for @gameBlendingDesc.
  ///
  /// In ja, this message translates to:
  /// **'音をつなげて単語を構成'**
  String get gameBlendingDesc;

  /// No description provided for @gameWordChaining.
  ///
  /// In ja, this message translates to:
  /// **'ワードチェイン'**
  String get gameWordChaining;

  /// No description provided for @gameWordChainingDesc.
  ///
  /// In ja, this message translates to:
  /// **'1音を変えて次の単語を作成'**
  String get gameWordChainingDesc;

  /// No description provided for @gameMinimalPairs.
  ///
  /// In ja, this message translates to:
  /// **'リスニング'**
  String get gameMinimalPairs;

  /// No description provided for @gameMinimalPairsDesc.
  ///
  /// In ja, this message translates to:
  /// **'似た音の聞き分け練習'**
  String get gameMinimalPairsDesc;

  /// No description provided for @gameFillInBlank.
  ///
  /// In ja, this message translates to:
  /// **'穴うめクイズ'**
  String get gameFillInBlank;

  /// No description provided for @gameFillInBlankDesc.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて空白のフォニックスを選択'**
  String get gameFillInBlankDesc;

  /// No description provided for @audioLibrary.
  ///
  /// In ja, this message translates to:
  /// **'単語ライブラリー'**
  String get audioLibrary;

  /// No description provided for @audioLibraryDesc.
  ///
  /// In ja, this message translates to:
  /// **'100の基本単語を確認'**
  String get audioLibraryDesc;

  /// No description provided for @lessons.
  ///
  /// In ja, this message translates to:
  /// **'レッスン'**
  String get lessons;

  /// No description provided for @games.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム'**
  String get games;

  /// No description provided for @library.
  ///
  /// In ja, this message translates to:
  /// **'ライブラリー'**
  String get library;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @searchWords.
  ///
  /// In ja, this message translates to:
  /// **'単語を検索...'**
  String get searchWords;

  /// No description provided for @allCategories.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get allCategories;

  /// No description provided for @tapToListen.
  ///
  /// In ja, this message translates to:
  /// **'タップして発音を確認'**
  String get tapToListen;

  /// No description provided for @masterSounds.
  ///
  /// In ja, this message translates to:
  /// **'42の英語の音をマスター'**
  String get masterSounds;

  /// No description provided for @phaseLabel.
  ///
  /// In ja, this message translates to:
  /// **'フェーズ {phase}'**
  String phaseLabel(String phase);

  /// No description provided for @srsReview.
  ///
  /// In ja, this message translates to:
  /// **'復習 ({count})'**
  String srsReview(int count);

  /// No description provided for @customizePrefs.
  ///
  /// In ja, this message translates to:
  /// **'アプリの設定をカスタマイズ'**
  String get customizePrefs;

  /// No description provided for @voiceSettings.
  ///
  /// In ja, this message translates to:
  /// **'音声設定'**
  String get voiceSettings;

  /// No description provided for @changeVoiceType.
  ///
  /// In ja, this message translates to:
  /// **'音声タイプを変更'**
  String get changeVoiceType;

  /// No description provided for @about.
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In ja, this message translates to:
  /// **'Phonics Sense v1.0.0'**
  String get appVersion;

  /// No description provided for @masteredPercent.
  ///
  /// In ja, this message translates to:
  /// **'{percent}% 習得済み'**
  String masteredPercent(int percent);

  /// No description provided for @learn.
  ///
  /// In ja, this message translates to:
  /// **'学習'**
  String get learn;

  /// No description provided for @exampleWords.
  ///
  /// In ja, this message translates to:
  /// **'例文'**
  String get exampleWords;

  /// No description provided for @playSound.
  ///
  /// In ja, this message translates to:
  /// **'音を再生'**
  String get playSound;

  /// No description provided for @wordsTab.
  ///
  /// In ja, this message translates to:
  /// **'単語'**
  String get wordsTab;

  /// No description provided for @phonicsTab.
  ///
  /// In ja, this message translates to:
  /// **'フォニックス'**
  String get phonicsTab;

  /// No description provided for @wordLibrary.
  ///
  /// In ja, this message translates to:
  /// **'単語ライブラリー'**
  String get wordLibrary;

  /// No description provided for @nWords.
  ///
  /// In ja, this message translates to:
  /// **'{count} 語'**
  String nWords(int count);

  /// No description provided for @phonicsSoundDict.
  ///
  /// In ja, this message translates to:
  /// **'フォニックス音辞典'**
  String get phonicsSoundDict;

  /// No description provided for @nSounds.
  ///
  /// In ja, this message translates to:
  /// **'{count} 音'**
  String nSounds(int count);

  /// No description provided for @tapSpellingToSeeWords.
  ///
  /// In ja, this message translates to:
  /// **'スペリングをタップして単語を表示'**
  String get tapSpellingToSeeWords;

  /// No description provided for @groupLabel.
  ///
  /// In ja, this message translates to:
  /// **'グループ:'**
  String get groupLabel;

  /// No description provided for @wordsWithSpelling.
  ///
  /// In ja, this message translates to:
  /// **'「{spelling}」の単語'**
  String wordsWithSpelling(String spelling);

  /// No description provided for @practiceLabTitle.
  ///
  /// In ja, this message translates to:
  /// **'{group} — プラクティスラボ'**
  String practiceLabTitle(String group);

  /// No description provided for @practiceLabTitleDefault.
  ///
  /// In ja, this message translates to:
  /// **'プラクティスラボ'**
  String get practiceLabTitleDefault;

  /// No description provided for @allSoundsMix.
  ///
  /// In ja, this message translates to:
  /// **'全サウンドミックス (42)'**
  String get allSoundsMix;

  /// No description provided for @practiceAllSounds.
  ///
  /// In ja, this message translates to:
  /// **'42のフォニックス音をランダムに練習'**
  String get practiceAllSounds;

  /// No description provided for @vowelSoundFocus.
  ///
  /// In ja, this message translates to:
  /// **'母音フォーカス'**
  String get vowelSoundFocus;

  /// No description provided for @focusOnVowels.
  ///
  /// In ja, this message translates to:
  /// **'母音に集中して練習'**
  String get focusOnVowels;

  /// No description provided for @consonantSoundFocus.
  ///
  /// In ja, this message translates to:
  /// **'子音フォーカス'**
  String get consonantSoundFocus;

  /// No description provided for @focusOnConsonants.
  ///
  /// In ja, this message translates to:
  /// **'子音に集中して練習'**
  String get focusOnConsonants;

  /// No description provided for @blendingBuilder.
  ///
  /// In ja, this message translates to:
  /// **'ブレンディングビルダー'**
  String get blendingBuilder;

  /// No description provided for @buildWordsByArranging.
  ///
  /// In ja, this message translates to:
  /// **'文字を並べて単語を構築'**
  String get buildWordsByArranging;

  /// No description provided for @wordChainingTitle.
  ///
  /// In ja, this message translates to:
  /// **'ワードチェイン'**
  String get wordChainingTitle;

  /// No description provided for @changeOneSoundNewWord.
  ///
  /// In ja, this message translates to:
  /// **'1音変えて新しい単語を作成'**
  String get changeOneSoundNewWord;

  /// No description provided for @minimalPairListening.
  ///
  /// In ja, this message translates to:
  /// **'ミニマルペアリスニング'**
  String get minimalPairListening;

  /// No description provided for @distinguishSounds.
  ///
  /// In ja, this message translates to:
  /// **'似た音を聞き分ける'**
  String get distinguishSounds;

  /// No description provided for @blendingRound.
  ///
  /// In ja, this message translates to:
  /// **'ブレンディング {round} / {total}'**
  String blendingRound(int round, int total);

  /// No description provided for @slow.
  ///
  /// In ja, this message translates to:
  /// **'ゆっくり'**
  String get slow;

  /// No description provided for @normal.
  ///
  /// In ja, this message translates to:
  /// **'通常'**
  String get normal;

  /// No description provided for @buildWordYouHear.
  ///
  /// In ja, this message translates to:
  /// **'聞こえた単語を組み立てる'**
  String get buildWordYouHear;

  /// No description provided for @undo.
  ///
  /// In ja, this message translates to:
  /// **'元に戻す'**
  String get undo;

  /// No description provided for @reset.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get reset;

  /// No description provided for @check.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get check;

  /// No description provided for @wordChainingRound.
  ///
  /// In ja, this message translates to:
  /// **'ワードチェイン {round} / {total}'**
  String wordChainingRound(int round, int total);

  /// No description provided for @changeOneSound.
  ///
  /// In ja, this message translates to:
  /// **'1音を変更'**
  String get changeOneSound;

  /// No description provided for @minimalPairsRound.
  ///
  /// In ja, this message translates to:
  /// **'ミニマルペア {round} / {total}'**
  String minimalPairsRound(int round, int total);

  /// No description provided for @whichWordDoYouHear.
  ///
  /// In ja, this message translates to:
  /// **'どちらの単語が聞こえますか？'**
  String get whichWordDoYouHear;

  /// No description provided for @focusOn.
  ///
  /// In ja, this message translates to:
  /// **'フォーカス: {focus}'**
  String focusOn(String focus);

  /// No description provided for @tapToPlay.
  ///
  /// In ja, this message translates to:
  /// **'タップして再生'**
  String get tapToPlay;

  /// No description provided for @bingoWin.
  ///
  /// In ja, this message translates to:
  /// **'ビンゴ'**
  String get bingoWin;

  /// No description provided for @newGame.
  ///
  /// In ja, this message translates to:
  /// **'新しいゲーム'**
  String get newGame;

  /// No description provided for @missCount.
  ///
  /// In ja, this message translates to:
  /// **'ミス: {count}'**
  String missCount(int count);

  /// No description provided for @fillInBlankTitle.
  ///
  /// In ja, this message translates to:
  /// **'穴うめ問題'**
  String get fillInBlankTitle;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In ja, this message translates to:
  /// **'問題がありません'**
  String get noQuestionsAvailable;

  /// No description provided for @chooseCorrectSpelling.
  ///
  /// In ja, this message translates to:
  /// **'正しいスペリングを選択'**
  String get chooseCorrectSpelling;

  /// No description provided for @next.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get next;

  /// No description provided for @tryAgain.
  ///
  /// In ja, this message translates to:
  /// **'もう一度'**
  String get tryAgain;

  /// No description provided for @selectAtLeastSounds.
  ///
  /// In ja, this message translates to:
  /// **'{count}個以上の音を選択してください'**
  String selectAtLeastSounds(int count);

  /// No description provided for @playBtn.
  ///
  /// In ja, this message translates to:
  /// **'プレイ'**
  String get playBtn;

  /// No description provided for @allLabel.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get allLabel;

  /// No description provided for @listenAndChoose.
  ///
  /// In ja, this message translates to:
  /// **'聞いて選ぶ'**
  String get listenAndChoose;

  /// No description provided for @lessonComplete.
  ///
  /// In ja, this message translates to:
  /// **'レッスン完了！'**
  String get lessonComplete;

  /// No description provided for @lessonCompleteDesc.
  ///
  /// In ja, this message translates to:
  /// **'{group} のすべてのカードを学習しました。'**
  String lessonCompleteDesc(String group);

  /// No description provided for @tryQuiz.
  ///
  /// In ja, this message translates to:
  /// **'クイズに挑戦'**
  String get tryQuiz;

  /// No description provided for @nextLesson.
  ///
  /// In ja, this message translates to:
  /// **'次のレッスンへ'**
  String get nextLesson;

  /// No description provided for @lessonDone.
  ///
  /// In ja, this message translates to:
  /// **'完了'**
  String get lessonDone;

  /// No description provided for @selectVoice.
  ///
  /// In ja, this message translates to:
  /// **'音声を選択'**
  String get selectVoice;

  /// No description provided for @voiceFemale.
  ///
  /// In ja, this message translates to:
  /// **'女性'**
  String get voiceFemale;

  /// No description provided for @voiceFemaleDesc.
  ///
  /// In ja, this message translates to:
  /// **'Jenny — 温かく明瞭な声'**
  String get voiceFemaleDesc;

  /// No description provided for @voiceMale.
  ///
  /// In ja, this message translates to:
  /// **'男性'**
  String get voiceMale;

  /// No description provided for @voiceMaleDesc.
  ///
  /// In ja, this message translates to:
  /// **'Andrew — 深く自然な声'**
  String get voiceMaleDesc;

  /// No description provided for @voiceYoung.
  ///
  /// In ja, this message translates to:
  /// **'ヤングスピーカー'**
  String get voiceYoung;

  /// No description provided for @voiceYoungDesc.
  ///
  /// In ja, this message translates to:
  /// **'Ana — 若い声'**
  String get voiceYoungDesc;

  /// No description provided for @statsTitle.
  ///
  /// In ja, this message translates to:
  /// **'学習統計'**
  String get statsTitle;

  /// No description provided for @loginStreakLabel.
  ///
  /// In ja, this message translates to:
  /// **'連続ログイン'**
  String get loginStreakLabel;

  /// No description provided for @totalGamesLabel.
  ///
  /// In ja, this message translates to:
  /// **'総プレイ数'**
  String get totalGamesLabel;

  /// No description provided for @totalLessonsLabel.
  ///
  /// In ja, this message translates to:
  /// **'レッスン数'**
  String get totalLessonsLabel;

  /// No description provided for @todaySessionsLabel.
  ///
  /// In ja, this message translates to:
  /// **'今日'**
  String get todaySessionsLabel;

  /// No description provided for @daysUnit.
  ///
  /// In ja, this message translates to:
  /// **'{count}日'**
  String daysUnit(int count);

  /// No description provided for @timesUnit.
  ///
  /// In ja, this message translates to:
  /// **'{count}回'**
  String timesUnit(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
