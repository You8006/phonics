import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/progress_service.dart';
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
  final Map<int, int> _lessonCountCache = {};
  List<PhonicsItem> _dueItems = [];
  UserStats? _stats;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// 外部（MainShell のタブ切り替え）から呼出し可能なリフレッシュ
  void refreshIfNeeded() => _refresh();

  Future<void> _refresh() async {
    final lessonCounts = await ProgressService.getAllLessonCounts();
    final dueItems = await ProgressService.getDueItemsAll(limit: 16);
    final stats = await ProgressService.getUserStats();

    if (!mounted) return;
    setState(() {
      _lessonCountCache
        ..clear()
        ..addAll(lessonCounts);
      _dueItems = dueItems;
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
            // ── 学習統計 ──
            if (_stats != null)
              _StatsCard(stats: _stats!),
            if (_stats != null) const SizedBox(height: AppSpacing.lg),

            // ── ガイド + 復習 ──
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: AppDecoration.card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded,
                          size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.homeGuideTitle,
                          style: AppTextStyle.cardTitle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.homeGuideGroupInfo,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.homeGuideFlow,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.homeGuideReview,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (_dueItems.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _dueItems.take(10).map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmber.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            item.letter,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentAmber,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _startDueReview,
                        icon: const Icon(Icons.history, size: 18),
                        label: Text(l10n.srsReview(_dueItems.length)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── グループ一覧 ──
            for (final group in phonicsGroups) ...[
              _GroupCard(
                group: group,
                lessonCount: _lessonCountCache[group.id] ?? 0,
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
          groupName: AppLocalizations.of(context)!.srsReviewGroupName,
          mode: GameMode.soundToLetter,
          consumeReviewOnAttempt: true,
        ),
      ),
    ).then((_) => _refresh());
  }
}

// ── グループカード ──

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.lessonCount,
    required this.onLearn,
    required this.onPlay,
  });

  final PhonicsGroup group;
  final int lessonCount;
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
                  color: lessonCount > 0
                      ? AppColors.correct.withValues(alpha: 0.08)
                      : AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  l10n.lessonCountLabel(lessonCount),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: lessonCount > 0
                        ? AppColors.correct
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
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
