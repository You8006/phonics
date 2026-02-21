import 'package:flutter/material.dart';
import 'package:phonics/l10n/app_localizations.dart';
import '../models/phonics_data.dart';
import '../models/sound_group_data.dart';
import '../models/word_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// Learn 画面: カードをスワイプして音を聞く + 例単語
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.group});

  final PhonicsGroup group;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late final PageController _page;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _page = PageController();
  }

  @override
  void dispose() {
    _page.dispose();
    TtsService.stop();
    super.dispose();
  }

  List<PhonicsItem> get _items => widget.group.items;

  List<Widget> _buildRelatedWords(PhonicsItem item) {
    final words = _relatedWords(item);
    if (words.isEmpty) return [];

    String meaning(String key) {
      final wi = wordLibrary.cast<WordItem?>().firstWhere(
            (w) => w!.word.toLowerCase() == key,
            orElse: () => null,
          );
      return wi?.meaning ?? '';
    }

    return [
      const Divider(height: 32, color: AppColors.surfaceDim),
      Text(
        AppLocalizations.of(context)?.exampleWords ?? 'Example words',
        style: AppTextStyle.caption,
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: words.map((w) {
          final m = meaning(w);
          return ActionChip(
            avatar: const Icon(Icons.volume_up_rounded,
                size: 16, color: AppColors.primary),
            label: Text(
              m.isNotEmpty ? '$w ($m)' : w,
              style: const TextStyle(fontSize: 14),
            ),
            side: BorderSide(color: AppColors.surfaceDim),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            onPressed: () => TtsService.speakLibraryWordNormal(w),
          );
        }).toList(),
      ),
    ];
  }

  void _speakCurrent() {
    final item = _items[_current];
    TtsService.speakSound(item);
  }

  List<String> _relatedWords(PhonicsItem item) {
    final letter = item.letter.toLowerCase();
    for (final sg in soundGroups) {
      if (sg.spellingWords.containsKey(letter)) {
        return sg.spellingWords[letter]!.take(6).toList();
      }
    }
    if (item.example.isNotEmpty) return [item.example.toLowerCase()];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              '${_current + 1} / ${_items.length}',
              style: AppTextStyle.caption,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _page,
              itemCount: _items.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Container(
                    decoration: AppDecoration.card(),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.letter,
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '/${item.ipa.isEmpty ? item.sound : item.ipa}/',
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          FilledButton.tonalIcon(
                            onPressed: _speakCurrent,
                            icon:
                                const Icon(Icons.volume_up_rounded, size: 24),
                            label: Text(l10n.playSound,
                                style: const TextStyle(fontSize: 16)),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(180, 48),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ..._buildRelatedWords(item),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: _current > 0
                      ? () => _page.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_items.length, (i) {
                    return Container(
                      width: i == _current ? 8 : 5,
                      height: i == _current ? 8 : 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _current
                            ? AppColors.primary
                            : AppColors.surfaceDim,
                      ),
                    );
                  }),
                ),
                IconButton.filledTonal(
                  onPressed: _current < _items.length - 1
                      ? () => _page.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                      : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
