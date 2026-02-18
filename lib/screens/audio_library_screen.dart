import 'package:flutter/material.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
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

  Future<void> _playWordSlow(String word) async {
    setState(() => _playingWord = word);
    await TtsService.speakLibraryWordSlow(word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _playingWord = null);
  }

  Future<void> _playWordNormal(String word) async {
    setState(() => _playingWord = word);
    await TtsService.speakLibraryWordNormal(word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _playingWord = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── 表示モード切替 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: _ViewModeTab(
                      label: 'Words',
                      selected: _viewMode == LibraryViewMode.words,
                      onTap: () => setState(
                          () => _viewMode = LibraryViewMode.words),
                    ),
                  ),
                  Expanded(
                    child: _ViewModeTab(
                      label: 'Phonics',
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
            child: Row(
              children: [
                Text(
                  'Word Library',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_filteredWords.length} words',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

          // ── 検索バー ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search words...',
                    hintStyle: TextStyle(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textTertiary,
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

          // ── カテゴリチップ ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: wordCategories.length + 1, // +1 for "All"
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return _CategoryChip(
                      label: 'All',
                      color: AppColors.primary,
                      selected: _selectedCategory == null,
                      onTap: () =>
                          setState(() => _selectedCategory = null),
                    );
                  }
                  final cat = wordCategories[i - 1];
                  return _CategoryChip(
                    label: cat.nameJa,
                    color: Color(cat.color),
                    selected: _selectedCategory == cat.id,
                    onTap: () =>
                        setState(() => _selectedCategory = cat.id),
                  );
                },
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

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _WordCard(
                      word: word,
                      category: cat,
                      isPlaying: isPlaying,
                      onPlaySlow: () => _playWordSlow(word.word),
                      onPlayNormal: () => _playWordNormal(word.word),
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
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
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
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? color : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : AppColors.surfaceDim,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            ),
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
    required this.onPlaySlow,
    required this.onPlayNormal,
  });

  final WordItem word;
  final WordCategory category;
  final bool isPlaying;
  final VoidCallback onPlaySlow;
  final VoidCallback onPlayNormal;

  @override
  Widget build(BuildContext context) {
    final catColor = Color(category.color);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: (isPlaying ? catColor : Colors.black).withValues(alpha: isPlaying ? 0.15 : 0.04),
            blurRadius: isPlaying ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPlaying ? catColor.withValues(alpha: 0.5) : AppColors.surfaceDim,
          width: isPlaying ? 2 : 1,
        ),
      ),
      child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── 再生ボタン (ゆっくり) ──
                GestureDetector(
                  onTap: onPlaySlow,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? catColor
                          : catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.slow_motion_video,
                      color: isPlaying ? AppColors.onPrimary : catColor,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // ── 再生ボタン (ふつう) ──
                GestureDetector(
                  onTap: onPlayNormal,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? catColor
                          : catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: isPlaying ? AppColors.onPrimary : catColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

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
                              color: isPlaying ? catColor : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            word.meaning,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
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
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ── カテゴリ表示 ──
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: catColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
