import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/sound_group_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';

/// フォニックスのおとずかん — 同じ音のグループごとに綴りを表示
class PhonicsDictionaryScreen extends StatefulWidget {
  const PhonicsDictionaryScreen({super.key});

  @override
  State<PhonicsDictionaryScreen> createState() =>
      _PhonicsDictionaryScreenState();
}

class _PhonicsDictionaryScreenState extends State<PhonicsDictionaryScreen> {
  String? _playingGroupId;
  String? _expandedGroupId;
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

  /// グループの展開/折りたたみ
  void _toggleExpand(String groupId) {
    setState(() {
      _expandedGroupId = _expandedGroupId == groupId ? null : groupId;
    });
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
            child: FadeInDown(
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
                          color: Color(0xFF2A2A2A),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8E3C)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${soundGroups.length} sounds',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF8E3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'おなじ音をだす いろいろな つづりを見てみよう',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── セクションごとに描画 ──
        for (final section in sections) ...[
          // セクションヘッダー
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: FadeInLeft(
                child: Text(
                  section.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5D4037),
                  ),
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
                  final isExpanded = _expandedGroupId == group.id;
                  final isPlaying = _playingGroupId == group.id;

                  return FadeInUp(
                    delay: Duration(milliseconds: 50 * (index % 10)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SoundGroupCard(
                        group: group,
                        isPlaying: isPlaying,
                        isExpanded: isExpanded,
                        playingWord: _playingWord,
                        onPlaySound: () => _playGroupSound(group),
                        onToggleExpand: () => _toggleExpand(group.id),
                        onPlayWord: _playWord,
                      ),
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
    required this.isExpanded,
    required this.playingWord,
    required this.onPlaySound,
    required this.onToggleExpand,
    required this.onPlayWord,
  });

  final SoundGroup group;
  final bool isPlaying;
  final bool isExpanded;
  final String? playingWord;
  final VoidCallback onPlaySound;
  final VoidCallback onToggleExpand;
  final ValueChanged<String> onPlayWord;

  @override
  Widget build(BuildContext context) {
    final groupColor = Color(group.color);
    final words = getWordsForGroup(group);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPlaying
              ? groupColor.withValues(alpha: 0.5)
              : const Color(0xFFE0D6CC),
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
              color: const Color(0xFF5D4037),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // 音名バッジ
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                if (words.isNotEmpty)
                  GestureDetector(
                    onTap: onToggleExpand,
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.expand_more_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── 綴りタイル ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: group.spellings.map((spelling) {
                      return GestureDetector(
                        onTap: () {
                          // タップしたら展開 + 音再生
                          onToggleExpand();
                          onPlaySound();
                        },
                        child: _SpellingTile(
                          spelling: spelling,
                          color: groupColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // スピーカーボタン
                _SpeakerButton(
                  isPlaying: isPlaying,
                  color: groupColor,
                  onTap: onPlaySound,
                ),
              ],
            ),
          ),

          // ── 展開: 例単語 ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: words.isNotEmpty
                ? _WordExamplesSection(
                    words: words,
                    groupColor: groupColor,
                    playingWord: playingWord,
                    onPlayWord: onPlayWord,
                  )
                : const SizedBox.shrink(),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── 綴りタイル ──

class _SpellingTile extends StatelessWidget {
  const _SpellingTile({
    required this.spelling,
    required this.color,
  });

  final String spelling;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 52, minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0D6CC),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          spelling,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
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
  });

  final bool isPlaying;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isPlaying
              ? const Color(0xFF5D4037)
              : const Color(0xFF5D4037).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(26),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: const Color(0xFF5D4037).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Icon(
          isPlaying ? Icons.volume_up_rounded : Icons.volume_up_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

// ── 例単語セクション ──

class _WordExamplesSection extends StatelessWidget {
  const _WordExamplesSection({
    required this.words,
    required this.groupColor,
    required this.playingWord,
    required this.onPlayWord,
  });

  final List<WordItem> words;
  final Color groupColor;
  final String? playingWord;
  final ValueChanged<String> onPlayWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey.shade200,
            height: 1,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                'この音をつかう ことば',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPlaying
                          ? groupColor
                          : Colors.grey.shade200,
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
                        color: isPlaying ? groupColor : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        word.word,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isPlaying
                              ? groupColor
                              : const Color(0xFF2A2A2A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        word.meaning,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
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
