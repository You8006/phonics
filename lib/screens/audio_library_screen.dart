import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/word_data.dart';
import '../services/settings_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'phonics_dictionary_screen.dart';

/// 表示モード
enum LibraryViewMode { words, phonicsDictionary }

/// 再生速度
enum _PlayMode { slow, normal }

/// 音声ライブラリー画面: カテゴリ別に100単語を表示し、3種の音声で聞ける
class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  String _searchQuery = '';
  late final TextEditingController _searchController;
  String? _playingWord;
    @override
    void initState() {
      super.initState();
      _searchController = TextEditingController();
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

  _PlayMode? _playMode;
  LibraryViewMode _viewMode = LibraryViewMode.words;

  List<WordItem> _filteredWordsForLocale(String languageCode, String? selectedCategory) {
    var list = wordLibrary.toList();
    if (selectedCategory != null) {
      list = list.where((w) => w.category == selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((w) =>
              w.word.toLowerCase().contains(q) ||
              w.meaningFor(languageCode).toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<void> _playWordSlow(String word) async {
    setState(() { _playingWord = word; _playMode = _PlayMode.slow; });
    await TtsService.speakLibraryWordSlow(word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() { _playingWord = null; _playMode = null; });
  }

  Future<void> _playWordNormal(String word) async {
    setState(() { _playingWord = word; _playMode = _PlayMode.normal; });
    await TtsService.speakLibraryWordNormal(word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() { _playingWord = null; _playMode = null; });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          // ── 表示モード切替 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
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
                      label: l10n.wordsTab,
                      selected: _viewMode == LibraryViewMode.words,
                      onTap: () => setState(
                          () => _viewMode = LibraryViewMode.words),
                    ),
                  ),
                  Expanded(
                    child: _ViewModeTab(
                      label: l10n.phonicsTab,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // SettingsService の検索クエリとコントローラを同期（build 内の副作用を回避）
    final settings = context.read<SettingsService>();
    if (_searchController.text != settings.audioLibrarySearchQuery) {
      _searchController.value = TextEditingValue(
        text: settings.audioLibrarySearchQuery,
        selection: TextSelection.collapsed(
          offset: settings.audioLibrarySearchQuery.length,
        ),
      );
      _searchQuery = settings.audioLibrarySearchQuery;
    }
  }

  Widget _buildWordLibrary() {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final settings = context.watch<SettingsService>();
    final selectedCategory = settings.audioLibrarySelectedCategory;
    final filteredWords = _filteredWordsForLocale(languageCode, selectedCategory);
    final ipaOnlyMode = settings.ipaOnlyReadingMode;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── ヘッダー ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.sm),
            child: Row(
              children: [
                Text(
                  l10n.wordLibrary,
                  style: AppTextStyle.pageHeading,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    l10n.nWords(filteredWords.length),
                    style: const TextStyle(
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
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) {
                    setState(() => _searchQuery = v);
                    context.read<SettingsService>().setAudioLibrarySearchQuery(v);
                  },
                  decoration: InputDecoration(
                    hintText: l10n.searchWords,
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

          // ── 読み表示モード ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
              child: Row(
                children: [
                  Text(
                    l10n.readingDisplayLabel,
                    style: AppTextStyle.label,
                  ),
                  const SizedBox(width: 8),
                  _ModeChip(
                    label: l10n.readingDisplayIpa,
                    selected: ipaOnlyMode,
                    onTap: () => context.read<SettingsService>().setIpaOnlyReadingMode(true),
                  ),
                  const SizedBox(width: 6),
                  _ModeChip(
                    label: l10n.readingDisplayDetail,
                    selected: !ipaOnlyMode,
                    onTap: () => context.read<SettingsService>().setIpaOnlyReadingMode(false),
                  ),
                ],
              ),
            ),
          ),

          // ── カテゴリフィルター ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _CategoryChip(
                    label: l10n.allCategories,
                    color: AppColors.primary,
                    selected: selectedCategory == null,
                    onTap: () =>
                        context.read<SettingsService>().setAudioLibrarySelectedCategory(null),
                  ),
                  for (final cat in wordCategories)
                    _CategoryChip(
                      label: cat.labelFor(languageCode),
                      color: Color(cat.color),
                      selected: selectedCategory == cat.id,
                      onTap: () => context
                          .read<SettingsService>()
                          .setAudioLibrarySelectedCategory(
                              selectedCategory == cat.id ? null : cat.id),
                    ),
                ],
              ),
            ),
          ),

          // ── 単語リスト ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final word = filteredWords[index];
                    final readingText = ipaOnlyMode
                      ? word.ipaReading()
                      : word.readingFor(languageCode);
                  final cat = wordCategories.firstWhere(
                    (c) => c.id == word.category,
                    orElse: () => wordCategories.first,
                  );
                  final isPlaying = _playingWord == word.word;
                  final playMode = isPlaying ? _playMode : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _WordCard(
                      word: word,
                      readingText: readingText,
                      category: cat,
                      isPlaying: isPlaying,
                      playMode: playMode,
                      onPlaySlow: () => _playWordSlow(word.word),
                      onPlayNormal: () => _playWordNormal(word.word),
                    ),
                  );
                },
                childCount: filteredWords.length,
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

// ── カテゴリチップ ──

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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: AppDecoration.chip(color, selected: selected),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.onPrimary : color,
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
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
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.surfaceDim),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.onPrimary : AppColors.textSecondary,
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
    required this.readingText,
    required this.category,
    required this.isPlaying,
    required this.playMode,
    required this.onPlaySlow,
    required this.onPlayNormal,
  });

  final WordItem word;
  final String readingText;
  final WordCategory category;
  final bool isPlaying;
  final _PlayMode? playMode;
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
          width: isPlaying ? AppBorder.selected : AppBorder.thin,
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
                      color: playMode == _PlayMode.slow
                          ? catColor
                          : catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.slow_motion_video,
                      color: playMode == _PlayMode.slow ? AppColors.onPrimary : catColor,
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
                      color: playMode == _PlayMode.normal
                          ? catColor
                          : catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: playMode == _PlayMode.normal ? AppColors.onPrimary : catColor,
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
                            word.meaningFor(Localizations.localeOf(context).languageCode),
                            style: AppTextStyle.label,
                          ),
                        ],
                      ),
                      if (readingText.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          readingText,
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
