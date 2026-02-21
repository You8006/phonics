import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../services/tts_service.dart';
import '../screens/result_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/score_app_bar.dart';
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
    TtsService.stop();
    _bounceCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  FillInBlankQuestion get _q => _questions[_index];

  void _playWordSlow() => TtsService.speakLibraryWordSlow(_q.wordItem.word);
  void _playWordNormal() => TtsService.speakLibraryWordNormal(_q.wordItem.word);
  void _playPhonics(String p) => TtsService.speakPhonicsPattern(p);

  bool _attemptRecorded = false; // 同じ問題のリトライ時に二重記録しない

  Future<void> _check() async {
    if (_selected == null) return;
    setState(() {
      _hasChecked = true;
      _isCorrect = _selected == _q.targetPhonics;
    });
    // 進捗記録（初回のみ）
    final isFirstAttempt = !_attemptRecorded;
    if (!_attemptRecorded) {
      _attemptRecorded = true;
      ProgressService.recordAttempt('fill:${_q.wordItem.word}:${_q.targetPhonics}');
      if (_isCorrect) {
        ProgressService.recordCorrect('fill:${_q.wordItem.word}:${_q.targetPhonics}');
      } else {
        ProgressService.recordWrong('fill:${_q.wordItem.word}:${_q.targetPhonics}');
      }
    }
    if (_isCorrect) {
      if (isFirstAttempt) _correctCount++; // 初回正解のみスコア加算
      _bounceCtrl.forward(from: 0);
      _playCorrectThenWord();
    } else {
      _shakeCtrl.forward(from: 0);
      await TtsService.playWrong();
    }
  }

  Future<void> _playCorrectThenWord() async {
    await TtsService.playCorrect();
    _playWordNormal();
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _hasChecked = false;
        _isCorrect = false;
        _attemptRecorded = false;
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
    final l10n = AppLocalizations.of(context)!;

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.fillInBlankTitle)),
        body: Center(child: Text(l10n.noQuestionsAvailable)),
      );
    }

    return Scaffold(
      appBar: scoreAppBar('$_correctCount / ${_questions.length}'),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _questions.isNotEmpty ? _index / _questions.length : 0,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceDim,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accentIndigo),
                ),
              ),
            ),

            // Word card + play button
            Expanded(
              flex: 4,
              child: Center(
                key: ValueKey(_index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Meaning hint
                      Text(
                        _q.wordItem.meaning,
                        style: AppTextStyle.label.copyWith(color: AppColors.textTertiary),
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
                      // Play sound buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _playWordSlow,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.accentIndigo.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: const Icon(
                                Icons.slow_motion_video,
                                size: 22,
                                color: AppColors.accentIndigo,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _playWordNormal,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.accentIndigo.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                size: 26,
                                color: AppColors.accentIndigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            ),

            // Choices + action
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      l10n.chooseCorrectSpelling,
                      style: AppTextStyle.label.copyWith(color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 12),
                    // Choice cards
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final count = _q.choices.length;
                          final cols = count <= 2 ? 1 : 2;
                          final rows = (count / cols).ceil();
                          final totalVSpacing = (rows - 1) * 12;
                          final cellH = (constraints.maxHeight - totalVSpacing) / rows;
                          final totalHSpacing = (cols - 1) * 12;
                          final cellW = (constraints.maxWidth - totalHSpacing) / cols;
                          final ratio = cellW / cellH.clamp(1.0, double.infinity);

                          return GridView.count(
                            crossAxisCount: cols,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: ratio.clamp(0.5, double.infinity),
                            physics: const NeverScrollableScrollPhysics(),
                            children: _q.choices.asMap().entries.map((e) {
                          return _buildChoiceCard(e.value);
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
          color: AppColors.textPrimary,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _phonicsSlot(String text, {required bool filled}) {
    final bg = filled ? AppColors.correctBg : AppColors.accentIndigo.withValues(alpha: 0.08);
    final border = filled ? AppColors.correct : AppColors.accentIndigo;
    final textColor = filled ? AppColors.correctDark : AppColors.accentIndigo;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: border, width: AppBorder.thick),
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
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.surfaceDim, width: AppBorder.thick),
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
                color: AppColors.textTertiary,
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

    Color bg = AppColors.surface;
    Color textColor = AppColors.textPrimary;
    Color borderColor = AppColors.surfaceDim;

    if (isSelected && !_hasChecked) {
      bg = AppColors.accentIndigo.withValues(alpha: 0.08);
      textColor = AppColors.accentIndigo;
      borderColor = AppColors.accentIndigo;
    }
    if (isCorrectAnswer) {
      bg = AppColors.correct;
      textColor = AppColors.onPrimary;
      borderColor = AppColors.correct;
    }
    if (isWrongAnswer) {
      bg = AppColors.wrong;
      textColor = AppColors.onPrimary;
      borderColor = AppColors.wrong;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor, width: AppBorder.normal),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
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
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
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
    final l10n = AppLocalizations.of(context)!;
    final canProceed = _hasChecked && _isCorrect;
    final canCheck = _selected != null && !_hasChecked;
    final canRetry = _hasChecked && !_isCorrect;

    final String label;
    final Color color;
    final VoidCallback? onTap;

    if (canProceed) {
      label = l10n.next;
      color = AppColors.accentIndigo;
      onTap = _next;
    } else if (canCheck) {
      label = l10n.check;
      color = AppColors.primary;
      onTap = _check;
    } else if (canRetry) {
      label = l10n.tryAgain;
      color = AppColors.wrong;
      onTap = _reset;
    } else {
      label = l10n.check;
      color = AppColors.surfaceDim;
      onTap = null;
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          elevation: 0,
        ),
        child: Text(label),
      ),
    );
  }
}
