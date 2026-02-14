import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import 'game_screen.dart';

// REUSED from old GameSelectScreen logic
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({
    super.key,
    required this.gameMode,
    required this.gameTitle,
    this.numOptions = 3,
    this.maxQuestions = 10,
    this.useCustomItems = false,
  });

  final GameMode gameMode;
  final String gameTitle;
  final int numOptions;
  final int maxQuestions;
  final bool useCustomItems; // If true, logic might be more complex, simplification for now:

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final Map<int, double> _mastery = {};
  bool _loading = true;

  final List<Color> _cardColors = const [
    Color(0xFFFFCC00), Color(0xFFFF5E5E), Color(0xFF4DB6AC),
    Color(0xFFAB47BC), Color(0xFF29B6F6), Color(0xFF66BB6A), Color(0xFFFF7043),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final mastery = <int, double>{};
    for (final g in phonicsGroups) {
      mastery[g.id] = await ProgressService.groupMastery(g);
    }
    if (!mounted) return;
    setState(() {
      _mastery
        ..clear()
        ..addAll(mastery);
      _loading = false;
    });
  }

  void _onLevelSelected(PhonicsGroup group) {
    if (widget.useCustomItems) {
      // Special logic for Drill/Single/Digraph not purely group based?
      // For now, simplify: All modes run per-group in this new flow.
      // Or we can add specific filters here?
      // Let's assume standard group play for all modes to start.
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: group.items,
          numOptions: widget.numOptions,
          groupName: group.name,
          mode: widget.gameMode,
          maxQuestions: widget.maxQuestions,
        ),
      ),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: Text('${l10n.selectGameSubtitle} - ${widget.gameTitle}',
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: phonicsGroups.length,
        itemBuilder: (context, index) {
          final group = phonicsGroups[index];
          final color = _cardColors[index % _cardColors.length];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: _LevelTile(
              group: group,
              color: color,
              mastery: _mastery[group.id] ?? 0,
              onTap: () => _onLevelSelected(group),
            ),
          );
        },
      ),
    );
  }
}

// ... COPY OF _LevelTile logic with new text helpers ...
// I will reuse the _GameTile code as _LevelTile here
class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.group,
    required this.color,
    required this.mastery,
    required this.onTap,
  });

  final PhonicsGroup group;
  final Color color;
  final double mastery;
  final VoidCallback onTap;

 // Helper methods moved here
  String _getGroupTitle(AppLocalizations l10n, int id) {
    switch (id) {
      case 0: return l10n.groupTitle0;
      case 1: return l10n.groupTitle1;
      case 2: return l10n.groupTitle2;
      case 3: return l10n.groupTitle3;
      case 4: return l10n.groupTitle4;
      case 5: return l10n.groupTitle5;
      case 6: return l10n.groupTitle6;
      default: return 'Level ${id + 1}';
    }
  }

  String _getGroupDesc(AppLocalizations l10n, int id) {
    switch (id) {
      case 0: return l10n.groupDesc0;
      case 1: return l10n.groupDesc1;
      case 2: return l10n.groupDesc2;
      case 3: return l10n.groupDesc3;
      case 4: return l10n.groupDesc4;
      case 5: return l10n.groupDesc5;
      case 6: return l10n.groupDesc6;
      default: return '';
    }
  }
  
  IconData _getGroupIcon(int id) {
     switch (id % 6) {
      case 1: return Icons.rocket_launch_rounded;
      case 2: return Icons.extension_rounded;
      case 3: return Icons.smart_toy_rounded;
      case 4: return Icons.favorite_rounded;
      case 5: return Icons.palette_rounded;
      default: return Icons.videogame_asset_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shadowColor = HSLColor.fromColor(color).withLightness(0.45).toColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.6),
              offset: const Offset(0, 8),
              blurRadius: 0,
            ),
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
               Positioned(
                top: -20,
                right: -20,
                child: Icon(Icons.circle, size: 100, color: Colors.white.withValues(alpha: 0.2)),
              ),
              Positioned(
                bottom: -30,
                left: -10,
                child: Icon(Icons.circle_outlined, size: 80, color: Colors.white.withValues(alpha: 0.1)),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Icon(_getGroupIcon(group.id), size: 20, color: color),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('LEVEL ${group.id + 1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_getGroupTitle(l10n, group.id),  maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(group.name.replaceAll(RegExp(r'Group \d: '), ''), 
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: Text(_getGroupDesc(l10n, group.id), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    )
                  ],
                ),
              ),
              if (mastery >= 1.0)
                Positioned(
                  top: 8, left: 8,
                  child: FadeIn(child: const Icon(Icons.star_rounded, color: Colors.yellowAccent, size: 24)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
