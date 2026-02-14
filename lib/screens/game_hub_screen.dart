import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import 'game_screen.dart';
import 'practice_games_screen.dart';
import '../games/sound_matching_game.dart';
import '../games/bingo_game.dart';
import '../games/space_ship_game.dart';

class GameHubScreen extends StatefulWidget {
  const GameHubScreen({super.key, required this.group});

  final PhonicsGroup group;

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.group.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FadeInDown(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectGame,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF8E3C),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectGameSubtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSectionHeader(l10n.beginner, const Color(0xFF4DB6AC)),
          _buildGrid([
            _GameOption(
              title: l10n.game2Choice,
              icon: Icons.looks_two_outlined,
              color: const Color(0xFF4DB6AC),
              onTap: () => _openCustomGame(
                  GameMode.soundToLetter, '2-Choice Easy', 2, 10),
            ),
            _GameOption(
              title: l10n.gameSprint,
              icon: Icons.bolt_outlined,
              color: const Color(0xFFFF5E5E),
              onTap: () => _openCustomGame(
                  GameMode.soundToLetter, 'Sound Sprint', 3, 6),
            ),
            _GameOption(
              title: l10n.gameStandard,
              icon: Icons.volume_up_outlined,
              color: const Color(0xFF118AB2),
              textColor: Colors.white,
              onTap: () => _openGame(GameMode.soundToLetter),
            ),
          ]),
          _buildSectionHeader(l10n.intermediate, const Color(0xFFFFD166)),
          _buildGrid([
            _GameOption(
              title: l10n.gameLetterToSound,
              icon: Icons.hearing_outlined,
              color: const Color(0xFFFFD166),
              textColor: Colors.black87,
              onTap: () => _openGame(GameMode.letterToSound),
            ),
            _GameOption(
              title: l10n.gameSingleFocus,
              icon: Icons.filter_1_outlined,
              color: const Color(0xFFFF8E3C),
              onTap: () {
                final single = widget.group.items
                    .where((e) => e.letter.length == 1)
                    .toList();
                if (single.length >= 2) {
                  _openCustomGameWithItems(
                      GameMode.soundToLetter, 'Single Letters', single, 3, 10);
                }
              },
            ),
            _GameOption(
              title: l10n.gameDigraphs,
              icon: Icons.grid_3x3_outlined,
              color: const Color(0xFF073B4C),
              onTap: () {
                final digraphs = widget.group.items
                    .where((e) => e.letter.length > 1)
                    .toList();
                if (digraphs.length >= 2) {
                  _openCustomGameWithItems(
                      GameMode.soundToLetter, 'Digraphs', digraphs, 3, 10);
                }
              },
            ),
             _GameOption(
              title: l10n.gameDrill,
              icon: Icons.fitness_center_outlined,
              color: const Color(0xFFEF476F),
              onTap: () => _openCustomGame(
                  GameMode.soundToLetter, 'Focus Drill', 3, 10),
            ),
          ]),
          _buildSectionHeader(l10n.advanced, const Color(0xFF9D4EDD)),
          _buildGrid([
            _GameOption(
              title: l10n.gameIpaQuiz,
              icon: Icons.translate_outlined,
              color: const Color(0xFF9D4EDD),
              onTap: () => _openGame(GameMode.ipaToLetter),
            ),
            _GameOption(
              title: l10n.gameIpaSprint,
              icon: Icons.language_outlined,
              color: const Color(0xFF5A189A),
              onTap: () =>
                  _openCustomGame(GameMode.ipaToLetter, 'IPA Sprint', 3, 6),
            ),
            _GameOption(
              title: l10n.game4Choice,
              icon: Icons.filter_4_outlined,
              color: const Color(0xFF3C096C),
              onTap: () =>
                  _openCustomGame(GameMode.soundToLetter, '4 Choice', 4, 12),
            ),
            _GameOption(
              title: l10n.gameMarathon,
              icon: Icons.timer_outlined,
              color: const Color(0xFF240046),
              onTap: () => _openCustomGame(
                  GameMode.soundToLetter, 'Sound Marathon', 4, 20),
            ),
          ]),
          _buildSectionHeader(l10n.gameNewVariations, Colors.indigo),
          _buildGrid([
            _GameOption(
              title: l10n.gameSoundMatch,
              icon: Icons.graphic_eq,
              color: Colors.indigo,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SoundMatchingGame(items: widget.group.items)),
              ),
            ),
            _GameOption(
              title: l10n.gameBingo,
              icon: Icons.grid_on,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BingoGame(items: widget.group.items)),
              ),
            ),
            _GameOption(
              title: l10n.gameSpaceShip,
              icon: Icons.rocket_launch,
              color: Colors.blueAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SpaceShipGame(items: widget.group.items)),
              ),
            ),
          ]),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.science_outlined),
                label: Text(l10n.practiceLab),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade100, // Softer grey
                  foregroundColor: Colors.blueGrey.shade800,
                  elevation: 0, // Flat
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PracticeGamesScreen(group: widget.group)),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<_GameOption> options) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final opt = options[index];
            return FadeInUp(
              delay: Duration(milliseconds: 100 * index),
              child: _GameCard(option: opt),
            );
          },
          childCount: options.length,
        ),
      ),
    );
  }

  void _openGame(GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: widget.group.items,
          numOptions: 3,
          groupName: widget.group.name,
          mode: mode,
        ),
      ),
    );
  }

  void _openCustomGame(
      GameMode mode, String title, int numOptions, int maxQuestions) {
    _openCustomGameWithItems(
        mode, title, widget.group.items, numOptions, maxQuestions);
  }

  void _openCustomGameWithItems(GameMode mode, String title,
      List<PhonicsItem> items, int numOptions, int maxQuestions) {
    if (items.length < 2) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          items: items,
          numOptions: numOptions.clamp(2, 4),
          groupName: '${widget.group.name} - $title',
          mode: mode,
          maxQuestions: maxQuestions,
        ),
      ),
    );
  }
}

class _GameOption {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Color textColor;

  _GameOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.textColor = Colors.white,
  });
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.option});

  final _GameOption option;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: option.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: option.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, size: 32, color: option.color),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  option.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
