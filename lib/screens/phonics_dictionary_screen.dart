import 'package:flutter/material.dart';
import '../models/sound_group_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// フォニックスのおとずかん — スペリングごとに単語を表示
class PhonicsDictionaryScreen extends StatefulWidget {
  const PhonicsDictionaryScreen({super.key});

  @override
  State<PhonicsDictionaryScreen> createState() =>
      _PhonicsDictionaryScreenState();
}

class _PhonicsDictionaryScreenState extends State<PhonicsDictionaryScreen> {
  String? _playingGroupId;
  /// 選択されたスペリング ("groupId::spelling" 形式)
  String? _selectedSpellingKey;
  String? _playingWord;

  /// グループの音を再生
  Future<void> _playGroupSound(SoundGroup group) async {
    setState(() => _playingGroupId = group.id);
    final item = findPhonicsItemForGroup(group);
    if (item != null) {
      await TtsService.speakSound(item);
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _playingGroupId = null);
  }

  /// 単語を再生
  Future<void> _playWord(String word) async {
    setState(() => _playingWord = word);
    await TtsService.speakLibraryWord(word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _playingWord = null);
  }

  /// スペリングの展開/折りたたみ
  void _toggleSpelling(String groupId, String spelling) {
    final key = '$groupId::$spelling';
    setState(() {
      _selectedSpellingKey = _selectedSpellingKey == key ? null : key;
    });
  }

  /// 指定グループで選択中のスペリングを取得
  String? _getSelectedSpelling(String groupId) {
    if (_selectedSpellingKey == null) return null;
    final parts = _selectedSpellingKey!.split('::');
    if (parts.length == 2 && parts[0] == groupId) return parts[1];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final sections = soundGroupSections;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── ヘッダー ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🔊', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      const Text(
                        'フォニックスのおとずかん',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: AppDecoration.chip(AppColors.primary),
                        child: Text(
                          '${soundGroups.length} sounds',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'つづりをタップして ことばを見てみよう',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
            ),
          ),
        ),

        // ── セクションごとに描画 ──
        for (final section in sections) ...[
          // セクションヘッダー
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                  section.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
              ),
            ),
          ),

          // グループカード
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final group = section.value[index];
                  final isPlaying = _playingGroupId == group.id;
                  final selectedSpelling = _getSelectedSpelling(group.id);

                  return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SoundGroupCard(
                        group: group,
                        isPlaying: isPlaying,
                        selectedSpelling: selectedSpelling,
                        playingWord: _playingWord,
                        onPlaySound: () => _playGroupSound(group),
                        onSelectSpelling: (spelling) =>
                            _toggleSpelling(group.id, spelling),
                        onPlayWord: _playWord,
                      ),
                  );
                },
                childCount: section.value.length,
              ),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

// ═══════════════════════════════════════════
//  Sound Group Card
// ═══════════════════════════════════════════

class _SoundGroupCard extends StatelessWidget {
  const _SoundGroupCard({
    required this.group,
    required this.isPlaying,
    required this.selectedSpelling,
    required this.playingWord,
    required this.onPlaySound,
    required this.onSelectSpelling,
    required this.onPlayWord,
  });

  final SoundGroup group;
  final bool isPlaying;
  final String? selectedSpelling;
  final String? playingWord;
  final VoidCallback onPlaySound;
  final ValueChanged<String> onSelectSpelling;
  final ValueChanged<String> onPlayWord;

  @override
  Widget build(BuildContext context) {
    final groupColor = Color(group.color);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPlaying
              ? groupColor.withValues(alpha: 0.5)
              : AppColors.surfaceDim,
          width: isPlaying ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          // ── ヘッダー ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'グループ：',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                // 音名バッジ
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    group.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: groupColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // IPA
                Text(
                  '/${group.ipa}/',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                // スピーカーボタン（ヘッダー内）
                _SpeakerButton(
                  isPlaying: isPlaying,
                  color: groupColor,
                  onTap: onPlaySound,
                  size: 36,
                ),
              ],
            ),
          ),

          // ── 綴りタイルとその単語 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: group.spellings.map((spelling) {
                final isSelected = selectedSpelling == spelling;
                final words = getWordsForSpelling(group, spelling);

                return Column(
                  children: [
                    // スペリングタイル（タップ可能）
                    GestureDetector(
                      onTap: () => onSelectSpelling(spelling),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? groupColor.withValues(alpha: 0.08)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isSelected
                                ? groupColor
                                : AppColors.surfaceDim,
                            width: isSelected ? 2 : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              spelling,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isSelected
                                    ? groupColor
                                    : groupColor.withValues(alpha: 0.7),
                                fontFamily: 'monospace',
                              ),
                            ),
                            const Spacer(),
                            // 単語数バッジ
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? groupColor.withValues(alpha: 0.15)
                                    : AppColors.surfaceDim,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${words.length} words',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? groupColor
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedRotation(
                              turns: isSelected ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.expand_more_rounded,
                                color: isSelected
                                    ? groupColor
                                    : AppColors.textTertiary,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── 展開: スペリング別の単語 ──
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: words.isNotEmpty
                          ? _SpellingWordList(
                              words: words,
                              spelling: spelling,
                              groupColor: groupColor,
                              playingWord: playingWord,
                              onPlayWord: onPlayWord,
                            )
                          : const SizedBox.shrink(),
                      crossFadeState: isSelected
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),

                    if (spelling != group.spellings.last)
                      const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── スペリング別の単語リスト ──

class _SpellingWordList extends StatelessWidget {
  const _SpellingWordList({
    required this.words,
    required this.spelling,
    required this.groupColor,
    required this.playingWord,
    required this.onPlayWord,
  });

  final List<WordItem> words;
  final String spelling;
  final Color groupColor;
  final String? playingWord;
  final ValueChanged<String> onPlayWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                '「$spelling」のつづりを使うことば',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: words.map((word) {
              final isPlaying = playingWord == word.word;
              return GestureDetector(
                onTap: () => onPlayWord(word.word),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? groupColor.withValues(alpha: 0.15)
                        : AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isPlaying
                          ? groupColor
                          : AppColors.surfaceDim,
                      width: isPlaying ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlaying
                            ? Icons.volume_up_rounded
                            : Icons.play_circle_outline_rounded,
                        size: 16,
                        color:
                            isPlaying ? groupColor : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        word.word,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isPlaying
                              ? groupColor
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        word.meaning,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── スピーカーボタン ──

class _SpeakerButton extends StatelessWidget {
  const _SpeakerButton({
    required this.isPlaying,
    required this.color,
    required this.onTap,
    this.size = 52,
  });

  final bool isPlaying;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.textPrimary
              : AppColors.textPrimary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Icon(
          Icons.volume_up_rounded,
          color: AppColors.onPrimary,
          size: size * 0.5,
        ),
      ),
    );
  }
}
