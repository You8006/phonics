import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../services/tts_service.dart';
import '../screens/result_screen.dart';
import 'fill_in_blank_data.dart';

class FillInBlankGame extends StatefulWidget {
  const FillInBlankGame({super.key});

  @override
  State<FillInBlankGame> createState() => _FillInBlankGameState();
}

class _FillInBlankGameState extends State<FillInBlankGame>
    with TickerProviderStateMixin {
  late List<FillInBlankQuestion> _questions;
  int _index = 0;
  String? _selected;
  bool _isCorrect = false;
  bool _hasChecked = false;
  int _correctCount = 0;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _questions = FillInBlankDataManager.generateQuestions(limit: 15);

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeOut));

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8, end: 5), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 5, end: -3), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 20),
    ]).animate(_shakeCtrl);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  FillInBlankQuestion get _q => _questions[_index];

  void _playWord() => TtsService.speakLibraryWord(_q.wordItem.word);
  void _playPhonics(String p) => TtsService.speakPhonicsPattern(p);

  void _check() {
    if (_selected == null) return;
    setState(() {
      _hasChecked = true;
      _isCorrect = _selected == _q.targetPhonics;
    });
    if (_isCorrect) {
      _correctCount++;
      _bounceCtrl.forward(from: 0);
      _playCorrectThenWord();
    } else {
      _shakeCtrl.forward(from: 0);
      TtsService.playWrong();
    }
  }

  Future<void> _playCorrectThenWord() async {
    await TtsService.playCorrect();
    _playWord();
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _hasChecked = false;
        _isCorrect = false;
      });
    } else {
      _showResult();
    }
  }

  void _reset() {
    setState(() {
      _selected = null;
      _hasChecked = false;
      _isCorrect = false;
    });
  }

  void _showResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _correctCount,
          total: _questions.length,
          groupName: 'Fill in Blank',
        ),
      ),
    );
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fill in the Blank')),
        body: const Center(child: Text('問題データがありません')),
      );
    }

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
                '$_correctCount / ${_questions.length}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
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
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _questions.isNotEmpty ? _index / _questions.length : 0,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF5C6BC0)),
                ),
              ),
            ),

            // Word card + play button
            Expanded(
              flex: 4,
              child: FadeInDown(
                key: ValueKey(_index),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Meaning hint
                      Text(
                        _q.wordItem.meaning,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Word puzzle with shake/bounce
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(_shakeAnim.value, 0),
                          child: child,
                        ),
                        child: AnimatedBuilder(
                          animation: _bounceAnim,
                          builder: (context, child) => Transform.scale(
                            scale: _bounceAnim.value,
                            child: child,
                          ),
                          child: _buildWordPuzzle(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Play sound button
                      GestureDetector(
                        onTap: _playWord,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF5C6BC0).withValues(alpha: 0.3),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5C6BC0).withValues(alpha: 0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            size: 30,
                            color: Color(0xFF5C6BC0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Choices + action
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  children: [
                    Text(
                      'どれかな？',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Choice cards
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = _q.choices.length <= 3 ? 1 : 2;
                          final rows = (_q.choices.length / cols).ceil();
                          final totalVSpacing = (rows - 1) * 12;
                          final cellH = (constraints.maxHeight - totalVSpacing) / rows;
                          final totalHSpacing = (cols - 1) * 12;
                          final cellW = (constraints.maxWidth - totalHSpacing) / cols;
                          final ratio = (cellW / cellH).clamp(0.5, 4.0);

                          return GridView.count(
                            crossAxisCount: cols,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: ratio,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _q.choices.asMap().entries.map((e) {
                              return FadeInUp(
                                delay: Duration(milliseconds: 60 * e.key),
                                child: _buildChoiceCard(e.value),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Action button
                    _buildActionButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Word Puzzle ──
  Widget _buildWordPuzzle() {
    final word = _q.wordItem.word.toLowerCase();
    final target = _q.targetPhonics;
    final idx = word.indexOf(target);
    if (idx == -1) {
      return Text(word, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900));
    }

    final prefix = word.substring(0, idx);
    final suffix = word.substring(idx + target.length);
    final children = <Widget>[];

    for (final c in prefix.split('')) {
      children.add(_letterWidget(c));
    }

    if (_hasChecked && _isCorrect) {
      children.add(_phonicsSlot(target, filled: true));
    } else if (_selected != null) {
      children.add(_phonicsSlot(_selected!, filled: false));
    } else {
      children.add(_blankSlot(target.length));
    }

    for (final c in suffix.split('')) {
      children.add(_letterWidget(c));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: children,
      ),
    );
  }

  Widget _letterWidget(String char) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        char,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _phonicsSlot(String text, {required bool filled}) {
    final bg = filled ? const Color(0xFFE8F5E9) : const Color(0xFFE8EAF6);
    final border = filled ? const Color(0xFF4DB6AC) : const Color(0xFF5C6BC0);
    final textColor = filled ? const Color(0xFF2E7D32) : const Color(0xFF5C6BC0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: textColor,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _blankSlot(int length) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2.5),
      ),
      child: Row(
        children: List.generate(
          length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Choice Card ──
  Widget _buildChoiceCard(String phonics) {
    final isSelected = _selected == phonics;
    final isCorrectAnswer = _hasChecked && _isCorrect && phonics == _q.targetPhonics;
    final isWrongAnswer = _hasChecked && !_isCorrect && phonics == _selected;

    Color bg = Colors.white;
    Color textColor = Colors.black87;
    Color borderColor = Colors.grey.shade200;

    if (isSelected && !_hasChecked) {
      bg = const Color(0xFFE8EAF6);
      textColor = const Color(0xFF5C6BC0);
      borderColor = const Color(0xFF5C6BC0);
    }
    if (isCorrectAnswer) {
      bg = const Color(0xFF4DB6AC);
      textColor = Colors.white;
      borderColor = const Color(0xFF4DB6AC);
    }
    if (isWrongAnswer) {
      bg = const Color(0xFFFF5E5E);
      textColor = Colors.white;
      borderColor = const Color(0xFFFF5E5E);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: (_hasChecked && _isCorrect)
              ? null
              : () => setState(() {
                    _selected = phonics;
                    _hasChecked = false;
                  }),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  phonics,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _playPhonics(phonics),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: textColor.withValues(alpha: 0.6),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Action Button ──
  Widget _buildActionButton() {
    final canProceed = _hasChecked && _isCorrect;
    final canCheck = _selected != null && !_hasChecked;
    final canRetry = _hasChecked && !_isCorrect;

    final String label;
    final Color color;
    final VoidCallback? onTap;

    if (canProceed) {
      label = 'つぎへ';
      color = const Color(0xFF5C6BC0);
      onTap = _next;
    } else if (canCheck) {
      label = 'こたえあわせ';
      color = const Color(0xFFFF7043);
      onTap = _check;
    } else if (canRetry) {
      label = 'やりなおす';
      color = const Color(0xFFEF5350);
      onTap = _reset;
    } else {
      label = 'こたえあわせ';
      color = Colors.grey.shade300;
      onTap = null;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          elevation: 2,
        ),
        child: Text(label),
      ),
    );
  }
}

// AnimatedBuilder — lightweight wrapper around AnimatedWidget
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<dynamic> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}
