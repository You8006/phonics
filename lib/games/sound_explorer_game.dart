import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import '../screens/result_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/score_app_bar.dart';

/// Sound Explorer — 文字を見て、複数の音から正解を探すゲーム
///
/// 既存の Sound Quiz が「音→文字」の方向であるのに対し、
/// こちらは「文字→音」の逆方向。ユーザーは各スピーカーボタンで
/// 自由に試聴し、正解だと思ったらチェックボタンで回答する。
class SoundExplorerGame extends StatefulWidget {
  const SoundExplorerGame({
    super.key,
    required this.items,
    this.numOptions = 6,
    this.maxQuestions = 10,
  });

  final List<PhonicsItem> items;
  final int numOptions;
  final int maxQuestions;

  @override
  State<SoundExplorerGame> createState() => _SoundExplorerGameState();
}

class _SoundExplorerGameState extends State<SoundExplorerGame> {
  final _rng = Random();
  late List<PhonicsItem> _queue;
  late PhonicsItem _target;
  List<PhonicsItem> _options = [];

  /// 各選択肢の状態: null=未回答, correct/wrong
  Map<String, Color?> _feedback = {};
  bool _answered = false;
  bool _waitingForNext = false;
  int _score = 0;
  int _current = 0;
  late int _total;

  /// 現在再生中の選択肢キー（ハイライト用）
  String? _playingKey;

  @override
  void initState() {
    super.initState();
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
    TtsService.stopSpeech();
    super.dispose();
  }

  void _loadQuestion() {
    if (_current >= _total) {
      _showResult();
      return;
    }

    setState(() {
      _answered = false;
      _waitingForNext = false;
      _feedback = {};
      _playingKey = null;

      _target = _queue[_current];

      // ダミー選択肢: letter/ipa が重複しないアイテムを選ぶ
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
        if (!usedLetters.contains(item.letter) &&
            !usedIpas.contains(item.ipa)) {
          uniqueDistractors.add(item);
          usedLetters.add(item.letter);
          usedIpas.add(item.ipa);
        }
      }

      _options = [_target, ...uniqueDistractors]..shuffle(_rng);
    });
  }

  /// 指定の選択肢の音を試聴（何度でもOK）
  Future<void> _playOptionSound(PhonicsItem item) async {
    setState(() => _playingKey = item.progressKey);
    await TtsService.speakSound(item);
    if (mounted) {
      // 短い遅延後にハイライトを消す
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _playingKey = null);
    }
  }

  /// 回答を確定
  Future<void> _handleAnswer(PhonicsItem selected) async {
    if (_answered) return;
    _answered = true; // 二重タップ防止

    final correct = selected.progressKey == _target.progressKey;

    // 進捗記録
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
      // 不正解後に正解の音を再生
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await TtsService.speakSound(_target);
      if (!mounted) return;
      setState(() => _waitingForNext = true);
    }
  }

  void _showResult() {
    ProgressService.updateStreak();
    ProgressService.recordGameSession(
      gameType: 'soundExplorer',
      score: _score,
      total: _total,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _score,
          total: _total,
          groupName: 'Sound Explorer',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const accent = AppColors.accentAmber;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: progressAppBar('${_current + 1} / $_total'),
      body: SafeArea(
        child: Column(
          children: [
            // ── 問題エリア: 対象の文字 ──
            Expanded(
              flex: 3,
              child: Center(
                key: ValueKey(_current),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 文字カード
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.3),
                          width: AppBorder.thick,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _target.letter,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.findThisSound,
                      style: AppTextStyle.label
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),

            // ── 選択肢エリア ──
            Expanded(
              flex: 6,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      l10n.listenThenChoose,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          final cols = _options.length <= 4 ? 2 : 3;
                          final rows = (_options.length / cols).ceil();
                          final totalVSpacing = (rows - 1) * 12;
                          final cellHeight =
                              (constraints.maxHeight - totalVSpacing) / rows;
                          final totalHSpacing = (cols - 1) * 12;
                          final cellWidth =
                              (constraints.maxWidth - totalHSpacing) / cols;
                          final ratio =
                              (cellWidth / cellHeight).clamp(0.3, 3.0);

                          return GridView.count(
                            crossAxisCount: cols,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: ratio,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _options.map((item) {
                              return _SoundOptionCell(
                                item: item,
                                feedbackColor: _feedback[item.progressKey],
                                isPlaying:
                                    _playingKey == item.progressKey,
                                answered: _answered,
                                onPlay: () => _playOptionSound(item),
                                onChoose: () => _handleAnswer(item),
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

/// 1つの選択肢セル: 上段=スピーカーボタン, 下段=チェックボタン
class _SoundOptionCell extends StatelessWidget {
  const _SoundOptionCell({
    required this.item,
    required this.feedbackColor,
    required this.isPlaying,
    required this.answered,
    required this.onPlay,
    required this.onChoose,
  });

  final PhonicsItem item;
  final Color? feedbackColor;
  final bool isPlaying;
  final bool answered;
  final VoidCallback onPlay;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    // 色の決定
    final bool isCorrect = feedbackColor == AppColors.correct;
    final bool isWrong = feedbackColor == AppColors.wrong;
    final bool hasResult = feedbackColor != null;

    // スピーカーの色
    Color speakerBg;
    Color speakerIcon;
    Color speakerBorder;
    if (isCorrect) {
      speakerBg = AppColors.correct;
      speakerIcon = AppColors.onPrimary;
      speakerBorder = AppColors.correct;
    } else if (isWrong) {
      speakerBg = AppColors.wrong;
      speakerIcon = AppColors.onPrimary;
      speakerBorder = AppColors.wrong;
    } else if (isPlaying) {
      speakerBg = AppColors.accentAmber.withValues(alpha: 0.15);
      speakerIcon = AppColors.accentAmber;
      speakerBorder = AppColors.accentAmber;
    } else {
      speakerBg = AppColors.accentIndigo.withValues(alpha: 0.08);
      speakerIcon = AppColors.accentIndigo;
      speakerBorder = AppColors.accentIndigo.withValues(alpha: 0.2);
    }

    // チェックボタンの色
    Color checkBg;
    Color checkIcon;
    Color checkBorder;
    if (isCorrect) {
      checkBg = AppColors.correct;
      checkIcon = AppColors.onPrimary;
      checkBorder = AppColors.correct;
    } else if (isWrong) {
      checkBg = AppColors.wrong;
      checkIcon = AppColors.onPrimary;
      checkBorder = AppColors.wrong;
    } else {
      checkBg = AppColors.accentIndigo.withValues(alpha: 0.06);
      checkIcon = AppColors.accentIndigo;
      checkBorder = AppColors.accentIndigo.withValues(alpha: 0.15);
    }

    return Column(
      children: [
        // ── Speaker Button (上段) ──
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: speakerBg,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md)),
                border: Border.all(color: speakerBorder, width: AppBorder.normal),
              ),
              child: Center(
                child: Icon(
                  isPlaying
                      ? Icons.volume_up_rounded
                      : Icons.volume_up_outlined,
                  size: 32,
                  color: speakerIcon,
                ),
              ),
            ),
          ),
        ),
        // ── Check Button (下段) ──
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: hasResult ? null : onChoose,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: checkBg,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.md)),
                border: Border(
                  left: BorderSide(color: checkBorder, width: AppBorder.normal),
                  right: BorderSide(color: checkBorder, width: AppBorder.normal),
                  bottom: BorderSide(color: checkBorder, width: AppBorder.normal),
                ),
              ),
              child: Center(
                child: Icon(
                  hasResult ? Icons.check_rounded : Icons.check_rounded,
                  size: 26,
                  color: checkIcon,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
