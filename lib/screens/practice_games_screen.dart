import 'dart:math';
import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(group != null ? '${group!.name} - Practice Lab' : 'Practice Lab'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile(
            title: 'All Sounds Mix (42)',
            subtitle: '全フォニックス音をランダム出題',
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
            title: 'Vowel Sound Focus',
            subtitle: '母音音に絞って練習',
            icon: Icons.music_note,
            color: AppColors.accentPink,
            onTap: () {
              final vowelLike = allPhonicsItems.where((e) {
                final ipa = e.ipa;
                return ipa.contains('æ') ||
                    ipa.contains('ɛ') ||
                    ipa.contains('ɪ') ||
                    ipa.contains('ʌ') ||
                    ipa.contains('ɒ') ||
                    ipa.contains('ɑ') ||
                    ipa.contains('eɪ') ||
                    ipa.contains('aɪ') ||
                    ipa.contains('iː') ||
                    ipa.contains('uː') ||
                    ipa.contains('ʊ') ||
                    ipa.contains('ɔː') ||
                    ipa.contains('aʊ') ||
                    ipa.contains('ɔɪ') ||
                    ipa.contains('ɜː') ||
                    (ipa == 'e');
              }).toList();

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
            title: 'Consonant Sound Focus',
            subtitle: '子音音に絞って練習',
            icon: Icons.graphic_eq,
            color: AppColors.accentCyan,
            onTap: () {
              final consonantLike = allPhonicsItems.where((e) {
                final ipa = e.ipa;
                return !(ipa.contains('æ') ||
                    ipa.contains('ɛ') ||
                    ipa.contains('ɪ') ||
                    ipa.contains('ʌ') ||
                    ipa.contains('ɒ') ||
                    ipa.contains('ɑ') ||
                    ipa.contains('eɪ') ||
                    ipa.contains('aɪ') ||
                    ipa.contains('iː') ||
                    ipa.contains('uː') ||
                    ipa.contains('ʊ') ||
                    ipa.contains('ɔː') ||
                    ipa.contains('aʊ') ||
                    ipa.contains('ɔɪ') ||
                    ipa.contains('ɜː') ||
                    (ipa == 'e'));
              }).toList();

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
            title: 'Blending Builder',
            subtitle: '聞こえた単語を文字を並べて作る（Blending）',
            icon: Icons.extension,
            color: AppColors.accentBlue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlendingBuilderGameScreen(cvcWords: _allWords)),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            title: 'Word Chaining',
            subtitle: '1音だけ変えて次の単語を作る（Word Chaining）',
            icon: Icons.swap_horiz,
            color: AppColors.accentGreen,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WordChainingGameScreen(cvcWords: _allWords)),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            title: 'Minimal Pair Listening',
            subtitle: '似た音を聞き分ける（Minimal Pairs）',
            icon: Icons.hearing,
            color: AppColors.accentPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MinimalPairsGameScreen()),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'ゲームは多く、操作はシンプルにしています。研究ベースの練習法（blending・word chaining・minimal pair）も含みます。',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
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
    return Container(
      decoration: AppDecoration.accentCard(color),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(35),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
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
    // 自動で単語音声を再生
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) TtsService.speakLibraryWord(_answer);
    });
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
    await Future.delayed(const Duration(milliseconds: 800));

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
    return Scaffold(
      appBar: AppBar(title: Text('Blending Builder  $_round / $_totalRounds')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: () => TtsService.speakLibraryWord(_answer),
              icon: const Icon(Icons.volume_up),
              label: const Text('単語を聞く'),
            ),
            const SizedBox(height: 12),
            Card(
              color: _answered
                  ? (_lastCorrect == true ? AppColors.correct.withValues(alpha: 0.12) : AppColors.wrong.withValues(alpha: 0.12))
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('聞こえた単語を作ってね'),
                    const SizedBox(height: 8),
                    Text(
                      _answered && _lastCorrect != true
                          ? _answer.split('').join(' ')
                          : _typed.padRight(_answer.length, '_').split('').join(' '),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _answered
                            ? (_lastCorrect == true ? AppColors.correct : AppColors.wrong)
                            : null,
                      ),
                    ),
                    if (_answered && _lastCorrect == true)
                      const Icon(Icons.check_circle, color: AppColors.correct, size: 32),
                    if (_answered && _lastCorrect != true)
                      Text('→ $_answer', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.correct)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_pool.length, (i) {
                final ch = _pool[i];
                final used = _chipUsed[i];
                return ActionChip(
                  label: Text(ch, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: used ? AppColors.textTertiary : null,
                  )),
                  onPressed: !used && _typed.length < _answer.length && !_answered
                      ? () => setState(() {
                            _typed += ch;
                            _chipUsed[i] = true;
                          })
                      : null,
                );
              }),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _typed.isNotEmpty && !_answered
                        ? () {
                            // 最後に使ったチップを復活
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
                    icon: const Icon(Icons.backspace_outlined),
                    label: const Text('1文字けす'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _typed.isNotEmpty && !_answered
                        ? () => setState(() {
                              _typed = '';
                              _chipUsed.fillRange(0, _chipUsed.length, false);
                            })
                        : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('リセット'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FilledButton(
              onPressed: _typed.length == _answer.length && !_answered ? _check : null,
              child: const Text('Check'),
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
    // 自動で現在の単語を読み上げ
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) TtsService.speakLibraryWord(_currentWord);
    });
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
      // 正解単語を読み上げ
      await TtsService.speakLibraryWord(_answer);
    } else {
      await ProgressService.recordWrong('mini:chain:$_currentWord>$_answer');
      await TtsService.playWrong();
    }

    setState(() => _selected = selected);
    await Future.delayed(const Duration(milliseconds: 800));

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
    return Scaffold(
      appBar: AppBar(title: Text('Word Chaining  $_round / $_totalRounds')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('1音だけ変えて次の単語にしよう'),
                    const SizedBox(height: 10),
                    Text(
                      _currentWord,
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => TtsService.speakLibraryWord(_currentWord),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('音を聞く'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._choices.map(
              (w) {
                Color? bgColor;
                Color? fgColor;
                if (_answered) {
                  if (w == _answer) {
                    bgColor = AppColors.correct;
                    fgColor = Colors.white;
                  } else if (w == _selected) {
                    bgColor = AppColors.wrong;
                    fgColor = Colors.white;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilledButton.tonal(
                    style: bgColor != null
                        ? FilledButton.styleFrom(backgroundColor: bgColor, foregroundColor: fgColor)
                        : null,
                    onPressed: _answered ? null : () => _tapChoice(w),
                    child: Text(w, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
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
    // リスニングゲーム: 自動で音声再生
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) TtsService.speakLibraryWord(_target);
    });
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
      await TtsService.speakLibraryWord(_target);
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
    Color? bgColor;
    Color? fgColor;
    if (_answered) {
      if (word == _target) {
        bgColor = AppColors.correct;
        fgColor = Colors.white;
      } else if (word == _selected) {
        bgColor = AppColors.wrong;
        fgColor = Colors.white;
      }
    }
    return FilledButton.tonal(
      style: bgColor != null
          ? FilledButton.styleFrom(backgroundColor: bgColor, foregroundColor: fgColor)
          : null,
      onPressed: _answered ? null : () => _choose(word),
      child: Text(word, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minimal Pairs  $_round / $_totalRounds')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('音を聞いて、正しい単語を選ぼう'),
                    const SizedBox(height: 6),
                    Text('Focus: ${_pair.focus}', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => TtsService.speakLibraryWord(_target),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Play Sound'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _pairButton(_pair.a),
            const SizedBox(height: 10),
            _pairButton(_pair.b),
          ],
        ),
      ),
    );
  }
}
