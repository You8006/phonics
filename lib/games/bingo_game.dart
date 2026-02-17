import 'dart:math';
import 'package:flutter/material.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

class BingoGame extends StatefulWidget {
  final List<PhonicsItem> items;
  final int gridSize;

  const BingoGame({
    super.key,
    required this.items,
    this.gridSize = 3,
  });

  @override
  State<BingoGame> createState() => _BingoGameState();
}

class _BingoGameState extends State<BingoGame> {
  final _rng = Random();
  late List<PhonicsItem> _boardItems;
  late PhonicsItem _currentTarget;
  final Set<int> _markedIndices = {};
  bool _bingo = false;
  int _wrongCount = 0;

  @override
  void initState() {
    super.initState();
    _setupBoard();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  void _setupBoard() {
    final totalCells = widget.gridSize * widget.gridSize;

    // Build unique items for the board (no duplicates by progressKey)
    // Use full phonics library as pool if user-selected items are too few
    final pool = <PhonicsItem>[];
    pool.addAll(widget.items);
    if (pool.length < totalCells) {
      // Pad from full phonics data
      for (final item in allPhonicsItems) {
        if (!pool.any((p) => p.progressKey == item.progressKey)) {
          pool.add(item);
        }
        if (pool.length >= totalCells) break;
      }
    }
    pool.shuffle(_rng);

    // 同じ letter のアイテムをボードに載せない（oo/oo, th/th の視覚重複防止）
    final unique = <String, PhonicsItem>{};
    final usedLetters = <String>{};
    for (final item in pool) {
      if (unique.length >= totalCells) break;
      if (!unique.containsKey(item.progressKey) && !usedLetters.contains(item.letter)) {
        unique[item.progressKey] = item;
        usedLetters.add(item.letter);
      }
    }
    // letter重複回避で不足した場合は、progressKey重複のみ回避して埋める
    if (unique.length < totalCells) {
      for (final item in pool) {
        if (unique.length >= totalCells) break;
        if (!unique.containsKey(item.progressKey)) {
          unique[item.progressKey] = item;
        }
      }
    }

    setState(() {
      _boardItems = unique.values.toList()..shuffle(_rng);
      _markedIndices.clear();
      _bingo = false;
      _wrongCount = 0;
    });

    _nextTarget();
  }

  void _nextTarget() {
    final availableIndices = List.generate(_boardItems.length, (i) => i)
        .where((i) => !_markedIndices.contains(i))
        .toList();

    if (availableIndices.isEmpty) {
      setState(() => _bingo = true);
      // _onCellTap で既に playCorrect() 済みなので二重再生しない
      return;
    }

    final targetIndex = availableIndices[_rng.nextInt(availableIndices.length)];
    setState(() {
      _currentTarget = _boardItems[targetIndex];
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _playSound();
    });
  }

  Future<void> _playSound() async {
    await TtsService.speakSound(_currentTarget);
  }

  Future<void> _onCellTap(int index) async {
    if (_markedIndices.contains(index) || _bingo) return;

    // Record attempt for the target
    ProgressService.recordAttempt(_currentTarget.progressKey);

    // Compare by progressKey for exact match
    if (_boardItems[index].progressKey == _currentTarget.progressKey) {
      ProgressService.recordCorrect(_currentTarget.progressKey);
      setState(() {
        _markedIndices.add(index);
      });
      await TtsService.playCorrect();
      _checkBingo();
      if (!_bingo) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        _nextTarget();
      }
    } else {
      ProgressService.recordWrong(_currentTarget.progressKey);
      setState(() => _wrongCount++);
      await TtsService.playWrong();
    }
  }

  void _checkBingo() {
    final n = widget.gridSize;

    // Rows
    for (int r = 0; r < n; r++) {
      bool rowFull = true;
      for (int c = 0; c < n; c++) {
        if (!_markedIndices.contains(r * n + c)) rowFull = false;
      }
      if (rowFull) {
        _triggerBingo();
        return;
      }
    }

    // Cols
    for (int c = 0; c < n; c++) {
      bool colFull = true;
      for (int r = 0; r < n; r++) {
        if (!_markedIndices.contains(r * n + c)) colFull = false;
      }
      if (colFull) {
        _triggerBingo();
        return;
      }
    }

    // Diagonals
    bool d1 = true, d2 = true;
    for (int i = 0; i < n; i++) {
      if (!_markedIndices.contains(i * n + i)) d1 = false;
      if (!_markedIndices.contains(i * n + (n - 1 - i))) d2 = false;
    }
    if (d1 || d2) _triggerBingo();
  }

  void _triggerBingo() {
    setState(() => _bingo = true);
    // No playCorrect here — already played in _onCellTap
    ProgressService.updateStreak();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const CloseButton(color: AppColors.textSecondary),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.grid_on_rounded, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_markedIndices.length} / ${_boardItems.length}',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Sound prompt
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _bingo ? null : _playSound,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                splashColor: accentColor.withValues(alpha: 0.2),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                  ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.volume_up_rounded,
                            size: 32, color: accentColor),
                        const SizedBox(width: 12),
                        Text(
                          'Tap to replay',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bingo banner
            if (_bingo)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: const Text(
                      'BINGO!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onPrimary,
                        letterSpacing: 4,
                      ),
                    ),
                ),
              ),

            const SizedBox(height: 16),

            // Board
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.gridSize * widget.gridSize,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.gridSize,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        if (index >= _boardItems.length) {
                          return const SizedBox.shrink();
                        }
                        final item = _boardItems[index];
                        final isMarked = _markedIndices.contains(index);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onCellTap(index),
                            borderRadius: BorderRadius.circular(16),
                            splashColor: AppColors.correct.withValues(alpha: 0.3),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isMarked
                                    ? AppColors.correct
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                border: Border.all(
                                  color: isMarked
                                      ? AppColors.correct
                                      : AppColors.surfaceDim,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: isMarked
                                  ? const Icon(Icons.check_rounded,
                                          color: AppColors.onPrimary, size: 36)
                                  : Text(
                                      item.letter,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Bottom action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: _bingo
                  ? SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _setupBoard,
                          child: const Text(
                            'New Game',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                    )
                  : Text(
                      'Miss: $_wrongCount',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
