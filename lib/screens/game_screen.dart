import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

enum GameMode {
  soundToLetter,
  letterToSound,
  ipaToLetter,
}

extension GameModeLabel on GameMode {
  String title(AppLocalizations l10n) {
    switch (this) {
      case GameMode.soundToLetter:
        return l10n.soundToLetterTitle;
      case GameMode.letterToSound:
        return l10n.letterToSoundTitle;
      case GameMode.ipaToLetter:
        return l10n.ipaToLetterTitle;
    }
  }

  String subtitle(AppLocalizations l10n) {
    switch (this) {
      case GameMode.soundToLetter:
        return l10n.soundToLetterSubtitle;
      case GameMode.letterToSound:
        return l10n.letterToSoundSubtitle;
      case GameMode.ipaToLetter:
        return l10n.ipaToLetterSubtitle;
    }
  }
}

class _GameOption {
  const _GameOption({
    required this.key,
    required this.label,
    required this.item,
  });

  final String key;
  final String label;
  final PhonicsItem item;
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.items,
    required this.numOptions,
    required this.groupName,
    required this.mode,
    this.maxQuestions,
  });

  final List<PhonicsItem> items;
  final int numOptions;
  final String groupName;
  final GameMode mode;
  final int? maxQuestions;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final _rng = Random();
  late List<PhonicsItem> _queue;
  int _current = 0;
  int _score = 0;
  int _total = 0;

  List<_GameOption> _options = [];
  Map<String, Color?> _feedback = {};
  bool _answered = false;


  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.value = 1.0;

    _queue = List.of(widget.items)..shuffle(_rng);
    if (widget.maxQuestions != null && widget.maxQuestions! > 0) {
      _queue = _queue.take(widget.maxQuestions!).toList();
    }
    _total = _queue.length;
    _buildChoices();
    
    // 全モードで問題開始時に自動で音を再生
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _playSound();
    });
  }

  PhonicsItem get _answer => _queue[_current];

  void _buildChoices() {
    // 同じ letter / 同じ ipa のアイテムを除外し、
    // 選択肢に見た目・音が重複するペアが出ないようにする
    final others = widget.items
        .where((e) =>
            e.progressKey != _answer.progressKey &&
            e.letter != _answer.letter &&
            e.ipa != _answer.ipa)
        .toList()
      ..shuffle(_rng);

    final count = min(widget.numOptions, widget.items.length);
    final picks = <PhonicsItem>[_answer];
    final usedLetters = {_answer.letter};
    final usedIpas = {_answer.ipa};
    for (final item in others) {
      if (picks.length >= count) break;
      if (!usedLetters.contains(item.letter) && !usedIpas.contains(item.ipa)) {
        picks.add(item);
        usedLetters.add(item.letter);
        usedIpas.add(item.ipa);
      }
    }
    picks.shuffle(_rng);

    switch (widget.mode) {
      case GameMode.soundToLetter:
      case GameMode.ipaToLetter:
        _options = picks
            .map(
              (item) => _GameOption(
                key: item.progressKey,
                label: item.letter,
                item: item,
              ),
            )
            .toList();
        break;
      case GameMode.letterToSound:
        _options = picks
            .map(
              (item) => _GameOption(
                key: item.progressKey,
                label: '/${item.ipa.isEmpty ? item.sound : item.ipa}/',
                item: item,
              ),
            )
            .toList();
        break;
    }

    _feedback = {};
    _answered = false;
  }

  Future<void> _playSound() async {
    _animController.forward(from: 0.0);
    await TtsService.speakSound(_answer);
    if (!mounted) return;
    // _soundPlayed assignment removed
  }

  Future<void> _onTap(PhonicsItem item) async {
    if (_answered) return;
    _answered = true; // 即座にガードを設定し、二重タップを防止

    final correct = item.progressKey == _answer.progressKey;
    await ProgressService.recordAttempt(_answer.progressKey);
    if (correct) {
      await ProgressService.recordCorrect(_answer.progressKey);
    } else {
      await ProgressService.recordWrong(_answer.progressKey);
    }

    setState(() {
      if (correct) {
        _feedback[item.progressKey] = AppColors.correct;
        _score++;
      } else {
        _feedback[item.progressKey] = AppColors.wrong;
        _feedback[_answer.progressKey] = AppColors.correct;
      }
    });

    if (correct) {
      await TtsService.playCorrect();
    } else {
      await TtsService.playWrong();
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _next();
  }

  void _next() {
    if (_current + 1 >= _total) {
      ProgressService.updateStreak();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: _score,
            total: _total,
            groupName: widget.groupName,
          ),
        ),
      );
      return;
    }
    setState(() {
      _current++;
      _buildChoices();
    });
    
    // 次の問題でも自動再生
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _playSound();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: AppColors.textSecondary),
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
                 style: TextStyle(
                   color: AppColors.textPrimary,
                   fontWeight: FontWeight.w800,
                   fontSize: 16
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
            // Question Area
            Expanded(
              flex: 3,
              child: Center(
                key: ValueKey(_current),
                child: _buildPrompt(l10n),
              ),
            ),
            
            // Choices Area
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      widget.mode.subtitle(l10n),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = widget.numOptions <= 2 ? 1 : 2;
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
                                 final opt = entry.value;
                                 return _ChoiceButton(
                                   label: opt.label,
                                   color: _feedback[opt.key],
                                   onTap: () => _onTap(opt.item),
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

  Widget _buildPrompt(AppLocalizations l10n) {
    if (widget.mode == GameMode.soundToLetter || widget.mode == GameMode.ipaToLetter) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: GestureDetector(
                onTap: _playSound,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 8),
                    boxShadow: [
                       BoxShadow(
                         color: AppColors.primary.withValues(alpha: 0.1),
                         blurRadius: 30,
                         offset: const Offset(0, 10),
                       )
                    ],
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.listenSound, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            if (widget.mode == GameMode.ipaToLetter)
               Text('/${_answer.ipa}/', style: TextStyle(fontSize: 24, color: AppColors.textTertiary)),
          ],
        );
    } else {
        // Letter question
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _answer.letter,
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _playSound, 
              icon: Icon(Icons.hearing_rounded, color: AppColors.textTertiary),
              tooltip: 'Play sound',
            )
          ],
        );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    TtsService.stop();
    super.dispose();
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.surface;
    Color border = AppColors.surfaceDim;
    Color text = AppColors.textPrimary;

    if (color != null) {
      bg = color!;
      border = color!;
      text = Colors.white;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
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
                    color: text,
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
