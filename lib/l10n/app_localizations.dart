import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

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
    Locale('es'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Phonics Sense'**
  String get appTitle;

  /// No description provided for @gameSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get gameSelectTitle;

  /// No description provided for @selectGame.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get selectGame;

  /// No description provided for @selectGameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise to practice'**
  String get selectGameSubtitle;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @game2Choice.
  ///
  /// In en, this message translates to:
  /// **'2-Choice'**
  String get game2Choice;

  /// No description provided for @gameSprint.
  ///
  /// In en, this message translates to:
  /// **'Sprint'**
  String get gameSprint;

  /// No description provided for @gameStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get gameStandard;

  /// No description provided for @gameSingleFocus.
  ///
  /// In en, this message translates to:
  /// **'Single Focus'**
  String get gameSingleFocus;

  /// No description provided for @gameDigraphs.
  ///
  /// In en, this message translates to:
  /// **'Digraphs'**
  String get gameDigraphs;

  /// No description provided for @gameDrill.
  ///
  /// In en, this message translates to:
  /// **'Drill'**
  String get gameDrill;

  /// No description provided for @gameIpaQuiz.
  ///
  /// In en, this message translates to:
  /// **'IPA Quiz'**
  String get gameIpaQuiz;

  /// No description provided for @gameIpaQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen and pick the right IPA symbol'**
  String get gameIpaQuizDesc;

  /// No description provided for @gameIpaSprint.
  ///
  /// In en, this message translates to:
  /// **'IPA Sprint'**
  String get gameIpaSprint;

  /// No description provided for @game4Choice.
  ///
  /// In en, this message translates to:
  /// **'4-Choice'**
  String get game4Choice;

  /// No description provided for @gameMarathon.
  ///
  /// In en, this message translates to:
  /// **'Marathon'**
  String get gameMarathon;

  /// No description provided for @practiceLab.
  ///
  /// In en, this message translates to:
  /// **'Practice Lab'**
  String get practiceLab;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @resultPerfect.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get resultPerfect;

  /// No description provided for @resultGreat.
  ///
  /// In en, this message translates to:
  /// **'Well Done'**
  String get resultGreat;

  /// No description provided for @resultGood.
  ///
  /// In en, this message translates to:
  /// **'Solid Effort'**
  String get resultGood;

  /// No description provided for @resultKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing'**
  String get resultKeep;

  /// No description provided for @soundToLetterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Listen and choose the correct letter'**
  String get soundToLetterSubtitle;

  /// No description provided for @soundToIpaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Listen and choose the correct IPA symbol'**
  String get soundToIpaSubtitle;

  /// No description provided for @soundToLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Game'**
  String get soundToLetterTitle;

  /// No description provided for @soundToIpaTitle.
  ///
  /// In en, this message translates to:
  /// **'IPA Game'**
  String get soundToIpaTitle;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play Sound'**
  String get play;

  /// No description provided for @playAgainBtn.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgainBtn;

  /// No description provided for @listenSound.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listenSound;

  /// No description provided for @groupTitle0.
  ///
  /// In en, this message translates to:
  /// **'Step 1: First Sounds'**
  String get groupTitle0;

  /// No description provided for @groupDesc0.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: sat, pin, and more'**
  String get groupDesc0;

  /// No description provided for @groupTitle1.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Useful Consonants'**
  String get groupTitle1;

  /// No description provided for @groupDesc1.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: hen, red, and more'**
  String get groupDesc1;

  /// No description provided for @groupTitle2.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Everyday Words'**
  String get groupTitle2;

  /// No description provided for @groupDesc2.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: dog, bus, and more'**
  String get groupDesc2;

  /// No description provided for @groupTitle3.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Long Vowels 1'**
  String get groupTitle3;

  /// No description provided for @groupDesc3.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: rain, boat, and more'**
  String get groupDesc3;

  /// No description provided for @groupTitle4.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Long Vowels 2'**
  String get groupTitle4;

  /// No description provided for @groupDesc4.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: book, moon, and more'**
  String get groupDesc4;

  /// No description provided for @groupTitle5.
  ///
  /// In en, this message translates to:
  /// **'Step 6: Tricky Sounds'**
  String get groupTitle5;

  /// No description provided for @groupDesc5.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: ship, thin, and more'**
  String get groupDesc5;

  /// No description provided for @groupTitle6.
  ///
  /// In en, this message translates to:
  /// **'Step 7: Final Steps'**
  String get groupTitle6;

  /// No description provided for @groupDesc6.
  ///
  /// In en, this message translates to:
  /// **'Learn to read: queen, car, and more'**
  String get groupDesc6;

  /// No description provided for @gameNewVariations.
  ///
  /// In en, this message translates to:
  /// **'New Variations'**
  String get gameNewVariations;

  /// No description provided for @gameBingo.
  ///
  /// In en, this message translates to:
  /// **'Bingo'**
  String get gameBingo;

  /// No description provided for @gameCapitalMatch.
  ///
  /// In en, this message translates to:
  /// **'Cap-Lower'**
  String get gameCapitalMatch;

  /// No description provided for @gameSoundQuiz.
  ///
  /// In en, this message translates to:
  /// **'Sound Quiz'**
  String get gameSoundQuiz;

  /// No description provided for @gameSoundQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen and pick the right letter'**
  String get gameSoundQuizDesc;

  /// No description provided for @gameBingoDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete the bingo grid'**
  String get gameBingoDesc;

  /// No description provided for @gameCapitalMatchDesc.
  ///
  /// In en, this message translates to:
  /// **'Match upper & lowercase'**
  String get gameCapitalMatchDesc;

  /// No description provided for @shortVowels.
  ///
  /// In en, this message translates to:
  /// **'Short Vowels'**
  String get shortVowels;

  /// No description provided for @basicConsonants.
  ///
  /// In en, this message translates to:
  /// **'Consonants'**
  String get basicConsonants;

  /// No description provided for @digraphsLabel.
  ///
  /// In en, this message translates to:
  /// **'Digraphs'**
  String get digraphsLabel;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @choicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get choicesLabel;

  /// No description provided for @questionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questionsLabel;

  /// No description provided for @gridSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid Size'**
  String get gridSizeLabel;

  /// No description provided for @modeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get modeLabel;

  /// No description provided for @readingDisplayLabel.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get readingDisplayLabel;

  /// No description provided for @readingDisplayIpa.
  ///
  /// In en, this message translates to:
  /// **'IPA only'**
  String get readingDisplayIpa;

  /// No description provided for @readingDisplayDetail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get readingDisplayDetail;

  /// No description provided for @selectSoundsHint.
  ///
  /// In en, this message translates to:
  /// **'Select sounds, then start'**
  String get selectSoundsHint;

  /// No description provided for @gameBlending.
  ///
  /// In en, this message translates to:
  /// **'Blending'**
  String get gameBlending;

  /// No description provided for @gameBlendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Build words from sounds'**
  String get gameBlendingDesc;

  /// No description provided for @gameWordChaining.
  ///
  /// In en, this message translates to:
  /// **'Word Chain'**
  String get gameWordChaining;

  /// No description provided for @gameWordChainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Change one sound at a time'**
  String get gameWordChainingDesc;

  /// No description provided for @gameMinimalPairs.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get gameMinimalPairs;

  /// No description provided for @gameMinimalPairsDesc.
  ///
  /// In en, this message translates to:
  /// **'Spot the difference in sounds'**
  String get gameMinimalPairsDesc;

  /// No description provided for @gameFillInBlank.
  ///
  /// In en, this message translates to:
  /// **'Fill-in Quiz'**
  String get gameFillInBlank;

  /// No description provided for @gameFillInBlankDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen and fill in the missing phonics'**
  String get gameFillInBlankDesc;

  /// No description provided for @gameSoundExplorer.
  ///
  /// In en, this message translates to:
  /// **'Sound Explorer'**
  String get gameSoundExplorer;

  /// No description provided for @gameSoundExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'See a letter, find its sound'**
  String get gameSoundExplorerDesc;

  /// No description provided for @findThisSound.
  ///
  /// In en, this message translates to:
  /// **'Find this sound'**
  String get findThisSound;

  /// No description provided for @listenThenChoose.
  ///
  /// In en, this message translates to:
  /// **'Listen, then choose'**
  String get listenThenChoose;

  /// No description provided for @audioLibrary.
  ///
  /// In en, this message translates to:
  /// **'Word Library'**
  String get audioLibrary;

  /// No description provided for @audioLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse and listen to 100 essential words'**
  String get audioLibraryDesc;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchWords.
  ///
  /// In en, this message translates to:
  /// **'Search words...'**
  String get searchWords;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @tapToListen.
  ///
  /// In en, this message translates to:
  /// **'Tap a word to hear its pronunciation'**
  String get tapToListen;

  /// No description provided for @masterSounds.
  ///
  /// In en, this message translates to:
  /// **'Master 42 English sounds'**
  String get masterSounds;

  /// No description provided for @phaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Phase {phase}'**
  String phaseLabel(String phase);

  /// No description provided for @srsReview.
  ///
  /// In en, this message translates to:
  /// **'SRS Review ({count})'**
  String srsReview(int count);

  /// No description provided for @customizePrefs.
  ///
  /// In en, this message translates to:
  /// **'Customize your app preferences'**
  String get customizePrefs;

  /// No description provided for @voiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Voice Settings'**
  String get voiceSettings;

  /// No description provided for @changeVoiceType.
  ///
  /// In en, this message translates to:
  /// **'Change voice type'**
  String get changeVoiceType;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app display language'**
  String get changeAppLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Phonics Sense v1.0.0'**
  String get appVersion;

  /// No description provided for @lessonCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Studied {count} times'**
  String lessonCountLabel(int count);

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @exampleWords.
  ///
  /// In en, this message translates to:
  /// **'Example words'**
  String get exampleWords;

  /// No description provided for @playSound.
  ///
  /// In en, this message translates to:
  /// **'Play Sound'**
  String get playSound;

  /// No description provided for @wordsTab.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get wordsTab;

  /// No description provided for @phonicsTab.
  ///
  /// In en, this message translates to:
  /// **'Phonics'**
  String get phonicsTab;

  /// No description provided for @wordLibrary.
  ///
  /// In en, this message translates to:
  /// **'Word Library'**
  String get wordLibrary;

  /// No description provided for @nWords.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String nWords(int count);

  /// No description provided for @phonicsSoundDict.
  ///
  /// In en, this message translates to:
  /// **'Phonics Sound Dictionary'**
  String get phonicsSoundDict;

  /// No description provided for @nSounds.
  ///
  /// In en, this message translates to:
  /// **'{count} sounds'**
  String nSounds(int count);

  /// No description provided for @tapSpellingToSeeWords.
  ///
  /// In en, this message translates to:
  /// **'Tap a spelling to see words'**
  String get tapSpellingToSeeWords;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group:'**
  String get groupLabel;

  /// No description provided for @wordsWithSpelling.
  ///
  /// In en, this message translates to:
  /// **'Words with \"{spelling}\"'**
  String wordsWithSpelling(String spelling);

  /// No description provided for @practiceLabTitle.
  ///
  /// In en, this message translates to:
  /// **'{group} — Practice Lab'**
  String practiceLabTitle(String group);

  /// No description provided for @practiceLabTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Practice Lab'**
  String get practiceLabTitleDefault;

  /// No description provided for @allSoundsMix.
  ///
  /// In en, this message translates to:
  /// **'All Sounds Mix (42)'**
  String get allSoundsMix;

  /// No description provided for @practiceAllSounds.
  ///
  /// In en, this message translates to:
  /// **'Practice all 42 phonics sounds at random'**
  String get practiceAllSounds;

  /// No description provided for @vowelSoundFocus.
  ///
  /// In en, this message translates to:
  /// **'Vowel Sound Focus'**
  String get vowelSoundFocus;

  /// No description provided for @focusOnVowels.
  ///
  /// In en, this message translates to:
  /// **'Focus on vowel sounds'**
  String get focusOnVowels;

  /// No description provided for @consonantSoundFocus.
  ///
  /// In en, this message translates to:
  /// **'Consonant Sound Focus'**
  String get consonantSoundFocus;

  /// No description provided for @focusOnConsonants.
  ///
  /// In en, this message translates to:
  /// **'Focus on consonant sounds'**
  String get focusOnConsonants;

  /// No description provided for @blendingBuilder.
  ///
  /// In en, this message translates to:
  /// **'Blending Builder'**
  String get blendingBuilder;

  /// No description provided for @buildWordsByArranging.
  ///
  /// In en, this message translates to:
  /// **'Build words by arranging letters'**
  String get buildWordsByArranging;

  /// No description provided for @wordChainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Word Chaining'**
  String get wordChainingTitle;

  /// No description provided for @changeOneSoundNewWord.
  ///
  /// In en, this message translates to:
  /// **'Change one sound to make a new word'**
  String get changeOneSoundNewWord;

  /// No description provided for @minimalPairListening.
  ///
  /// In en, this message translates to:
  /// **'Minimal Pair Listening'**
  String get minimalPairListening;

  /// No description provided for @distinguishSounds.
  ///
  /// In en, this message translates to:
  /// **'Distinguish between similar sounds'**
  String get distinguishSounds;

  /// No description provided for @blendingRound.
  ///
  /// In en, this message translates to:
  /// **'Blending {round} / {total}'**
  String blendingRound(int round, int total);

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @buildWordYouHear.
  ///
  /// In en, this message translates to:
  /// **'Build the word you hear'**
  String get buildWordYouHear;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @wordChainingRound.
  ///
  /// In en, this message translates to:
  /// **'Word Chaining {round} / {total}'**
  String wordChainingRound(int round, int total);

  /// No description provided for @changeOneSound.
  ///
  /// In en, this message translates to:
  /// **'Change one sound'**
  String get changeOneSound;

  /// No description provided for @minimalPairsRound.
  ///
  /// In en, this message translates to:
  /// **'Minimal Pairs {round} / {total}'**
  String minimalPairsRound(int round, int total);

  /// No description provided for @whichWordDoYouHear.
  ///
  /// In en, this message translates to:
  /// **'Which word do you hear?'**
  String get whichWordDoYouHear;

  /// No description provided for @focusOn.
  ///
  /// In en, this message translates to:
  /// **'Focus: {focus}'**
  String focusOn(String focus);

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to play'**
  String get tapToPlay;

  /// No description provided for @bingoWin.
  ///
  /// In en, this message translates to:
  /// **'BINGO'**
  String get bingoWin;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @missCount.
  ///
  /// In en, this message translates to:
  /// **'Miss: {count}'**
  String missCount(int count);

  /// No description provided for @fillInBlankTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the Blank'**
  String get fillInBlankTitle;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No questions available'**
  String get noQuestionsAvailable;

  /// No description provided for @chooseCorrectSpelling.
  ///
  /// In en, this message translates to:
  /// **'Choose the correct spelling'**
  String get chooseCorrectSpelling;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @selectAtLeastSounds.
  ///
  /// In en, this message translates to:
  /// **'Select at least {count} sounds'**
  String selectAtLeastSounds(int count);

  /// No description provided for @playBtn.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playBtn;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// No description provided for @listenAndChoose.
  ///
  /// In en, this message translates to:
  /// **'Listen & Choose'**
  String get listenAndChoose;

  /// No description provided for @lessonComplete.
  ///
  /// In en, this message translates to:
  /// **'Lesson Complete!'**
  String get lessonComplete;

  /// No description provided for @lessonCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished all cards in {group}.'**
  String lessonCompleteDesc(String group);

  /// No description provided for @tryQuiz.
  ///
  /// In en, this message translates to:
  /// **'Try the Quiz'**
  String get tryQuiz;

  /// No description provided for @nextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get nextLesson;

  /// No description provided for @lessonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get lessonDone;

  /// No description provided for @selectVoice.
  ///
  /// In en, this message translates to:
  /// **'Select Voice'**
  String get selectVoice;

  /// No description provided for @voiceFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get voiceFemale;

  /// No description provided for @voiceFemaleDesc.
  ///
  /// In en, this message translates to:
  /// **'Jenny — Warm and clear'**
  String get voiceFemaleDesc;

  /// No description provided for @voiceMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get voiceMale;

  /// No description provided for @voiceMaleDesc.
  ///
  /// In en, this message translates to:
  /// **'Andrew — Deep and natural'**
  String get voiceMaleDesc;

  /// No description provided for @voiceYoung.
  ///
  /// In en, this message translates to:
  /// **'Young Speaker'**
  String get voiceYoung;

  /// No description provided for @voiceYoungDesc.
  ///
  /// In en, this message translates to:
  /// **'Ana — Young speaker'**
  String get voiceYoungDesc;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Stats'**
  String get statsTitle;

  /// No description provided for @homeGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Guide'**
  String get homeGuideTitle;

  /// No description provided for @homeGuideGroupInfo.
  ///
  /// In en, this message translates to:
  /// **'• Groups are sets of sounds to learn (vowels, consonants, digraphs).'**
  String get homeGuideGroupInfo;

  /// No description provided for @homeGuideFlow.
  ///
  /// In en, this message translates to:
  /// **'• Start with Learn to hear sounds, then use Play to reinforce them.'**
  String get homeGuideFlow;

  /// No description provided for @homeGuideReview.
  ///
  /// In en, this message translates to:
  /// **'• Sounds you miss are added to review, and you can revisit them from the button below.'**
  String get homeGuideReview;

  /// No description provided for @loginStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Login Streak'**
  String get loginStreakLabel;

  /// No description provided for @totalGamesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Games'**
  String get totalGamesLabel;

  /// No description provided for @totalLessonsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get totalLessonsLabel;

  /// No description provided for @todaySessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySessionsLabel;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysUnit(int count);

  /// No description provided for @timesUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String timesUnit(int count);

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Learning Data'**
  String get resetProgress;

  /// No description provided for @resetProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete all scores, streaks, and history'**
  String get resetProgressDesc;

  /// No description provided for @resetProgressConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all learning data?'**
  String get resetProgressConfirmTitle;

  /// No description provided for @resetProgressConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all learning records, scores, streaks, and game history. This action cannot be undone.'**
  String get resetProgressConfirmBody;

  /// No description provided for @resetProgressConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetProgressConfirmBtn;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @resetProgressDone.
  ///
  /// In en, this message translates to:
  /// **'Learning data has been reset.'**
  String get resetProgressDone;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startGame;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// No description provided for @tutorialSoundQuiz.
  ///
  /// In en, this message translates to:
  /// **'① Select the sounds you want to practice (vowels, consonants, digraphs)\n② Choose the number of answer choices (2/3/4) and questions (5–20)\n③ Listen to a sound and tap the correct letter\n④ Get instant feedback — green for correct, red for wrong'**
  String get tutorialSoundQuiz;

  /// No description provided for @tutorialIpaQuiz.
  ///
  /// In en, this message translates to:
  /// **'① Select the sounds you want to practice\n② Choose the number of choices (2/3/4) and questions (5–20)\n③ Listen to a sound and tap the matching IPA symbol\n④ A great way to learn phonetic notation while training your ear'**
  String get tutorialIpaQuiz;

  /// No description provided for @tutorialBingo.
  ///
  /// In en, this message translates to:
  /// **'① Select the sounds for your bingo board\n② Choose the grid size (3×3 / 4×4 / 5×5)\n③ Listen to a sound and tap the matching cell on the grid\n④ Complete a row, column, or diagonal to win!'**
  String get tutorialBingo;

  /// No description provided for @tutorialBlending.
  ///
  /// In en, this message translates to:
  /// **'① Listen to the word using the Slow or Normal button\n② Tap the letter tiles in the correct order to spell it\n③ Use Undo or Reset if you make a mistake\n④ 8 rounds — build your spelling and phonics skills!'**
  String get tutorialBlending;

  /// No description provided for @tutorialWordChaining.
  ///
  /// In en, this message translates to:
  /// **'① Listen to the current word, then pick the word with one sound changed\n② Choose from 3 options — only one is correct\n③ After answering, tap each word to hear it spoken\n④ 8 rounds of chaining — sharpen your ear for subtle differences!'**
  String get tutorialWordChaining;

  /// No description provided for @tutorialMinimalPairs.
  ///
  /// In en, this message translates to:
  /// **'① Listen to a word using the Slow or Normal button\n② Two similar words are shown — tap the one you heard\n③ Focus on the highlighted sound difference\n④ Up to 12 rounds — train your ear to catch tiny differences!'**
  String get tutorialMinimalPairs;

  /// No description provided for @tutorialFillInBlank.
  ///
  /// In en, this message translates to:
  /// **'① See a word with a missing sound and its meaning\n② Listen to the word using the speaker buttons\n③ Tap the correct phonics pattern from the choices\n④ 15 questions — use your phonics knowledge to fill in the gaps!'**
  String get tutorialFillInBlank;

  /// No description provided for @tutorialSoundExplorer.
  ///
  /// In en, this message translates to:
  /// **'① Select the sounds you want to explore\n② Choose the number of choices (2/3/4) and questions (5–20)\n③ See a letter — tap each speaker to preview sounds, then tap ✓ on the correct one\n④ The reverse of Sound Quiz: see the letter, find the sound!'**
  String get tutorialSoundExplorer;
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
    'en',
    'es',
    'hi',
    'ja',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
