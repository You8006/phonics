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
  /// **'Pop Phonics'**
  String get appTitle;

  /// No description provided for @gameSelectTitle.
  ///
  /// In ja, this message translates to:
  /// **'Phonics Adventure'**
  String get gameSelectTitle;

  /// No description provided for @selectGame.
  ///
  /// In ja, this message translates to:
  /// **'Let\'s Play! 🎮'**
  String get selectGame;

  /// No description provided for @selectGameSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'音と文字の練習をしよう'**
  String get selectGameSubtitle;

  /// No description provided for @beginner.
  ///
  /// In ja, this message translates to:
  /// **'初級 🌱'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In ja, this message translates to:
  /// **'中級 🌟'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In ja, this message translates to:
  /// **'上級 🚀'**
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
  /// **'音を聞いて正しい発音記号を選ぼう'**
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
  /// **'Practice Lab (ミニゲーム)'**
  String get practiceLab;

  /// No description provided for @backToHome.
  ///
  /// In ja, this message translates to:
  /// **'ホームに戻る'**
  String get backToHome;

  /// No description provided for @playAgain.
  ///
  /// In ja, this message translates to:
  /// **'もう一度遊ぶ'**
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
  /// **'連続日数 🔥'**
  String get streak;

  /// No description provided for @resultPerfect.
  ///
  /// In ja, this message translates to:
  /// **'Perfect! 🎉'**
  String get resultPerfect;

  /// No description provided for @resultGreat.
  ///
  /// In ja, this message translates to:
  /// **'Great Job! 🌟'**
  String get resultGreat;

  /// No description provided for @resultGood.
  ///
  /// In ja, this message translates to:
  /// **'Good Effort! 👍'**
  String get resultGood;

  /// No description provided for @resultKeep.
  ///
  /// In ja, this message translates to:
  /// **'Keep Going! 💪'**
  String get resultKeep;

  /// No description provided for @soundToLetterSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい文字を選ぼう'**
  String get soundToLetterSubtitle;

  /// No description provided for @soundToIpaSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい発音記号を選ぼう'**
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
  /// **'もう一度聞く'**
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
  /// **'\'sat\', \'pin\' などが読めるようになるよ！'**
  String get groupDesc0;

  /// No description provided for @groupTitle1.
  ///
  /// In ja, this message translates to:
  /// **'Step 2: 便利な子音'**
  String get groupTitle1;

  /// No description provided for @groupDesc1.
  ///
  /// In ja, this message translates to:
  /// **'\'hen\', \'red\' などが読めるようになるよ！'**
  String get groupDesc1;

  /// No description provided for @groupTitle2.
  ///
  /// In ja, this message translates to:
  /// **'Step 3: 身近な単語'**
  String get groupTitle2;

  /// No description provided for @groupDesc2.
  ///
  /// In ja, this message translates to:
  /// **'\'dog\', \'bus\' などが読めるようになるよ！'**
  String get groupDesc2;

  /// No description provided for @groupTitle3.
  ///
  /// In ja, this message translates to:
  /// **'Step 4: 長い母音 1'**
  String get groupTitle3;

  /// No description provided for @groupDesc3.
  ///
  /// In ja, this message translates to:
  /// **'\'rain\', \'boat\' などが読めるようになるよ！'**
  String get groupDesc3;

  /// No description provided for @groupTitle4.
  ///
  /// In ja, this message translates to:
  /// **'Step 5: 長い母音 2'**
  String get groupTitle4;

  /// No description provided for @groupDesc4.
  ///
  /// In ja, this message translates to:
  /// **'\'book\', \'moon\' などが読めるようになるよ！'**
  String get groupDesc4;

  /// No description provided for @groupTitle5.
  ///
  /// In ja, this message translates to:
  /// **'Step 6: 難しい音'**
  String get groupTitle5;

  /// No description provided for @gameNewVariations.
  ///
  /// In ja, this message translates to:
  /// **'新しいゲーム 🌟'**
  String get gameNewVariations;

  /// No description provided for @gameBingo.
  ///
  /// In ja, this message translates to:
  /// **'おとビンゴ'**
  String get gameBingo;

  /// No description provided for @gameCapitalMatch.
  ///
  /// In ja, this message translates to:
  /// **'大文字・小文字'**
  String get gameCapitalMatch;

  /// No description provided for @groupDesc5.
  ///
  /// In ja, this message translates to:
  /// **'\'ship\', \'thin\' などが読めるようになるよ！'**
  String get groupDesc5;

  /// No description provided for @groupTitle6.
  ///
  /// In ja, this message translates to:
  /// **'Step 7: 最後の仕上げ'**
  String get groupTitle6;

  /// No description provided for @groupDesc6.
  ///
  /// In ja, this message translates to:
  /// **'\'queen\', \'car\' などが読めるようになるよ！'**
  String get groupDesc6;

  /// No description provided for @gameSoundQuiz.
  ///
  /// In ja, this message translates to:
  /// **'サウンドクイズ'**
  String get gameSoundQuiz;

  /// No description provided for @gameSoundQuizDesc.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて正しい文字を選ぼう'**
  String get gameSoundQuizDesc;

  /// No description provided for @gameBingoDesc.
  ///
  /// In ja, this message translates to:
  /// **'ビンゴカードを埋めよう！'**
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
  /// **'音を選んでPlayを押そう！'**
  String get selectSoundsHint;

  /// No description provided for @gameBlending.
  ///
  /// In ja, this message translates to:
  /// **'ブレンディング'**
  String get gameBlending;

  /// No description provided for @gameBlendingDesc.
  ///
  /// In ja, this message translates to:
  /// **'音をつなげて単語を作ろう'**
  String get gameBlendingDesc;

  /// No description provided for @gameWordChaining.
  ///
  /// In ja, this message translates to:
  /// **'ワードチェイン'**
  String get gameWordChaining;

  /// No description provided for @gameWordChainingDesc.
  ///
  /// In ja, this message translates to:
  /// **'1音だけ変えて次の単語へ'**
  String get gameWordChainingDesc;

  /// No description provided for @gameMinimalPairs.
  ///
  /// In ja, this message translates to:
  /// **'リスニング'**
  String get gameMinimalPairs;

  /// No description provided for @gameMinimalPairsDesc.
  ///
  /// In ja, this message translates to:
  /// **'似た音を聞き分けよう'**
  String get gameMinimalPairsDesc;

  /// No description provided for @gameFillInBlank.
  ///
  /// In ja, this message translates to:
  /// **'穴うめクイズ'**
  String get gameFillInBlank;

  /// No description provided for @gameFillInBlankDesc.
  ///
  /// In ja, this message translates to:
  /// **'音を聞いて、空白のフォニックスを選ぼう'**
  String get gameFillInBlankDesc;

  /// No description provided for @audioLibrary.
  ///
  /// In ja, this message translates to:
  /// **'単語ライブラリー'**
  String get audioLibrary;

  /// No description provided for @audioLibraryDesc.
  ///
  /// In ja, this message translates to:
  /// **'100の基本単語を聞こう'**
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
  /// **'タップして発音を聞こう'**
  String get tapToListen;
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
