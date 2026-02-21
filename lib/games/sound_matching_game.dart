import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../screens/result_screen.dart';
import '../theme/app_theme.dart';

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
  bool _waitingForNext = false;
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

      // 同じ letter / 同じ ipa のアイテムを除外（oo/oo, th/th, ou/ow 等の重複防止）
      final distractors = List<PhonicsItem>.from(widget.items)
        ..removeWhere((item) =>
            item.progressKey == _target.progressKey ||
            item.letter == _target.letter ||
            item.ipa == _target.ipa)
        ..shuffle(_rng);

      final uniqueDistractors = <PhonicsItem>[];
      final usedLetters = <String>{_target.letter};
      final usedIpas = <String>{_target.ipa};
      for (final item in distractors) {
        if (uniqueDistractors.length >= widget.numOptions - 1) break;
        if (!usedLetters.contains(item.letter) && !usedIpas.contains(item.ipa)) {
          uniqueDistractors.add(item);
          usedLetters.add(item.letter);
          usedIpas.add(item.ipa);
        }
      }

      _options = [_target, ...uniqueDistractors]
        ..shuffle(_rng);
    });

    Future.delayed(const Duration(milliseconds: 400), _playSound);
  }

  Future<void> _playSound() async {
    await TtsService.speakSound(_target);
  }

  Future<void> _handleAnswer(PhonicsItem selected) async {
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
        _feedback[selected.progressKey] = AppColors.correct;
        _score++;
      } else {
        _feedback[selected.progressKey] = AppColors.wrong;
        _feedback[_target.progressKey] = AppColors.correct;
      }
    });

    if (correct) {
      await TtsService.playCorrect();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _current++);
      _loadQuestion();
    } else {
      await TtsService.playWrong();
      if (!mounted) return;
      setState(() => _waitingForNext = true);
    }
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const CloseButton(color: AppColors.textSecondary),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_score / $_total',
                style: const TextStyle(
                    color: AppColors.textPrimary,
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
                  backgroundColor: AppColors.surfaceDim,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.accentIndigo),
                ),
              ),
            ),

            // Sound Button
            Expanded(
              flex: 3,
              child: Center(
                key: ValueKey(_current),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _playSound,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.accentIndigo
                                    .withValues(alpha: 0.3),
                                width: 4),
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            size: 44,
                            color: AppColors.accentIndigo,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.listenAndChoose,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ),
            ),

            // Options Grid
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    if (_waitingForNext)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _waitingForNext = false;
                                _current++;
                              });
                              _loadQuestion();
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: Text(l10n.next),
                          ),
                        ),
                      ),
                    Expanded(
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
                              final item = entry.value;
                              final color = _feedback[item.progressKey];
                              return _OptionCard(
                                label: item.letter,
                                color: color,
                                onTap: () => _handleAnswer(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
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
    final bg = color ?? AppColors.surface;
    final textColor = color != null ? AppColors.onPrimary : AppColors.textPrimary;
    final borderColor = color ?? AppColors.surfaceDim;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
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
