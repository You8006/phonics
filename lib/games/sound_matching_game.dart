import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../screens/result_screen.dart';

class SoundMatchingGame extends StatefulWidget {
  final List<PhonicsItem> items;
  final int numOptions;
  final int maxQuestions;

  const SoundMatchingGame({
    super.key,
    required this.items,
    this.numOptions = 4,
    this.maxQuestions = 10,
  });

  @override
  State<SoundMatchingGame> createState() => _SoundMatchingGameState();
}

class _SoundMatchingGameState extends State<SoundMatchingGame> {
  final _rng = Random();
  late List<PhonicsItem> _queue;
  late PhonicsItem _target;
  List<PhonicsItem> _options = [];
  Map<String, Color?> _feedback = {};
  bool _answered = false;
  int _score = 0;
  int _current = 0;
  late int _total;

  @override
  void initState() {
    super.initState();
    // Build a shuffled queue, repeating items if maxQuestions > items.length
    _queue = <PhonicsItem>[];
    while (_queue.length < widget.maxQuestions) {
      final batch = List<PhonicsItem>.from(widget.items)..shuffle(_rng);
      _queue.addAll(batch);
    }
    _queue = _queue.take(widget.maxQuestions).toList();
    _total = _queue.length;
    _loadQuestion();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  void _loadQuestion() {
    if (_current >= _total) {
      _showResult();
      return;
    }

    setState(() {
      _answered = false;
      _feedback = {};

      _target = _queue[_current];

      final distractors = List<PhonicsItem>.from(widget.items)
        ..removeWhere((item) => item.progressKey == _target.progressKey)
        ..shuffle(_rng);

      _options = [_target, ...distractors.take(widget.numOptions - 1)]
        ..shuffle(_rng);
    });

    Future.delayed(const Duration(milliseconds: 400), _playSound);
  }

  Future<void> _playSound() async {
    await TtsService.speakSound(_target);
  }

  void _handleAnswer(PhonicsItem selected) {
    if (_answered) return;
    _answered = true; // 即座にガードを設定し、二重タップを防止

    final correct = selected.progressKey == _target.progressKey;

    // Record progress
    ProgressService.recordAttempt(_target.progressKey);
    if (correct) {
      ProgressService.recordCorrect(_target.progressKey);
    } else {
      ProgressService.recordWrong(_target.progressKey);
    }

    setState(() {
      if (correct) {
        _feedback[selected.progressKey] = const Color(0xFF4DB6AC);
        _score++;
        TtsService.playCorrect();
      } else {
        _feedback[selected.progressKey] = const Color(0xFFFF5E5E);
        _feedback[_target.progressKey] = const Color(0xFF4DB6AC);
        TtsService.playWrong();
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _current++);
      _loadQuestion();
    });
  }

  void _showResult() {
    ProgressService.updateStreak();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _score,
          total: _total,
          groupName: 'Sound Match',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CloseButton(color: Colors.black54),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_score / $_total',
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _total > 0 ? _current / _total : 0,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      const AlwaysStoppedAnimation(Color(0xFF5C6BC0)),
                ),
              ),
            ),

            // Sound Button
            Expanded(
              flex: 3,
              child: FadeInDown(
                key: ValueKey(_current),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _playSound,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF5C6BC0)
                                    .withValues(alpha: 0.3),
                                width: 8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5C6BC0)
                                    .withValues(alpha: 0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            size: 64,
                            color: Color(0xFF5C6BC0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Listen & Choose',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Options Grid
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = _options.length <= 3 ? 1 : 2;
                    final rows = (_options.length / cols).ceil();
                    final totalVSpacing = (rows - 1) * 14;
                    final cellHeight = (constraints.maxHeight - totalVSpacing) / rows;
                    final totalHSpacing = (cols - 1) * 14;
                    final cellWidth = (constraints.maxWidth - totalHSpacing) / cols;
                    final ratio = (cellWidth / cellHeight).clamp(0.5, 4.0);

                    return GridView.count(
                      crossAxisCount: cols,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: ratio,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _options.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        final color = _feedback[item.progressKey];

                        return FadeInUp(
                          delay: Duration(milliseconds: 80 * idx),
                          child: _OptionCard(
                            label: item.letter,
                            color: color,
                            onTap: () => _handleAnswer(item),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Colors.white;
    final textColor = color != null ? Colors.white : Colors.black87;
    final borderColor = color ?? Colors.grey.shade200;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          if (color == null)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
