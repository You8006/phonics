import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import 'learn_screen.dart';

/// レッスン完了画面: 合格SE + クイズ/次のレッスンへの遷移
class LearnCompleteScreen extends StatefulWidget {
  const LearnCompleteScreen({super.key, required this.group});

  final PhonicsGroup group;

  @override
  State<LearnCompleteScreen> createState() => _LearnCompleteScreenState();
}

class _LearnCompleteScreenState extends State<LearnCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    // 合格 SE を再生してアニメーション開始
    TtsService.playScoreResult(passed: true);
    _animController.forward();

    // レッスン完了を記録
    ProgressService.recordLessonComplete(widget.group.id);
  }

  @override
  void dispose() {
    _animController.dispose();
    TtsService.stop();
    super.dispose();
  }

  PhonicsGroup? get _nextGroup {
    final currentId = widget.group.id;
    if (currentId + 1 < phonicsGroups.length) {
      return phonicsGroups[currentId + 1];
    }
    return null;
  }

  void _goQuiz() {
    final maxQ = widget.group.items.length.clamp(1, 10);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: widget.group.items,
          numOptions: 3,
          groupName: widget.group.name,
          mode: GameMode.soundToLetter,
          maxQuestions: maxQ,
        ),
      ),
    );
  }

  void _goNextLesson() {
    final next = _nextGroup;
    if (next != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LearnScreen(group: next)),
      );
    }
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final next = _nextGroup;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ── チェックマークアイコン ──
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.correct.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: AppColors.correct,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── タイトル ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    l10n.lessonComplete,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── サブタイトル ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    l10n.lessonCompleteDesc(widget.group.name),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // ── クイズに挑戦ボタン ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _goQuiz,
                      icon: const Icon(Icons.quiz_rounded, size: 20),
                      label: Text(l10n.tryQuiz),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // ── 次のレッスンへボタン ──
                if (next != null)
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _goNextLesson,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                        label: Text(l10n.nextLesson),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (next != null) const SizedBox(height: AppSpacing.md),

                // ── ホームに戻るボタン ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: TextButton(
                    onPressed: _goHome,
                    child: Text(
                      l10n.backToHome,
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
