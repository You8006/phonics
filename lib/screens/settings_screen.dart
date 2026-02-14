import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonics App'),
        centerTitle: true,
        actions: [
          // 音声選択
          IconButton(
            icon: Icon(
              _voiceIcon(TtsService.voiceType),
              color: Colors.blueGrey,
            ),
            tooltip: 'Voice',
            onPressed: _showVoicePicker,
          ),
          // ストリーク表示
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 4),
                Text('$_streak', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── ヒーローバナー ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.tertiary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn Phonics',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '42の英語の音をマスターしよう！',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 2週間ミッション + SRS復習 ──
            if (_mission != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_note),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _mission!.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('Phase: ${_mission!.phase}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final t in _mission!.tasks.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $t'),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _mission!.tip,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      if (_dueItems.isNotEmpty)
                        FilledButton.icon(
                          onPressed: _startDueReview,
                          icon: const Icon(Icons.history),
                          label: Text('SRS Review を開始 (${_dueItems.length}件)'),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 14),

            // ── グループ一覧 ──
            for (final group in phonicsGroups) ...[
              _GroupCard(
                group: group,
                mastery: _masteryCache[group.id] ?? 0,
                onLearn: () => _goLearn(group),
                onPlay: () => _goPlay(group),
              ),
              const SizedBox(height: 12),
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

  IconData _voiceIcon(VoiceType type) {
    switch (type) {
      case VoiceType.female:
        return Icons.face_3;
      case VoiceType.male:
        return Icons.face;
      case VoiceType.child:
        return Icons.child_care;
    }
  }

  void _showVoicePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '音声を選択',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                _VoiceOption(
                  icon: Icons.face_3,
                  label: 'Female (女性)',
                  subtitle: 'Jenny — 温かみのある声',
                  selected: TtsService.voiceType == VoiceType.female,
                  onTap: () => _selectVoice(VoiceType.female, ctx),
                ),
                _VoiceOption(
                  icon: Icons.face,
                  label: 'Male (男性)',
                  subtitle: 'Guy — クリアな声',
                  selected: TtsService.voiceType == VoiceType.male,
                  onTap: () => _selectVoice(VoiceType.male, ctx),
                ),
                _VoiceOption(
                  icon: Icons.child_care,
                  label: 'Child (子供)',
                  subtitle: 'Ana — かわいい子供の声',
                  selected: TtsService.voiceType == VoiceType.child,
                  onTap: () => _selectVoice(VoiceType.child, ctx),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectVoice(VoiceType type, BuildContext ctx) async {
    await TtsService.setVoiceType(type);
    if (!mounted) return;
    setState(() {});
    if (ctx.mounted) Navigator.pop(ctx);
    // Play a sample sound to preview the voice
    if (allPhonicsItems.isNotEmpty) {
      TtsService.speakSound(allPhonicsItems.first);
    }
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
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── タイトル行 ──
            Row(
              children: [
                Icon(Icons.auto_stories, color: cs.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // スター表示
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < _stars ? Icons.star : Icons.star_border,
                      size: 20,
                      color: Colors.amber,
                    );
                  }),
                ),
              ],
            ),

            // ── プログレスバー ──
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: mastery,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  mastery >= 0.6 ? Colors.green : cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(mastery * 100).toInt()}% mastered',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLearn,
                    icon: const Icon(Icons.volume_up, size: 18),
                    label: const Text('Learn'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Play'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── 音声選択オプション ──

class _VoiceOption extends StatelessWidget {
  const _VoiceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFF8E3C);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? accentColor.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? accentColor : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 32, color: selected ? accentColor : Colors.grey.shade600),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected ? accentColor : Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: accentColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
