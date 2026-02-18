import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import '../games/bingo_game.dart';
import 'practice_games_screen.dart';

// ── Game Type Enum ──

enum GameType {
  soundQuiz,
  ipaQuiz,
  bingo,
  blending,
  wordChaining,
  minimalPairs,
  fillInBlank,
}

// ── Setup Screen ──

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key, required this.gameType});
  final GameType gameType;

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final Set<String> _selected = {};

  int _choices = 3;
  int _questions = 10;
  int _gridSize = 3;

  late final List<PhonicsItem> _vowels = shortVowelItems;
  late final List<PhonicsItem> _cons = consonantItems;
  late final List<PhonicsItem> _digr = digraphItems;

  static const _gameAccents = {
    GameType.soundQuiz: AppColors.accentBlue,
    GameType.ipaQuiz: AppColors.accentIndigo,
    GameType.bingo: AppColors.primary,
    GameType.blending: AppColors.accentTeal,
    GameType.wordChaining: AppColors.accentGreen,
    GameType.minimalPairs: AppColors.accentPurple,
    GameType.fillInBlank: AppColors.accentPink,
  };

  @override
  void initState() {
    super.initState();
    for (var item in allPhonicsItems) {
      _selected.add(item.progressKey);
    }
  }

  List<PhonicsItem> get _items =>
      allPhonicsItems.where((i) => _selected.contains(i.progressKey)).toList();

  bool _allSel(List<PhonicsItem> cat) =>
      cat.every((i) => _selected.contains(i.progressKey));

  void _toggleAll(List<PhonicsItem> cat) {
    setState(() {
      if (_allSel(cat)) {
        for (var i in cat) {
          _selected.remove(i.progressKey);
        }
      } else {
        for (var i in cat) {
          _selected.add(i.progressKey);
        }
      }
    });
  }

  void _toggle(PhonicsItem item) {
    setState(() {
      final k = item.progressKey;
      _selected.contains(k) ? _selected.remove(k) : _selected.add(k);
    });
  }

  Color get _accent => _gameAccents[widget.gameType] ?? AppColors.primary;

  String _title(AppLocalizations l10n) {
    switch (widget.gameType) {
      case GameType.soundQuiz: return l10n.gameSoundQuiz;
      case GameType.ipaQuiz: return l10n.gameIpaQuiz;
      case GameType.bingo: return l10n.gameBingo;
      case GameType.blending: return l10n.gameBlending;
      case GameType.wordChaining: return l10n.gameWordChaining;
      case GameType.minimalPairs: return l10n.gameMinimalPairs;
      case GameType.fillInBlank: return l10n.gameFillInBlank;
    }
  }

  void _play() {
    final items = _items;

    if (widget.gameType == GameType.blending) {
      final allWords = wordLibrary.map((w) => w.word.toLowerCase()).toSet().toList();
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => BlendingBuilderGameScreen(cvcWords: allWords),
      ));
      return;
    }
    if (widget.gameType == GameType.wordChaining) {
      final allWords = wordLibrary.map((w) => w.word.toLowerCase()).toSet().toList();
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => WordChainingGameScreen(cvcWords: allWords),
      ));
      return;
    }
    if (widget.gameType == GameType.minimalPairs) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const MinimalPairsGameScreen(),
      ));
      return;
    }

    final minNeeded = widget.gameType == GameType.bingo
        ? _gridSize * _gridSize
        : _choices;

    if (items.length < minNeeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select at least $minNeeded sounds!'),
          backgroundColor: AppColors.wrong,
        ),
      );
      return;
    }

    final Widget game;
    switch (widget.gameType) {
      case GameType.soundQuiz:
        game = GameScreen(
          items: items,
          numOptions: _choices.clamp(2, items.length),
          groupName: 'Sound Quiz',
          mode: GameMode.soundToLetter,
          maxQuestions: _questions,
        );
      case GameType.ipaQuiz:
        game = GameScreen(
          items: items,
          numOptions: _choices.clamp(2, items.length),
          groupName: 'IPA Quiz',
          mode: GameMode.soundToIpa,
          maxQuestions: _questions,
        );
      case GameType.bingo:
        game = BingoGame(items: items, gridSize: _gridSize);
      case GameType.blending:
      case GameType.wordChaining:
      case GameType.minimalPairs:
      case GameType.fillInBlank:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => game));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(l10n),
            style: TextStyle(fontWeight: FontWeight.w800, color: _accent)),
      ),
      body: _isSimpleGame
          ? _simpleLayout(l10n)
          : (wide ? _wideLayout(l10n) : _narrowLayout(l10n)),
    );
  }

  bool get _isSimpleGame =>
      widget.gameType == GameType.blending ||
      widget.gameType == GameType.wordChaining ||
      widget.gameType == GameType.minimalPairs;

  Widget _simpleLayout(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.gameType == GameType.blending
                  ? Icons.extension_rounded
                  : widget.gameType == GameType.wordChaining
                      ? Icons.swap_horiz_rounded
                      : Icons.hearing_rounded,
              size: 64,
              color: _accent.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              _title(l10n),
              style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w900, color: _accent),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.gameType == GameType.blending
                  ? l10n.gameBlendingDesc
                  : widget.gameType == GameType.wordChaining
                      ? l10n.gameWordChainingDesc
                      : l10n.gameMinimalPairsDesc,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            _playButton(),
          ],
        ),
      ),
    );
  }

  Widget _wideLayout(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: _soundSelection(l10n),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              children: [
                _settingsSection(l10n),
                const SizedBox(height: AppSpacing.xxxl),
                _playButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _narrowLayout(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _soundSelection(l10n),
          const SizedBox(height: AppSpacing.xxl),
          _settingsSection(l10n),
          const SizedBox(height: AppSpacing.xxxl),
          _playButton(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // ── Sound Selection ──

  Widget _soundSelection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categoryChips(l10n.shortVowels, _vowels, AppColors.primary),
        const SizedBox(height: AppSpacing.xl),
        _categoryChips(l10n.basicConsonants, _cons, AppColors.accentTeal),
        const SizedBox(height: AppSpacing.xl),
        _categoryChips(l10n.digraphsLabel, _digr, AppColors.accentGreen),
      ],
    );
  }

  Widget _categoryChips(String title, List<PhonicsItem> items, Color color) {
    final allSelected = _allSel(items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyle.cardTitle),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _toggleAll(items),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: allSelected ? color : AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text('All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: allSelected ? Colors.white : AppColors.textTertiary,
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((item) {
            final sel = _selected.contains(item.progressKey);
            return GestureDetector(
              onTap: () {
                _toggle(item);
                if (!sel) TtsService.speakSound(item);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 44,
                decoration: BoxDecoration(
                  color: sel ? color : AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.letter,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : AppColors.textTertiary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Settings ──

  Widget _settingsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsLabel,
            style: AppTextStyle.sectionHeading),
        const SizedBox(height: AppSpacing.lg),

        if (widget.gameType == GameType.soundQuiz ||
            widget.gameType == GameType.ipaQuiz) ...[          _optionRow(l10n.choicesLabel, [
            _Opt('2', 2), _Opt('3', 3), _Opt('4', 4),
          ], _choices, (v) => setState(() => _choices = v as int)),
          const SizedBox(height: AppSpacing.lg),
          _optionRow(l10n.questionsLabel, [
            _Opt('5', 5), _Opt('10', 10), _Opt('15', 15), _Opt('20', 20),
          ], _questions, (v) => setState(() => _questions = v as int)),
        ],

        if (widget.gameType == GameType.bingo)
          _optionRow(l10n.gridSizeLabel, [
            _Opt('3 x 3', 3), _Opt('4 x 4', 4), _Opt('5 x 5', 5),
          ], _gridSize, (v) => setState(() => _gridSize = v as int)),

        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Text(
            '${_items.length} / ${allPhonicsItems.length}',
            style: AppTextStyle.label.copyWith(color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }

  Widget _optionRow(String label, List<_Opt> options, dynamic current,
      ValueChanged<dynamic> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: _accent)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final sel = o.value == current;
            return GestureDetector(
              onTap: () => onChanged(o.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? _accent : AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: sel ? _accent : AppColors.surfaceDim,
                    width: sel ? AppBorder.selected : AppBorder.thin,
                  ),
                ),
                child: Text(
                  o.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _playButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _play,
        icon: const Icon(Icons.play_arrow_rounded, size: 28),
        label: const Text('Play',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _Opt {
  final String label;
  final dynamic value;
  const _Opt(this.label, this.value);
}
