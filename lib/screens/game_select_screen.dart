import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'game_setup_screen.dart';
import '../games/fill_in_blank_game.dart';

/// ゲームタイプ選択
class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  static const _gameColors = [
    AppColors.accentBlue,    // Sound Quiz
    AppColors.accentIndigo,  // IPA Quiz
    AppColors.primary,       // Bingo
    AppColors.accentTeal,    // Blending
    AppColors.accentGreen,   // Word Chaining
    AppColors.accentPurple,  // Minimal Pairs
    AppColors.accentPink,    // Fill-in-Blank
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final games = [
      _GameDef(GameType.soundQuiz, l10n.gameSoundQuiz, l10n.gameSoundQuizDesc,
          Icons.volume_up_rounded, _gameColors[0]),
      _GameDef(GameType.ipaQuiz, l10n.gameIpaQuiz, l10n.gameIpaQuizDesc,
          Icons.translate_rounded, _gameColors[1]),
      _GameDef(GameType.bingo, l10n.gameBingo, l10n.gameBingoDesc,
          Icons.grid_on_rounded, _gameColors[2]),
      _GameDef(GameType.blending, l10n.gameBlending, l10n.gameBlendingDesc,
          Icons.extension_rounded, _gameColors[3]),
      _GameDef(GameType.wordChaining, l10n.gameWordChaining,
          l10n.gameWordChainingDesc, Icons.swap_horiz_rounded, _gameColors[4]),
      _GameDef(GameType.minimalPairs, l10n.gameMinimalPairs,
          l10n.gameMinimalPairsDesc, Icons.hearing_rounded, _gameColors[5]),
      _GameDef(GameType.fillInBlank, l10n.gameFillInBlank,
          l10n.gameFillInBlankDesc, Icons.edit_note_rounded, _gameColors[6]),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectGame,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.selectGameSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: games.length,
                itemBuilder: (context, i) => _GameTypeCard(def: games[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameDef {
  final GameType type;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  const _GameDef(this.type, this.title, this.desc, this.icon, this.color);
}

class _GameTypeCard extends StatelessWidget {
  const _GameTypeCard({required this.def});
  final _GameDef def;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.accentCard(def.color),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            if (def.type == GameType.fillInBlank) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FillInBlankGame()));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GameSetupScreen(gameType: def.type)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: def.color.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(def.icon, size: 32, color: def.color),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  def.title,
                  style: AppTextStyle.cardTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  def.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
