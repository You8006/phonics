import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import 'phonics_dictionary_screen.dart';

/// 表示モード
enum LibraryViewMode { words, phonicsDictionary }

/// 音声ライブラリー画面: カテゴリ別に100単語を表示し、3種の音声で聞ける
class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  String? _selectedCategory;
  String _searchQuery = '';
  String? _playingWord;
  LibraryViewMode _viewMode = LibraryViewMode.words;

  List<WordItem> get _filteredWords {
    var words = _selectedCategory != null
        ? getWordsByCategory(_selectedCategory!)
        : wordLibrary;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      words = words
          .where((w) =>
              w.word.toLowerCase().contains(q) ||
              w.meaning.contains(q))
          .toList();
    }
    return words;
  }

  WordCategory? get _currentCategory {
    if (_selectedCategory == null) return null;
    return wordCategories.firstWhere(
      (c) => c.id == _selectedCategory,
      orElse: () => wordCategories.first,
    );
  }

  Future<void> _playWord(String word) async {
    setState(() => _playingWord = word);
    await TtsService.speakLibraryWord(word);
    // 短い待機の後にアニメーションを解除
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _playingWord = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ── 表示モード切替 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: FadeInDown(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Expanded(
                      child: _ViewModeTab(
                        label: '📚 ことば',
                        selected: _viewMode == LibraryViewMode.words,
                        onTap: () => setState(
                            () => _viewMode = LibraryViewMode.words),
                      ),
                    ),
                    Expanded(
                      child: _ViewModeTab(
                        label: '🔊 おとずかん',
                        selected:
                            _viewMode == LibraryViewMode.phonicsDictionary,
                        onTap: () => setState(() =>
                            _viewMode = LibraryViewMode.phonicsDictionary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── メインコンテンツ ──
          Expanded(
            child: _viewMode == LibraryViewMode.phonicsDictionary
                ? const PhonicsDictionaryScreen()
                : _buildWordLibrary(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordLibrary() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── ヘッダー ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: FadeInDown(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        const Text(
                          '📚',
                          style: TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Word Library',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2A2A2A),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8E3C).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${wordLibrary.length} words',
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
                      'タップして単語の発音を聞いてみよう',
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

          // ── 検索バー ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search words...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── カテゴリチップ ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: FadeInDown(
                delay: const Duration(milliseconds: 150),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: wordCategories.length + 1, // +1 for "All"
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _CategoryChip(
                        label: 'すべて',
                        emoji: '🌐',
                        color: const Color(0xFFFF8E3C),
                        selected: _selectedCategory == null,
                        onTap: () =>
                            setState(() => _selectedCategory = null),
                      );
                    }
                    final cat = wordCategories[i - 1];
                    return _CategoryChip(
                      label: cat.nameJa,
                      emoji: cat.icon,
                      color: Color(cat.color),
                      selected: _selectedCategory == cat.id,
                      onTap: () =>
                          setState(() => _selectedCategory = cat.id),
                    );
                  },
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── 単語リスト ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final word = _filteredWords[index];
                  final cat = wordCategories.firstWhere(
                    (c) => c.id == word.category,
                    orElse: () => wordCategories.first,
                  );
                  final isPlaying = _playingWord == word.word;

                  return FadeInUp(
                    delay: Duration(milliseconds: 30 * (index % 15)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _WordCard(
                        word: word,
                        category: cat,
                        isPlaying: isPlaying,
                        onPlay: () => _playWord(word.word),
                      ),
                    ),
                  );
                },
                childCount: _filteredWords.length,
              ),
            ),
          ),

          // ── 底部の余白 ──
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      );
  }
}

// ── 表示モードタブ ──

class _ViewModeTab extends StatelessWidget {
  const _ViewModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF2A2A2A) : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

// ── カテゴリフィルターチップ ──

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? color : Colors.grey.shade200,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 単語カード ──

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.category,
    required this.isPlaying,
    required this.onPlay,
  });

  final WordItem word;
  final WordCategory category;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final catColor = Color(category.color);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPlaying ? catColor : Colors.black).withValues(alpha: isPlaying ? 0.15 : 0.04),
            blurRadius: isPlaying ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPlaying ? catColor.withValues(alpha: 0.5) : Colors.grey.shade100,
          width: isPlaying ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPlay,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── 再生ボタン ──
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? catColor
                        : catColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.volume_up_rounded
                        : Icons.play_arrow_rounded,
                    color: isPlaying ? Colors.white : catColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),

                // ── 単語情報 ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            word.word,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isPlaying ? catColor : const Color(0xFF2A2A2A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            word.meaning,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (word.phonicsNote.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          word.phonicsNote,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ── カテゴリバッジ ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
