import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.groupName,
    this.retryBuilder,
  });

  final int score;
  final int total;
  final String groupName;

  /// 「もう一度プレイ」用。指定されていれば pushReplacement で新ゲームを起動する。
  final WidgetBuilder? retryBuilder;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──
  late AnimationController _progressCtrl;
  late AnimationController _scoreCtrl;
  late AnimationController _confettiCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _progressAnim;
  late Animation<int> _scoreAnim;

  int _streak = 0;
  late final List<_ConfettiParticle> _confettiParticles;

  double get _accuracy => widget.total == 0 ? 0 : widget.score / widget.total;
  bool get _isHigh => _accuracy >= 0.8;
  bool get _isPerfect => _accuracy == 1.0;

  int get _starCount {
    if (_accuracy >= 0.8) return 3;
    if (_accuracy >= 0.5) return 2;
    if (_accuracy > 0) return 1;
    return 0;
  }

  Color get _ringColor {
    if (_accuracy >= 0.8) return AppColors.correct;
    if (_accuracy >= 0.5) return AppColors.accentAmber;
    return AppColors.wrong;
  }

  String get _emoji {
    if (_isPerfect) return '🏆';
    if (_isHigh) return '🎉';
    if (_accuracy >= 0.5) return '👍';
    return '💪';
  }

  @override
  void initState() {
    super.initState();

    // ── Circular progress 0→accuracy (1.2s) ──
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = Tween<double>(begin: 0, end: _accuracy).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOutCubic),
    );

    // ── Score count-up (1s) ──
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scoreAnim = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOutCubic),
    );

    // ── Confetti (3s, high scores only) ──
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _confettiParticles = _generateConfetti(_isPerfect ? 50 : 28);

    // ── Ring glow pulse (looping) ──
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _startSequence();
    _loadStreak();
    _speakFeedback();
  }

  List<_ConfettiParticle> _generateConfetti(int count) {
    final rng = Random();
    const colors = [
      AppColors.primary,
      AppColors.accentBlue,
      AppColors.accentPurple,
      AppColors.accentPink,
      AppColors.accentTeal,
      AppColors.accentAmber,
      AppColors.correct,
    ];
    return List.generate(count, (_) {
      return _ConfettiParticle(
        x: rng.nextDouble(),
        delay: rng.nextDouble() * 0.4,
        speed: 0.6 + rng.nextDouble() * 0.8,
        size: 4 + rng.nextDouble() * 6,
        color: colors[rng.nextInt(colors.length)],
        wobbleSpeed: 1.5 + rng.nextDouble() * 3,
        wobbleAmount: 10 + rng.nextDouble() * 20,
        rotation: rng.nextDouble() * pi * 2,
        rotationSpeed: (rng.nextDouble() - 0.5) * 6,
        isCircle: rng.nextBool(),
      );
    });
  }

  Future<void> _startSequence() async {
    // 少し待ってからアニメーション開始（SE 再生と同期）
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    _progressCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _scoreCtrl.forward();

    if (_isHigh) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _confettiCtrl.forward();
      _pulseCtrl.repeat(reverse: true);
    }
  }

  Future<void> _loadStreak() async {
    final s = await ProgressService.getLoginStreak();
    if (mounted) setState(() => _streak = s);
  }

  Future<void> _speakFeedback() async {
    if (!mounted) return;
    await TtsService.playScoreResult(passed: _isHigh);
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _scoreCtrl.dispose();
    _confettiCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _getFeedback(AppLocalizations l10n) {
    if (_isPerfect) return l10n.resultPerfect;
    if (_accuracy >= 0.8) return l10n.resultGreat;
    if (_accuracy >= 0.5) return l10n.resultGood;
    return l10n.resultKeep;
  }

  // ══════════════════════════════════════════
  //  Build
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Confetti overlay ──
          if (_isHigh)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _confettiCtrl,
                builder: (context, _) => CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _confettiParticles,
                    progress: _confettiCtrl.value,
                  ),
                ),
              ),
            ),

          // ── Main content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Emoji ──
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 600),
                      child: Text(_emoji, style: const TextStyle(fontSize: 52)),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Animated circular progress ring + score ──
                    FadeIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      child: _buildCircularScore(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Feedback text ──
                    FadeInUp(
                      delay: const Duration(milliseconds: 900),
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _getFeedback(l10n),
                        style: AppTextStyle.pageHeading,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Stars ──
                    _buildStars(),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Group badge ──
                    FadeInUp(
                      delay: const Duration(milliseconds: 1200),
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDim,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          widget.groupName,
                          style: AppTextStyle.label,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Streak badge ──
                    if (_streak > 1)
                      FadeInUp(
                        delay: const Duration(milliseconds: 1350),
                        duration: const Duration(milliseconds: 500),
                        child: _buildStreakBadge(l10n),
                      ),

                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Action buttons ──
                    FadeInUp(
                      delay: const Duration(milliseconds: 1500),
                      duration: const Duration(milliseconds: 500),
                      child: _buildActions(l10n),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  Sub-widgets
  // ══════════════════════════════════════════

  /// アニメーション付き円形プログレス＋スコア
  Widget _buildCircularScore() {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnim, _scoreAnim, _pulseCtrl]),
      builder: (context, _) {
        final glowOpacity =
            _isHigh ? 0.15 + _pulseCtrl.value * 0.15 : 0.0;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              if (_isHigh)
                BoxShadow(
                  color: _ringColor.withValues(alpha: glowOpacity),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
            ],
          ),
          child: CustomPaint(
            painter: _RingPainter(
              progress: _progressAnim.value,
              color: _ringColor,
              trackColor: AppColors.surfaceDim,
              strokeWidth: 10,
            ),
            child: SizedBox(
              width: 160,
              height: 160,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_scoreAnim.value}',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: _ringColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/ ${widget.total}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ★ 星評価（バウンスアニメーション付き）
  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < _starCount;
        return BounceInDown(
          delay: Duration(milliseconds: 1000 + i * 150),
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 40,
              color: filled ? AppColors.accentAmber : AppColors.surfaceDim,
            ),
          ),
        );
      }),
    );
  }

  /// ストリークバッジ
  Widget _buildStreakBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.accentAmber.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            '${l10n.streak} $_streak',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// アクションボタン
  Widget _buildActions(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l10n.backToHome),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: FilledButton(
            onPressed: () {
              if (widget.retryBuilder != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: widget.retryBuilder!),
                );
              } else {
                Navigator.pop(context, true);
              }
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l10n.playAgainBtn),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════
//  Circular Progress Ring Painter
// ══════════════════════════════════════════════

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ══════════════════════════════════════════════
//  Confetti Painter
// ══════════════════════════════════════════════

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.wobbleSpeed,
    required this.wobbleAmount,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });

  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double wobbleSpeed;
  final double wobbleAmount;
  final double rotation;
  final double rotationSpeed;
  final bool isCircle;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      // Fade out towards end
      final opacity = t < 0.7 ? 1.0 : (1.0 - (t - 0.7) / 0.3);
      _paint.color = p.color.withValues(alpha: opacity * 0.85);

      // Position: start from top, fall down
      final dx = p.x * size.width +
          sin(t * p.wobbleSpeed * pi * 2) * p.wobbleAmount;
      final dy = -p.size + t * (size.height + p.size * 2) * p.speed;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(p.rotation + t * p.rotationSpeed);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, _paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.6,
            ),
            Radius.circular(p.size * 0.15),
          ),
          _paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
