import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../screens/game_setup_screen.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════
//  Game Tutorial Overlay
//  エクササイズの遊び方説明オーバーレイ
// ═══════════════════════════════════════════

class GameTutorialOverlay {
  GameTutorialOverlay._();

  static const _prefPrefix = 'phonics_tutorial_skip_';

  /// GameType ごとの「次回から表示しない」フラグを取得
  static Future<bool> _shouldSkip(GameType type) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefPrefix${type.name}') ?? false;
  }

  /// GameType ごとの「次回から表示しない」フラグを保存
  static Future<void> _setSkip(GameType type, bool skip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefPrefix${type.name}', skip);
  }

  /// チュートリアルテキストを取得
  static String _tutorialText(AppLocalizations l10n, GameType type) {
    switch (type) {
      case GameType.soundQuiz:
        return l10n.tutorialSoundQuiz;
      case GameType.ipaQuiz:
        return l10n.tutorialIpaQuiz;
      case GameType.bingo:
        return l10n.tutorialBingo;
      case GameType.blending:
        return l10n.tutorialBlending;
      case GameType.wordChaining:
        return l10n.tutorialWordChaining;
      case GameType.minimalPairs:
        return l10n.tutorialMinimalPairs;
      case GameType.fillInBlank:
        return l10n.tutorialFillInBlank;
      case GameType.soundExplorer:
        return l10n.tutorialSoundExplorer;
    }
  }

  /// タップ時に呼び出すエントリポイント。
  /// skip 済みなら即 [onStart] を呼び、未設定ならオーバーレイを表示。
  static Future<void> showIfNeeded({
    required BuildContext context,
    required GameType type,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onStart,
  }) async {
    if (await _shouldSkip(type)) {
      onStart();
      return;
    }
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final tutorial = _tutorialText(l10n, type);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'tutorial',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        return FadeTransition(
          opacity: a1,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, anim1, anim2) {
        return _TutorialDialog(
          type: type,
          title: title,
          icon: icon,
          color: color,
          tutorial: tutorial,
          l10n: l10n,
          onStart: onStart,
        );
      },
    );
  }
}

// ─── Dialog 本体 ───

class _TutorialDialog extends StatefulWidget {
  const _TutorialDialog({
    required this.type,
    required this.title,
    required this.icon,
    required this.color,
    required this.tutorial,
    required this.l10n,
    required this.onStart,
  });

  final GameType type;
  final String title;
  final IconData icon;
  final Color color;
  final String tutorial;
  final AppLocalizations l10n;
  final VoidCallback onStart;

  @override
  State<_TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<_TutorialDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── ヘッダー (アイコン + タイトル) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xxl, horizontal: AppSpacing.xl),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xxl),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, size: 40, color: widget.color),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      widget.title,
                      style: AppTextStyle.sectionHeading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.l10n.howToPlay,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),

              // ── 説明テキスト ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.md),
                child: Text(
                  widget.tutorial,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── 「次回から表示しない」チェックボックス ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  onTap: () =>
                      setState(() => _dontShowAgain = !_dontShowAgain),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _dontShowAgain,
                            onChanged: (v) =>
                                setState(() => _dontShowAgain = v ?? false),
                            activeColor: widget.color,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.l10n.dontShowAgain,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── スタートボタン ──
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl,
                    AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (_dontShowAgain) {
                        await GameTutorialOverlay._setSkip(
                            widget.type, true);
                      }
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      widget.onStart();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      widget.l10n.startGame,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
