import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/voice_picker.dart';
import 'learn_screen.dart';
import 'game_screen.dart';

/// ホーム画面: グループ一覧 + 進捗 + 段階解放
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streak = 0;
  final Map<int, double> _masteryCache = {};
  List<PhonicsItem> _dueItems = [];
  DailyMission? _mission;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final streak = await ProgressService.getStreak();
    final mastery = <int, double>{};
    for (final g in phonicsGroups) {
      mastery[g.id] = await ProgressService.groupMastery(g);
    }

    final dueItems = await ProgressService.getDueItemsAll(limit: 16);
    final avgMastery = mastery.isEmpty
        ? 0.0
        : mastery.values.fold<double>(0, (a, b) => a + b) / mastery.length;
    final mission = await ProgressService.getTodayMission(
      dueCount: dueItems.length,
      streak: streak,
      mastery: avgMastery,
    );

    if (!mounted) return;
    setState(() {
      _streak = streak;
      _masteryCache.addAll(mastery);
      _dueItems = dueItems;
      _mission = mission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonics'),
        actions: [
          IconButton(
            icon: Icon(
              voiceIcon(TtsService.voiceType),
              color: AppColors.textSecondary,
              size: 22,
            ),
            tooltip: 'Voice',
            onPressed: () => showVoicePicker(context, () {
              if (mounted) setState(() {});
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 2),
                Text(
                  '$_streak',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // ── ヒーローバナー ──
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn Phonics',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '42の英語の音をマスターしよう！',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── ミッション + SRS復習 ──
            if (_mission != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: AppDecoration.card(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_note_rounded,
                            size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _mission!.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius:
                                BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            'Phase ${_mission!.phase}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final t in _mission!.tasks.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '• $t',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _mission!.tip,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (_dueItems.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _startDueReview,
                          icon: const Icon(Icons.history, size: 18),
                          label:
                              Text('SRS Review (${_dueItems.length}件)'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // ── グループ一覧 ──
            for (final group in phonicsGroups) ...[
              _GroupCard(
                group: group,
                mastery: _masteryCache[group.id] ?? 0,
                onLearn: () => _goLearn(group),
                onPlay: () => _goPlay(group),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  void _goLearn(PhonicsGroup group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LearnScreen(group: group)),
    ).then((_) => _refresh());
  }

  void _goPlay(PhonicsGroup group) {
    final maxQ = group.items.length.clamp(1, 10);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: group.items,
          numOptions: 3,
          groupName: group.name,
          mode: GameMode.soundToLetter,
          maxQuestions: maxQ,
        ),
      ),
    ).then((_) => _refresh());
  }

  void _startDueReview() {
    if (_dueItems.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: _dueItems,
          numOptions: 3,
          groupName: 'SRS Review',
          mode: GameMode.soundToLetter,
        ),
      ),
    ).then((_) => _refresh());
  }
}

// ── グループカード ──

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.mastery,
    required this.onLearn,
    required this.onPlay,
  });

  final PhonicsGroup group;
  final double mastery;
  final VoidCallback onLearn;
  final VoidCallback onPlay;

  int get _stars {
    if (mastery >= 0.9) return 3;
    if (mastery >= 0.6) return 2;
    if (mastery >= 0.3) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecoration.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return Icon(
                    i < _stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 18,
                    color: i < _stars ? AppColors.accentAmber : AppColors.surfaceDim,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: mastery,
              minHeight: 6,
              backgroundColor: AppColors.surfaceDim,
              valueColor: AlwaysStoppedAnimation(
                mastery >= 0.6 ? AppColors.correct : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(mastery * 100).toInt()}% mastered',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onLearn,
                  icon: const Icon(Icons.volume_up_rounded, size: 16),
                  label: const Text('Learn'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Play'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
