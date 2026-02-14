import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../services/tts_service.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Trophy / Icon
              ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHigh ? const Color(0xFFFFD166) : const Color(0xFF4DB6AC),
                    boxShadow: [
                      BoxShadow(
                        color: (isHigh ? Colors.amber : Colors.teal).withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Icon(
                    isHigh ? Icons.emoji_events_rounded : Icons.thumb_up_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Feedback Text
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  _getFeedback(l10n),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Score
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.score}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF8E3C),
                      ),
                    ),
                    Text(
                      '/${widget.total}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Streak Badge
              if (_streak > 1)
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Text(
                      '${l10n.streak} $_streak!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ),

              const Spacer(),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FadeInLeft(
                        delay: const Duration(milliseconds: 900),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.backToHome,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 900),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true), // true = restart
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8E3C), // Phonics Orange
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.playAgainBtn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
