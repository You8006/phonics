import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.groupName,
  });

  final int score;
  final int total;
  final String groupName;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  int _streak = 0;

  double get _accuracy => widget.total == 0 ? 0 : widget.score / widget.total;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final s = await ProgressService.getStreak();
    if (mounted) setState(() => _streak = s);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _getFeedback(AppLocalizations l10n) {
    if (_accuracy == 1.0) return l10n.resultPerfect;
    if (_accuracy >= 0.8) return l10n.resultGreat;
    if (_accuracy >= 0.5) return l10n.resultGood;
    return l10n.resultKeep;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHigh = _accuracy >= 0.8;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Trophy
              ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHigh ? AppColors.accentAmber : AppColors.accentTeal,
                  ),
                  child: Icon(
                    isHigh
                        ? Icons.emoji_events_rounded
                        : Icons.thumb_up_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Feedback
              Text(
                _getFeedback(l10n),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Score
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.score}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/${widget.total}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),

              // Streak
              if (_streak > 1)
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.lg),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${l10n.streak} $_streak!',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),

              const Spacer(),

              // Actions
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.backToHome),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(l10n.playAgainBtn),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
