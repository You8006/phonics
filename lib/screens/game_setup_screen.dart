import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import 'game_screen.dart';
import '../games/bingo_game.dart';
import '../games/space_ship_game.dart';
import '../games/sound_matching_game.dart';

// ── Game Type Enum ──

enum GameType {
  soundQuiz,
  soundMatch,
  bingo,
  spaceShip,
}

// ── Setup Screen (Reading Bingo-style) ──

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key, required this.gameType});
  final GameType gameType;

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  // ── Sound Selection ──
  final Set<String> _selected = {};

  // ── Settings ──
  int _choices = 3;
  int _questions = 10;
  int _gridSize = 3;
  GameMode _gameMode = GameMode.soundToLetter;

  // ── Categories (computed once) ──
  late final List<PhonicsItem> _vowels = shortVowelItems;
  late final List<PhonicsItem> _cons = consonantItems;
  late final List<PhonicsItem> _digr = digraphItems;

  @override
  void initState() {
    super.initState();
    // すべて選択済みで開始
    for (var item in allPhonicsItems) {
      _selected.add(item.progressKey);
    }
  }

  // ── Helpers ──

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

  Color get _accent {
    switch (widget.gameType) {
      case GameType.soundQuiz:
        return const Color(0xFF118AB2);
      case GameType.soundMatch:
        return const Color(0xFF5C6BC0);
      case GameType.bingo:
        return const Color(0xFFFF8E3C);
      case GameType.spaceShip:
        return const Color(0xFF00ACC1);
    }
  }

  String _title(AppLocalizations l10n) {
    switch (widget.gameType) {
      case GameType.soundQuiz:
        return l10n.gameSoundQuiz;
      case GameType.soundMatch:
        return l10n.gameSoundMatch;
      case GameType.bingo:
        return l10n.gameBingo;
      case GameType.spaceShip:
        return l10n.gameSpaceShip;
    }
  }

  // ── Play ──

  void _play() {
    final items = _items;
    final minNeeded = widget.gameType == GameType.bingo
        ? _gridSize * _gridSize
        : widget.gameType == GameType.soundQuiz
            ? _choices
            : 2;

    if (items.length < minNeeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select at least $minNeeded sounds!'),
          backgroundColor: Colors.red.shade400,
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
          mode: _gameMode,
          maxQuestions: _questions,
        );
      case GameType.soundMatch:
        game = SoundMatchingGame(
          items: items,
          numOptions: _choices.clamp(2, items.length),
          maxQuestions: _questions,
        );
      case GameType.bingo:
        game = BingoGame(items: items, gridSize: _gridSize);
      case GameType.spaceShip:
        game = SpaceShipGame(items: items);
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => game));
  }

  // ══════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _title(l10n),
          style: TextStyle(fontWeight: FontWeight.w900, color: _accent),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: wide ? _wideLayout(l10n) : _narrowLayout(l10n),
    );
  }

  // ── Wide (Tablet / Web) ──

  Widget _wideLayout(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _soundSelection(l10n),
          ),
        ),
        Container(width: 1, color: Colors.grey.shade200),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _settingsSection(l10n),
                const SizedBox(height: 40),
                _playButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Narrow (Phone) ──

  Widget _narrowLayout(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _soundSelection(l10n),
          const SizedBox(height: 28),
          _settingsSection(l10n),
          const SizedBox(height: 36),
          _playButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  SOUND SELECTION
  // ══════════════════════════════════════════

  Widget _soundSelection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categoryChips(l10n.shortVowels, _vowels, const Color(0xFFFF8E3C)),
        const SizedBox(height: 20),
        _categoryChips(l10n.basicConsonants, _cons, const Color(0xFF4DB6AC)),
        const SizedBox(height: 20),
        _categoryChips(l10n.digraphsLabel, _digr, const Color(0xFF66BB6A)),
      ],
    );
  }

  Widget _categoryChips(String title, List<PhonicsItem> items, Color color) {
    final allSelected = _allSel(items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header + All Button ──
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _toggleAll(items),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: allSelected ? color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: allSelected ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Chips ──
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((item) {
            final sel = _selected.contains(item.progressKey);
            return GestureDetector(
              onTap: () {
                _toggle(item);
                if (!sel) TtsService.speakSound(item); // 選択時に再生
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 54,
                height: 48,
                decoration: BoxDecoration(
                  color: sel ? color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.letter,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: sel ? Colors.white : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  SETTINGS
  // ══════════════════════════════════════════

  Widget _settingsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsLabel,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),

        // ── Sound Quiz settings ──
        if (widget.gameType == GameType.soundQuiz) ...[
          _optionRow(l10n.modeLabel, [
            _Opt('🔊→🔤', GameMode.soundToLetter),
            _Opt('🔤→🔊', GameMode.letterToSound),
            _Opt('IPA', GameMode.ipaToLetter),
          ], _gameMode, (v) => setState(() => _gameMode = v as GameMode)),
          const SizedBox(height: 16),
          _optionRow(l10n.choicesLabel, [
            _Opt('2', 2),
            _Opt('3', 3),
            _Opt('4', 4),
          ], _choices, (v) => setState(() => _choices = v as int)),
          const SizedBox(height: 16),
          _optionRow(l10n.questionsLabel, [
            _Opt('5', 5),
            _Opt('10', 10),
            _Opt('15', 15),
            _Opt('20', 20),
          ], _questions, (v) => setState(() => _questions = v as int)),
        ],

        // ── Sound Match settings ──
        if (widget.gameType == GameType.soundMatch) ...[
          _optionRow(l10n.choicesLabel, [
            _Opt('3', 3),
            _Opt('4', 4),
            _Opt('5', 5),
          ], _choices, (v) => setState(() => _choices = v as int)),
          const SizedBox(height: 16),
          _optionRow(l10n.questionsLabel, [
            _Opt('5', 5),
            _Opt('10', 10),
            _Opt('15', 15),
          ], _questions, (v) => setState(() => _questions = v as int)),
        ],

        // ── Bingo settings ──
        if (widget.gameType == GameType.bingo) ...[
          _optionRow(l10n.gridSizeLabel, [
            _Opt('3 x 3', 3),
            _Opt('4 x 4', 4),
            _Opt('5 x 5', 5),
          ], _gridSize, (v) => setState(() => _gridSize = v as int)),
        ],

        // ── SpaceShip (no extra settings) ──
        if (widget.gameType == GameType.spaceShip) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.selectSoundsHint,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Selected Count ──
        const SizedBox(height: 20),
        Center(
          child: Text(
            '${_items.length} / ${allPhonicsItems.length}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionRow(
    String label,
    List<_Opt> options,
    dynamic current,
    ValueChanged<dynamic> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _accent,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final sel = o.value == current;
            return GestureDetector(
              onTap: () => onChanged(o.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? _accent : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? _accent : Colors.grey.shade300,
                    width: sel ? 2 : 1,
                  ),
                ),
                child: Text(
                  o.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: sel ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  PLAY BUTTON
  // ══════════════════════════════════════════

  Widget _playButton() {
    return FadeInUp(
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed: _play,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5A623),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            shadowColor: const Color(0xFFF5A623).withValues(alpha: 0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'play',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              SizedBox(width: 8),
              Icon(Icons.play_arrow_rounded, size: 36),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper class ──

class _Opt {
  final String label;
  final dynamic value;
  const _Opt(this.label, this.value);
}
