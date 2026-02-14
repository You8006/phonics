import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';

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

  void _speakCurrent() {
    final item = _items[_current];
    TtsService.speakSound(item);
  }

  void _speakExample() {
    final item = _items[_current];
    if (item.example.isNotEmpty) {
      TtsService.speakWord(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── ページインジケーター ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '${_current + 1} / ${_items.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),

          // ── カードビュー ──
          Expanded(
            child: PageView.builder(
              controller: _page,
              itemCount: _items.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 文字
                          Text(
                            item.letter,
                            style: TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 発音記号
                          Text(
                            '/${item.ipa.isEmpty ? item.sound : item.ipa}/',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Play Sound
                          FilledButton.tonalIcon(
                            onPressed: _speakCurrent,
                            icon: const Icon(Icons.volume_up, size: 28),
                            label: const Text(
                              'Play Sound',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(200, 52),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 例単語
                          if (item.example.isNotEmpty) ...[
                            const Divider(),
                            const SizedBox(height: 8),
                            const Text(
                              'Example word',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: _speakExample,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.example,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: cs.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── ナビゲーション矢印 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: _current > 0
                      ? () => _page.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                // ドットインジケーター
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_items.length, (i) {
                    return Container(
                      width: i == _current ? 10 : 6,
                      height: i == _current ? 10 : 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _current ? cs.primary : Colors.grey.shade400,
                      ),
                    );
                  }),
                ),
                IconButton.filledTonal(
                  onPressed: _current < _items.length - 1
                      ? () => _page.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
