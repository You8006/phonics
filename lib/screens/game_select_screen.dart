import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:phonics/l10n/app_localizations.dart';
import 'game_setup_screen.dart';
import 'settings_screen.dart';

/// ゲームタイプ選択 — ホーム画面
class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final games = [
      _GameDef(
        GameType.soundQuiz,
        l10n.gameSoundQuiz,
        l10n.gameSoundQuizDesc,
        Icons.volume_up_rounded,
        const Color(0xFF118AB2),
      ),
      _GameDef(
        GameType.soundMatch,
        l10n.gameSoundMatch,
        l10n.gameSoundMatchDesc,
        Icons.graphic_eq_rounded,
        const Color(0xFF5C6BC0),
      ),
      _GameDef(
        GameType.bingo,
        l10n.gameBingo,
        l10n.gameBingoDesc,
        Icons.grid_on_rounded,
        const Color(0xFFFF8E3C),
      ),
      _GameDef(
        GameType.spaceShip,
        l10n.gameSpaceShip,
        l10n.gameSpaceShipDesc,
        Icons.rocket_launch_rounded,
        const Color(0xFF00ACC1),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            l10n.gameSelectTitle,
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.black87),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
            icon: const Icon(Icons.settings_rounded, color: Colors.black54),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            FadeInDown(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
                    const SizedBox(height: 4),
                    Text(
                      l10n.selectGameSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Game Grid ──
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.92,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: games.length,
                itemBuilder: (context, i) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 80 * i),
                    child: _GameTypeCard(def: games[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data ──

class _GameDef {
  final GameType type;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  const _GameDef(this.type, this.title, this.desc, this.icon, this.color);
}

// ── Card ──

class _GameTypeCard extends StatelessWidget {
  const _GameTypeCard({required this.def});
  final _GameDef def;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: def.color.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: def.color.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameSetupScreen(gameType: def.type),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: def.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(def.icon, size: 36, color: def.color),
                ),
                const SizedBox(height: 14),
                Text(
                  def.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  def.desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
