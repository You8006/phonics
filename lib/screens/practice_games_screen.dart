import 'dart:math';
import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import 'game_screen.dart';

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
            color: Colors.teal,
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
            color: Colors.pink,
            onTap: () {
              final vowelLike = allPhonicsItems.where((e) {
                final ipa = e.ipa;
                return ipa.contains('æ') ||
                    ipa.contains('ɪ') ||
                    ipa.contains('ʌ') ||
                    ipa.contains('ɒ') ||
                    ipa.contains('eɪ') ||
                    ipa.contains('aɪ') ||
                    ipa.contains('iː') ||
                    ipa.contains('uː') ||
                    ipa.contains('ʊ') ||
                    ipa.contains('ɔː') ||
                    ipa.contains('aʊ') ||
                    ipa.contains('ɔɪ') ||
                    ipa.contains('ɜː');
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
            color: Colors.cyan,
            onTap: () {
              final consonantLike = allPhonicsItems.where((e) {
                final ipa = e.ipa;
                return !(ipa.contains('æ') ||
                    ipa.contains('ɪ') ||
                    ipa.contains('ʌ') ||
                    ipa.contains('ɒ') ||
                    ipa.contains('eɪ') ||
                    ipa.contains('aɪ') ||
                    ipa.contains('iː') ||
                    ipa.contains('uː') ||
                    ipa.contains('ʊ') ||
                    ipa.contains('ɔː') ||
                    ipa.contains('aʊ') ||
                    ipa.contains('ɔɪ') ||
                    ipa.contains('ɜː'));
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
            color: Colors.blue,
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
            color: Colors.green,
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
            color: Colors.deepPurple,
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
                style: TextStyle(color: Colors.grey.shade700),
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
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(35),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
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

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final words = widget.cvcWords.where((w) => w.length >= 3 && w.length <= 5).toList();
    _answer = words[_rng.nextInt(words.length)].toLowerCase();

    final letters = _answer.split('');
    final distractors = 'abcdefghijklmnopqrstuvwxyz'.split('')
      ..shuffle(_rng);
    final addCount = min(2, max(0, 8 - letters.length));
    _pool = [...letters, ...distractors.take(addCount)]..shuffle(_rng);

    _typed = '';
    _answered = false;
    setState(() {});
  }

  Future<void> _check() async {
    if (_answered || _typed.length != _answer.length) return;
    final correct = _typed == _answer;

    await ProgressService.recordAttempt('mini:blend:$_answer');
    if (correct) {
      await ProgressService.recordCorrect('mini:blend:$_answer');
      _score++;
    } else {
      await ProgressService.recordWrong('mini:blend:$_answer');
    }

    setState(() => _answered = true);
    await Future.delayed(const Duration(milliseconds: 650));

    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _MiniResultScreen(title: 'Blending Builder', score: _score, total: _totalRounds),
        ),
      );
      return;
    }

    _round++;
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
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('聞こえた単語を作ってね'),
                    const SizedBox(height: 8),
                    Text(
                      _typed.padRight(_answer.length, '_').split('').join(' '),
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _pool.map((ch) {
                return ActionChip(
                  label: Text(ch, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: _typed.length < _answer.length && !_answered
                      ? () => setState(() => _typed += ch)
                      : null,
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _typed.isNotEmpty && !_answered
                        ? () => setState(() => _typed = _typed.substring(0, _typed.length - 1))
                        : null,
                    icon: const Icon(Icons.backspace_outlined),
                    label: const Text('1文字けす'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _typed.isNotEmpty && !_answered ? () => setState(() => _typed = '') : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('リセット'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FilledButton(
              onPressed: _typed.length == _answer.length ? _check : null,
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

  @override
  void initState() {
    super.initState();
    _nextQuestion();
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
    final pairs = <(String, String)>[];
    for (var i = 0; i < words.length; i++) {
      for (var j = i + 1; j < words.length; j++) {
        if (_dist(words[i], words[j]) == 1) {
          pairs.add((words[i], words[j]));
        }
      }
    }

    if (pairs.isEmpty) {
      // フォールバック
      _currentWord = words.first;
      _answer = words.length > 1 ? words[1] : words.first;
    } else {
      final p = pairs[_rng.nextInt(pairs.length)];
      _currentWord = p.$1;
      _answer = p.$2;
    }

    final distractors = words.where((w) => w != _answer && w != _currentWord).toList()..shuffle(_rng);
    _choices = [_answer, ...distractors.take(2)]..shuffle(_rng);
    _answered = false;
    setState(() {});
  }

  Future<void> _tapChoice(String selected) async {
    if (_answered) return;
    final correct = selected == _answer;

    await ProgressService.recordAttempt('mini:chain:$_currentWord>$_answer');
    if (correct) {
      await ProgressService.recordCorrect('mini:chain:$_currentWord>$_answer');
      _score++;
    } else {
      await ProgressService.recordWrong('mini:chain:$_currentWord>$_answer');
    }

    setState(() => _answered = true);
    await Future.delayed(const Duration(milliseconds: 650));

    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _MiniResultScreen(title: 'Word Chaining', score: _score, total: _totalRounds),
        ),
      );
      return;
    }

    _round++;
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
              (w) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton.tonal(
                  onPressed: _answered ? null : () => _tapChoice(w),
                  child: Text(w, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
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

  @override
  void initState() {
    super.initState();
    _totalRounds = min(12, minimalPairs.length);
    _nextQuestion();
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
    final correct = selected == _target;

    final key = 'mini:minpair:${_pair.a}-${_pair.b}:$_target';
    await ProgressService.recordAttempt(key);
    if (correct) {
      await ProgressService.recordCorrect(key);
      _score++;
    } else {
      await ProgressService.recordWrong(key);
    }

    setState(() => _answered = true);
    await Future.delayed(const Duration(milliseconds: 650));

    if (_round >= _totalRounds) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _MiniResultScreen(title: 'Minimal Pair Listening', score: _score, total: _totalRounds),
        ),
      );
      return;
    }

    _round++;
    _nextQuestion();
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
                    Text('Focus: ${_pair.focus}', style: TextStyle(color: Colors.grey.shade600)),
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
            FilledButton.tonal(
              onPressed: _answered ? null : () => _choose(_pair.a),
              child: Text(_pair.a, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: _answered ? null : () => _choose(_pair.b),
              child: Text(_pair.b, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniResultScreen extends StatelessWidget {
  const _MiniResultScreen({required this.title, required this.score, required this.total});

  final String title;
  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final acc = total == 0 ? 0 : score / total;
    final msg = acc >= 0.9
        ? 'Excellent!'
        : acc >= 0.7
            ? 'Great job!'
            : acc >= 0.5
                ? 'Nice effort!'
                : 'Keep practicing!';

    return Scaffold(
      appBar: AppBar(title: Text('$title Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$score / $total', style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${(acc * 100).toInt()}%', style: TextStyle(fontSize: 22, color: Colors.grey.shade700)),
              const SizedBox(height: 12),
              Text(msg, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.replay),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
