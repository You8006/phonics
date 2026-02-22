import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'learn_screen.dart';
import 'game_screen.dart';

/// ホーム画面: グループ一覧 + 進捗 + 段階解放
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Map<int, double> _masteryCache = {};
  List<PhonicsItem> _dueItems = [];
  DailyMission? _mission;
  UserStats? _stats;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// 外部（MainShell のタブ切り替え）から呼出し可能なリフレッシュ
  void refreshIfNeeded() => _refresh();

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
    final stats = await ProgressService.getUserStats();

    if (!mounted) return;
    setState(() {
      _masteryCache.addAll(mastery);
      _dueItems = dueItems;
      _mission = mission;
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.masterSounds,
                    style: const TextStyle(fontSize: 13, color: Color(0xB3FFFFFF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── 学習統計 ──
            if (_stats != null)
              _StatsCard(stats: _stats!),
            if (_stats != null) const SizedBox(height: AppSpacing.lg),

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
                            style: AppTextStyle.cardTitle,
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
                            l10n.phaseLabel(_mission!.phase),
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
                              Text(l10n.srsReview(_dueItems.length)),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  style: AppTextStyle.cardTitle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  l10n.masteredPercent((mastery * 100).toInt()),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onLearn,
                  icon: const Icon(Icons.volume_up_rounded, size: 16),
                  label: Text(l10n.learn),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: Text(l10n.playBtn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 学習統計カード ──

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecoration.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(l10n.statsTitle, style: AppTextStyle.cardTitle),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFF57C00),
                  label: l10n.loginStreakLabel,
                  value: l10n.daysUnit(stats.loginStreak),
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.sports_esports_rounded,
                  iconColor: AppColors.primary,
                  label: l10n.totalGamesLabel,
                  value: l10n.timesUnit(stats.totalGameSessions),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.menu_book_rounded,
                  iconColor: const Color(0xFF43A047),
                  label: l10n.totalLessonsLabel,
                  value: l10n.timesUnit(stats.totalLessonCompletions),
                ),
              ),
              Expanded(
                child: _StatTile(
                  icon: Icons.today_rounded,
                  iconColor: const Color(0xFF5C6BC0),
                  label: l10n.todaySessionsLabel,
                  value: l10n.timesUnit(stats.todayGameSessions),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
