import 'dart:math';
import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../models/sound_group_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'package:phonics/l10n/app_localizations.dart';
import 'game_screen.dart';
import 'result_screen.dart';

class PracticeGamesScreen extends StatelessWidget {
  const PracticeGamesScreen({super.key, this.group});

  final PhonicsGroup? group;

  /// wordLibrary から全単語を取得（Blending/WordChaining用）
  List<String> get _allWords {
    if (group != null) return group!.cvcWords;
    return wordLibrary.map((w) => w.word.toLowerCase()).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(group != null ? l10n.practiceLabTitle(group!.name) : l10n.practiceLabTitleDefault),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Tile(
            title: l10n.allSoundsMix,
            subtitle: l10n.practiceAllSounds,
            icon: Icons.shuffle,
            color: AppColors.accentTeal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(
                  items: allPhonicsItems,
                  numOptions: 4,
                  groupName: 'All Sounds Mix',
                  mode: GameMode.soundToLetter,
                  maxQuestions: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            title: l10n.vowelSoundFocus,
            subtitle: l10n.focusOnVowels,
            icon: Icons.music_note,
            color: AppColors.accentPink,
            onTap: () {
              final vowelLike = allPhonicsItems
                  .where((e) => isVowelIpa(e.ipa))
                  .toList();

              if (vowelLike.length >= 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      items: vowelLike,
                      numOptions: 4,
                      groupName: 'Vowel Focus',
                      mode: GameMode.soundToLetter,
                      maxQuestions: 12,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _Tile(
            title: l10n.consonantSoundFocus,
            subtitle: l10n.focusOnConsonants,
            icon: Icons.graphic_eq,
            color: AppColors.accentCyan,
            onTap: () {
              final consonantLike = allPhonicsItems
                  .where((e) => !isVowelIpa(e.ipa))
                  .toList();

              if (consonantLike.length >= 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      items: consonantLike,
                      numOptions: 4,
                      groupName: 'Consonant Focus',
                      mode: GameMode.soundToLetter,
                      maxQuestions: 12,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _Tile(
            title: l10n.blendingBuilder,
            subtitle: l10n.buildWordsByArranging,
            icon: Icons.extension,
            color: AppColors.accentBlue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlendingBuilderGameScreen(cvcWords: _allWords)),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            title: l10n.wordChainingTitle,
            subtitle: l10n.changeOneSoundNewWord,
            icon: Icons.swap_horiz,
            color: AppColors.accentGreen,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WordChainingGameScreen(cvcWords: _allWords)),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            title: l10n.minimalPairListening,
            subtitle: l10n.distinguishSounds,
            icon: Icons.hearing,
            color: AppColors.accentPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MinimalPairsGameScreen()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: AppDecoration.accentCard(color),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyle.cardTitle),
                      const SizedBox(height: 3),
                      Text(subtitle, style: AppTextStyle.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlendingBuilderGameScreen extends StatefulWidget {
  const BlendingBuilderGameScreen({super.key, required this.cvcWords});

  final List<String> cvcWords;

  @override
  State<BlendingBuilderGameScreen> createState() => _BlendingBuilderGameScreenState();
}

class _BlendingBuilderGameScreenState extends State<BlendingBuilderGameScreen> {
  final _rng = Random();
  static const _totalRounds = 8;

  late String _answer;
  late List<String> _pool;
  String _typed = '';
  int _round = 1;
  int _score = 0;
  bool _answered = false;
  bool? _lastCorrect;
  final Set<String> _usedWords = {};
  final List<bool> _chipUsed = [];

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  void _nextQuestion() {
    final words = widget.cvcWords.where((w) => w.length >= 3 && w.length <= 5).toList();
    if (words.isEmpty) {
      // 単語がない場合は即終了
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(score: _score, total: max(1, _round - 1), groupName: 'Blending Builder'),
          ),
        );
      });
      return;
    }
    // 出題済み単語を避ける
    final unused = words.where((w) => !_usedWords.contains(w.toLowerCase())).toList();
    final candidates = unused.isNotEmpty ? unused : words;
    _answer = candidates[_rng.nextInt(candidates.length)].toLowerCase();
    _usedWords.add(_answer);

    final letters = _answer.split('');
    final distractors = 'abcdefghijklmnopqrstuvwxyz'.split('')
      ..removeWhere((c) => letters.contains(c))
      ..shuffle(_rng);
    final addCount = min(2, max(0, 8 - letters.length));
    _pool = [...letters, ...distractors.take(addCount)]..shuffle(_rng);
    _chipUsed
      ..clear()
      ..addAll(List.filled(_pool.length, false));

    _typed = '';
    _answered = false;
    _lastCorrect = null;
    setState(() {});
  }

  Future<void> _check() async {
    if (_answered || _typed.length != _answer.length) return;
    _answered = true; // ダブルタップ防止: await前に即座にセット
    final correct = _typed == _answer;

    await ProgressService.recordAttempt('mini:blend:$_answer');
    if (correct) {
      await ProgressService.recordCorrect('mini:blend:$_answer');
      _score++;
      await TtsService.playCorrect();
    } else {
      await ProgressService.recordWrong('mini:blend:$_answer');
      await TtsService.playWrong();
    }

    setState(() => _lastCorrect = correct);
  }

  void _goNext() {
    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _totalRounds, groupName: 'Blending Builder'),
        ),
      );
      return;
    }

    _round++;
    if (!mounted) return;
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.blendingRound(_round, _totalRounds))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Play buttons
            Row(
              children: [
                Expanded(
                  child: _PlayButton(
                    icon: Icons.slow_motion_video,
                    label: l10n.slow,
                    color: AppColors.accentBlue,
                    onTap: () => TtsService.speakLibraryWordSlow(_answer),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PlayButton(
                    icon: Icons.play_arrow_rounded,
                    label: l10n.normal,
                    color: AppColors.accentBlue,
                    onTap: () => TtsService.speakLibraryWordNormal(_answer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Word display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _answered
                    ? (_lastCorrect == true
                        ? AppColors.correct.withValues(alpha: 0.08)
                        : AppColors.wrong.withValues(alpha: 0.08))
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.surfaceDim),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.buildWordYouHear,
                    style: AppTextStyle.caption,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _answered && _lastCorrect != true
                        ? _answer.split('').join(' ')
                        : _typed.padRight(_answer.length, '_').split('').join(' '),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: _answered
                          ? (_lastCorrect == true ? AppColors.correct : AppColors.wrong)
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (_answered && _lastCorrect == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Icon(Icons.check_rounded, color: AppColors.correct, size: 28),
                    ),
                  if (_answered && _lastCorrect != true)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_answer, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.correct)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Letter chips
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: List.generate(_pool.length, (i) {
                final ch = _pool[i];
                final used = _chipUsed[i];
                return GestureDetector(
                  onTap: !used && _typed.length < _answer.length && !_answered
                      ? () => setState(() {
                            _typed += ch;
                            _chipUsed[i] = true;
                          })
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: used ? AppColors.surfaceDim : AppColors.accentBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: used ? AppColors.surfaceDim : AppColors.accentBlue.withValues(alpha: 0.2),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      ch,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: used ? AppColors.textTertiary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            // Undo / Reset
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _typed.isNotEmpty && !_answered
                        ? () {
                            final lastChar = _typed[_typed.length - 1];
                            for (var j = _pool.length - 1; j >= 0; j--) {
                              if (_pool[j] == lastChar && _chipUsed[j]) {
                                _chipUsed[j] = false;
                                break;
                              }
                            }
                            setState(() => _typed = _typed.substring(0, _typed.length - 1));
                          }
                        : null,
                    child: Text(l10n.undo),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _typed.isNotEmpty && !_answered
                        ? () => setState(() {
                              _typed = '';
                              _chipUsed.fillRange(0, _chipUsed.length, false);
                            })
                        : null,
                    child: Text(l10n.reset),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (!_answered)
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _typed.length == _answer.length ? _check : null,
                  child: Text(l10n.check),
                ),
              ),
            if (_answered)
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.next,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WordChainingGameScreen extends StatefulWidget {
  const WordChainingGameScreen({super.key, required this.cvcWords});

  final List<String> cvcWords;

  @override
  State<WordChainingGameScreen> createState() => _WordChainingGameScreenState();
}

class _WordChainingGameScreenState extends State<WordChainingGameScreen> {
  final _rng = Random();
  static const _totalRounds = 8;

  late String _currentWord;
  late String _answer;
  List<String> _choices = [];
  int _round = 1;
  int _score = 0;
  bool _answered = false;
  String? _selected;
  final Set<String> _usedPairs = {};

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  int _dist(String a, String b) {
    if (a.length != b.length) return 99;
    var d = 0;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) d++;
    }
    return d;
  }

  void _nextQuestion() {
    final words = widget.cvcWords.where((w) => w.length >= 3 && w.length <= 4).map((e) => e.toLowerCase()).toSet().toList();

    // 1音差ペアを作る
    final allPairs = <(String, String)>[];
    for (var i = 0; i < words.length; i++) {
      for (var j = i + 1; j < words.length; j++) {
        if (_dist(words[i], words[j]) == 1) {
          allPairs.add((words[i], words[j]));
        }
      }
    }

    // 未使用ペアを優先
    final unusedPairs = allPairs.where((p) {
      final key = '${p.$1}>${p.$2}';
      final keyRev = '${p.$2}>${p.$1}';
      return !_usedPairs.contains(key) && !_usedPairs.contains(keyRev);
    }).toList();
    final pairs = unusedPairs.isNotEmpty ? unusedPairs : allPairs;

    if (pairs.isEmpty) {
      // ペアが見つからない場合はゲームを終了
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _round - 1, groupName: 'Word Chaining'),
        ),
      );
      return;
    }

    final p = pairs[_rng.nextInt(pairs.length)];
    // ランダムで方向を決める
    if (_rng.nextBool()) {
      _currentWord = p.$1;
      _answer = p.$2;
    } else {
      _currentWord = p.$2;
      _answer = p.$1;
    }
    _usedPairs.add('$_currentWord>$_answer');

    // ディストラクタ: 正解ではなく、かつ currentWordから1音差でない単語を選ぶ
    final distractors = words.where((w) {
      if (w == _answer || w == _currentWord) return false;
      // currentWordとの編集距離が1の単語は選択肢から除外
      return _dist(w, _currentWord) != 1;
    }).toList()..shuffle(_rng);
    _choices = [_answer, ...distractors.take(2)]..shuffle(_rng);
    _answered = false;
    setState(() {});
  }

  Future<void> _tapChoice(String selected) async {
    if (_answered) return;
    _answered = true; // ダブルタップ防止: await前に即座にセット
    final correct = selected == _answer;

    await ProgressService.recordAttempt('mini:chain:$_currentWord>$_answer');
    if (correct) {
      await ProgressService.recordCorrect('mini:chain:$_currentWord>$_answer');
      _score++;
      await TtsService.playCorrect();
    } else {
      await ProgressService.recordWrong('mini:chain:$_currentWord>$_answer');
      await TtsService.playWrong();
    }

    setState(() => _selected = selected);
  }

  void _goNext() {
    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _totalRounds, groupName: 'Word Chaining'),
        ),
      );
      return;
    }

    _round++;
    if (!mounted) return;
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.wordChainingRound(_round, _totalRounds))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current word display
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.surfaceDim),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.changeOneSound,
                    style: AppTextStyle.caption,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentWord,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PlayButton(
                        icon: Icons.slow_motion_video,
                        label: l10n.slow,
                        color: AppColors.accentGreen,
                        onTap: () => TtsService.speakLibraryWordSlow(_currentWord),
                        compact: true,
                      ),
                      const SizedBox(width: 8),
                      _PlayButton(
                        icon: Icons.play_arrow_rounded,
                        label: l10n.normal,
                        color: AppColors.accentGreen,
                        onTap: () => TtsService.speakLibraryWordNormal(_currentWord),
                        compact: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Choices
            ..._choices.map(
              (w) {
                Color bg = AppColors.surface;
                Color textColor = AppColors.textPrimary;
                Color borderColor = AppColors.surfaceDim;
                if (_answered) {
                  if (w == _answer) {
                    bg = AppColors.correct;
                    textColor = AppColors.onPrimary;
                    borderColor = AppColors.correct;
                  } else if (w == _selected) {
                    bg = AppColors.wrong;
                    textColor = AppColors.onPrimary;
                    borderColor = AppColors.wrong;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: _answered
                        ? () => TtsService.speakLibraryWordNormal(w)
                        : () => _tapChoice(w),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: borderColor, width: AppBorder.normal),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_answered)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.volume_up, size: 20, color: textColor),
                            ),
                          Text(
                            w,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Next button (shown after answering)
            if (_answered) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  l10n.next,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MinimalPairsGameScreen extends StatefulWidget {
  const MinimalPairsGameScreen({super.key});

  @override
  State<MinimalPairsGameScreen> createState() => _MinimalPairsGameScreenState();
}

class _MinimalPairsGameScreenState extends State<MinimalPairsGameScreen> {
  final _rng = Random();
  late final int _totalRounds;
  final Set<int> _usedIndices = {};

  late MinimalPair _pair;
  late String _target;
  int _round = 1;
  int _score = 0;
  bool _answered = false;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _totalRounds = min(12, minimalPairs.length);
    _nextQuestion();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  void _nextQuestion() {
    // 重複しないように未出題のペアを選ぶ
    if (_usedIndices.length >= minimalPairs.length) _usedIndices.clear();
    int idx;
    do {
      idx = _rng.nextInt(minimalPairs.length);
    } while (_usedIndices.contains(idx));
    _usedIndices.add(idx);
    _pair = minimalPairs[idx];
    _target = _rng.nextBool() ? _pair.a : _pair.b;
    _answered = false;
    setState(() {});
  }

  Future<void> _choose(String selected) async {
    if (_answered) return;
    _answered = true; // ダブルタップ防止: await前に即座にセット
    final correct = selected == _target;

    final key = 'mini:minpair:${_pair.a}-${_pair.b}:$_target';
    await ProgressService.recordAttempt(key);
    if (correct) {
      await ProgressService.recordCorrect(key);
      _score++;
      await TtsService.playCorrect();
    } else {
      await ProgressService.recordWrong(key);
      await TtsService.playWrong();
      // 不正解後に正解の単語を再生
      await TtsService.speakLibraryWordNormal(_target);
    }

    setState(() => _selected = selected);
    await Future.delayed(const Duration(milliseconds: 800));

    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _totalRounds, groupName: 'Minimal Pairs'),
        ),
      );
      return;
    }

    _round++;
    if (!mounted) return;
    _nextQuestion();
  }

  Widget _pairButton(String word) {
    Color bg = AppColors.surface;
    Color textColor = AppColors.textPrimary;
    Color borderColor = AppColors.surfaceDim;
    if (_answered) {
      if (word == _target) {
        bg = AppColors.correct;
        textColor = AppColors.onPrimary;
        borderColor = AppColors.correct;
      } else if (word == _selected) {
        bg = AppColors.wrong;
        textColor = AppColors.onPrimary;
        borderColor = AppColors.wrong;
      }
    }
    return GestureDetector(
      onTap: _answered ? null : () => _choose(word),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          word,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.minimalPairsRound(_round, _totalRounds))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prompt
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.surfaceDim),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.whichWordDoYouHear,
                    style: AppTextStyle.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.focusOn(_pair.focus),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PlayButton(
                        icon: Icons.slow_motion_video,
                        label: l10n.slow,
                        color: AppColors.accentPurple,
                        onTap: () => TtsService.speakLibraryWordSlow(_target),
                        compact: true,
                      ),
                      const SizedBox(width: 8),
                      _PlayButton(
                        icon: Icons.play_arrow_rounded,
                        label: l10n.normal,
                        color: AppColors.accentPurple,
                        onTap: () => TtsService.speakLibraryWordNormal(_target),
                        compact: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Choice buttons
            _pairButton(_pair.a),
            const SizedBox(height: 8),
            _pairButton(_pair.b),
          ],
        ),
      ),
    );
  }
}

// ── Shared play button widget ──

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 16,
          vertical: compact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 18 : 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
