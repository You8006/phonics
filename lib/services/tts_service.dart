import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/phonics_data.dart';

// ═══════════════════════════════════════════
//  TTS Service
// ═══════════════════════════════════════════

/// 音声タイプ: female(既存), male, child
enum VoiceType { female, male, child }

class TtsService {
  TtsService._();
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);   // 短い音声向け低遅延モード
  static final AudioPlayer _sePlayer = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);   // SE も低遅延モード
  static bool _ready = false;

  /// 現在選択中の声
  static VoiceType _voiceType = VoiceType.female;
  static VoiceType get voiceType => _voiceType;

  /// 声を変更して SharedPreferences に保存
  static Future<void> setVoiceType(VoiceType type) async {
    _voiceType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phonics_voice_type', type.name);
  }

  /// SharedPreferences から声設定を復元
  static Future<void> loadVoiceType() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('phonics_voice_type');
    if (saved != null) {
      _voiceType = VoiceType.values.firstWhere(
        (v) => v.name == saved,
        orElse: () => VoiceType.female,
      );
    }
  }

  static VoiceType? _lastAppliedVoice;

  static Future<void> _init() async {
    await _tts.setLanguage('en-US');

    // 声タイプに応じて pitch / rate / voice を調整
    if (!_ready || _lastAppliedVoice != _voiceType) {
      switch (_voiceType) {
        case VoiceType.female:
          await _tts.setPitch(1.1);
          await _tts.setSpeechRate(0.45);
          break;
        case VoiceType.male:
          await _tts.setPitch(0.8);
          await _tts.setSpeechRate(0.42);
          break;
        case VoiceType.child:
          await _tts.setPitch(1.4);
          await _tts.setSpeechRate(0.5);
          break;
      }
      _lastAppliedVoice = _voiceType;
    }
    _ready = true;
  }

  /// 声タイプに応じたオーディオパスのプレフィックスを返す
  static String _voicePrefix() {
    switch (_voiceType) {
      case VoiceType.female:
        return 'audio'; // 既存: audio/sounds/, audio/words/
      case VoiceType.male:
        return 'audio/male'; // audio/male/sounds/, audio/male/words/
      case VoiceType.child:
        return 'audio/child'; // audio/child/sounds/, audio/child/words/
    }
  }

  /// ファイル名用キーを生成（phonics_data の letter + sound）
  static String _audioKey(PhonicsItem item) {
    return '${item.letter}_${item.sound}'.replaceAll('-', '_');
  }

  /// プリレコードされたフォニックス音を再生
  static Future<void> speakSound(PhonicsItem item) async {
    final key = _audioKey(item);
    final prefix = _voicePrefix();
    try {
      _player.stop(); // await しない — 即座に次の play へ
      await _player.play(AssetSource('$prefix/sounds/sound_$key.mp3'));
    } catch (e) {
      debugPrint('No audio file for sound $key: $e');
    }
  }

  /// プリレコードされた例単語を再生
  static Future<void> speakWord(PhonicsItem item) async {
    final key = _audioKey(item);
    final prefix = _voicePrefix();
    try {
      _player.stop();
      await _player.play(AssetSource('$prefix/words/word_$key.mp3'));
    } catch (e) {
      // フォールバック: TTS で読み上げ
      debugPrint('Audio fallback for word $key: $e');
      await speak(item.example);
    }
  }

  /// フォニックスパターンの音を再生
  /// phonics_data.dart の PhonicsItem から正確にキーを導出する
  static Future<void> speakPhonicsPattern(String pattern) async {
    // phonics_data の全アイテムから letter が一致するものを探す
    final items = allPhonicsItems.where((i) => i.letter == pattern).toList();
    if (items.isNotEmpty) {
      // 最初にマッチした PhonicsItem の音声を再生
      await speakSound(items.first);
    }
  }

  /// 単語ライブラリーの単語を再生（ゆっくり → 間 → 通常速度）
  static Future<void> speakLibraryWord(String word) async {
    final key = word.toLowerCase().replaceAll(' ', '_');
    final prefix = _voicePrefix();
    try {
      _player.stop();
      // 1) ゆっくり再生
      final slowPath = '$prefix/words_library/word_${key}_slow.mp3';
      await _player.play(AssetSource(slowPath));
      // 再生完了を待つ
      await _player.onPlayerComplete.first;
      // 2) 少し間を空ける
      await Future.delayed(const Duration(milliseconds: 150));
      // 3) 通常速度で再生
      await _player.play(AssetSource('$prefix/words_library/word_$key.mp3'));
    } catch (e) {
      // フォールバック: TTS で読み上げ（声タイプ反映）
      debugPrint('Audio fallback for library word $key: $e');
      await _init(); // 声タイプを再適用
      await _tts.speak(word);
    }
  }

  /// 正解時の効果音を即時再生
  static Future<void> playCorrect() async {
    try {
      _sePlayer.stop();
      await _sePlayer.play(AssetSource('audio/effects/成功.mp3'));
    } catch (e) {
      debugPrint('Effect fallback for correct: $e');
    }
  }

  /// 不正解時の効果音を即時再生
  static Future<void> playWrong() async {
    try {
      _sePlayer.stop();
      await _sePlayer.play(AssetSource('audio/effects/失敗.mp3'));
    } catch (e) {
      debugPrint('Effect fallback for wrong: $e');
    }
  }

  /// 汎用テキスト読み上げ（TTS フォールバック用）
  static Future<void> speak(String text) async {
    await _init();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    _player.stop();
    _sePlayer.stop();
    _tts.stop();
  }
}

// ═══════════════════════════════════════════
//  Progress Service — グループ解放 & マスター率
// ═══════════════════════════════════════════

class ProgressService {
  static const _prefix = 'phonics_v2_';

  static String _dayKey(DateTime d) => d.toIso8601String().substring(0, 10);

  static DateTime _toDate(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return DateTime.now();
    return DateTime(
      int.tryParse(parts[0]) ?? DateTime.now().year,
      int.tryParse(parts[1]) ?? DateTime.now().month,
      int.tryParse(parts[2]) ?? DateTime.now().day,
    );
  }

  /// 各音ごとの正答数 (letterKey → correct count)
  static Future<Map<String, int>> _loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return {};
    return Map<String, int>.from(json.decode(raw) as Map);
  }

  static Future<void> _saveMap(String key, Map<String, int> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', json.encode(map));
  }

  static Future<Map<String, String>> _loadStringMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return {};
    return Map<String, String>.from(json.decode(raw) as Map);
  }

  static Future<void> _saveStringMap(String key, Map<String, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', json.encode(map));
  }

  /// 正答を記録
  static Future<void> recordCorrect(String progressKey) async {
    final map = await _loadMap('correct');
    map[progressKey] = (map[progressKey] ?? 0) + 1;
    await _saveMap('correct', map);
    await _updateSrs(progressKey, wasCorrect: true);
  }

  /// 出題を記録
  static Future<void> recordAttempt(String progressKey) async {
    final map = await _loadMap('attempts');
    map[progressKey] = (map[progressKey] ?? 0) + 1;
    await _saveMap('attempts', map);
  }

  /// 不正解を記録
  static Future<void> recordWrong(String progressKey) async {
    final map = await _loadMap('wrong');
    map[progressKey] = (map[progressKey] ?? 0) + 1;
    await _saveMap('wrong', map);
    await _updateSrs(progressKey, wasCorrect: false);
  }

  static Future<void> _updateSrs(
    String progressKey, {
    required bool wasCorrect,
  }) async {
    final intervalMap = await _loadMap('srs_interval');
    final dueMap = await _loadStringMap('srs_due');

    final today = DateTime.now();
    int nextInterval;
    if (wasCorrect) {
      final prev = intervalMap[progressKey] ?? 0;
      nextInterval = prev <= 0 ? 1 : (prev * 2);
      if (nextInterval > 30) nextInterval = 30;
    } else {
      nextInterval = 1;
    }

    intervalMap[progressKey] = nextInterval;
    final dueDate = today.add(Duration(days: nextInterval));
    dueMap[progressKey] = _dayKey(dueDate);

    await _saveMap('srs_interval', intervalMap);
    await _saveStringMap('srs_due', dueMap);
  }

  /// グループのマスター率 (0.0 ~ 1.0)
  static Future<double> groupMastery(PhonicsGroup group) async {
    final correct = await _loadMap('correct');
    final attempts = await _loadMap('attempts');
    if (group.items.isEmpty) return 0;
    double total = 0;
    for (final item in group.items) {
      final key = item.progressKey;
      final a = attempts[key] ?? 0;
      final c = correct[key] ?? 0;
      if (a > 0) {
        total += c / a;
      }
    }
    return total / group.items.length;
  }

  /// 文字ごとのマスター率
  static Future<double> letterMastery(String progressKey) async {
    final correct = await _loadMap('correct');
    final attempts = await _loadMap('attempts');
    final a = attempts[progressKey] ?? 0;
    final c = correct[progressKey] ?? 0;
    if (a == 0) return 0;
    return c / a;
  }

  /// 今日復習すべきアイテム（全体）
  static Future<List<PhonicsItem>> getDueItemsAll({int limit = 20}) async {
    final dueMap = await _loadStringMap('srs_due');
    final attempts = await _loadMap('attempts');
    final today = DateTime.now();

    final dueKeys = dueMap.entries
        .where((e) {
          final due = _toDate(e.value);
          return !due.isAfter(DateTime(today.year, today.month, today.day));
        })
        .map((e) => e.key)
        .toSet();

    final dueItems = allPhonicsItems
        .where((item) => dueKeys.contains(item.progressKey))
        .where((item) => (attempts[item.progressKey] ?? 0) > 0)
        .take(limit)
        .toList();

    return dueItems;
  }

  /// 今日復習すべきアイテム（グループ）
  static Future<List<PhonicsItem>> getDueItemsForGroup(
    PhonicsGroup group, {
    int limit = 12,
  }) async {
    final dueMap = await _loadStringMap('srs_due');
    final attempts = await _loadMap('attempts');
    final today = DateTime.now();

    final due = group.items.where((item) {
      final day = dueMap[item.progressKey];
      if (day == null) return false;
      final d = _toDate(day);
      return !d.isAfter(DateTime(today.year, today.month, today.day)) &&
          (attempts[item.progressKey] ?? 0) > 0;
    }).take(limit).toList();

    return due;
  }

  /// グループ内の苦手アイテムを返す（不正解率高い順）
  static Future<List<PhonicsItem>> weakItemsForGroup(
    PhonicsGroup group, {
    int limit = 8,
    int minAttempts = 2,
  }) async {
    final correct = await _loadMap('correct');
    final attempts = await _loadMap('attempts');
    final wrong = await _loadMap('wrong');

    final scored = <({PhonicsItem item, double score})>[];

    for (final item in group.items) {
      final key = item.progressKey;
      final a = attempts[key] ?? 0;
      final c = correct[key] ?? 0;
      final w = wrong[key] ?? 0;
      if (a < minAttempts) continue;

      // 不正解率 + 実際の不正解数を少し加味
      final wrongRate = a == 0 ? 0 : (a - c) / a;
      final weighted = wrongRate + (w * 0.02);
      if (weighted > 0.2) {
        scored.add((item: item, score: weighted));
      }
    }

    scored.sort((x, y) => y.score.compareTo(x.score));
    return scored.take(limit).map((e) => e.item).toList();
  }

  /// 苦手候補の件数
  static Future<int> weakItemCountForGroup(PhonicsGroup group) async {
    final items = await weakItemsForGroup(group, limit: group.items.length);
    return items.length;
  }

  /// グループが解放済みか (前グループ 60%以上 or Group 1)
  static Future<bool> isGroupUnlocked(int groupId) async {
    if (groupId == 0) return true;
    final prev = phonicsGroups[groupId - 1];
    final mastery = await groupMastery(prev);
    return mastery >= 0.6;
  }

  /// 累計スコア
  static Future<int> totalCorrect() async {
    final map = await _loadMap('correct');
    return map.values.fold<int>(0, (a, b) => a + b);
  }

  /// ストリーク（連続日数）
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefix}streak') ?? 0;
  }

  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDay = prefs.getString('${_prefix}last_day') ?? '';
    final streak = prefs.getInt('${_prefix}streak') ?? 0;

    if (lastDay == today) return; // 今日は記録済み

    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
    if (lastDay == yesterday) {
      await prefs.setInt('${_prefix}streak', streak + 1);
    } else {
      await prefs.setInt('${_prefix}streak', 1);
    }
    await prefs.setString('${_prefix}last_day', today);
  }

  /// 14日学習サイクルの現在日（1-14）
  static Future<int> getFortnightDay() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_prefix}plan_start';
    final stored = prefs.getString(key);

    DateTime start;
    if (stored == null) {
      start = DateTime.now();
      await prefs.setString(key, _dayKey(start));
    } else {
      start = _toDate(stored);
    }

    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(start.year, start.month, start.day))
        .inDays;
    return (diff % 14) + 1;
  }

  /// 2週間ミッションを返す
  static Future<DailyMission> getTodayMission({
    required int dueCount,
    required int streak,
    required double mastery,
  }) async {
    final day = await getFortnightDay();

    final tasks = <String>[];
    if (day <= 3) {
      tasks.add('Sound → Letter を2回プレイ');
      tasks.add('Learn を5分（音の確認）');
    } else if (day <= 6) {
      tasks.add('Letter → Sound を2回プレイ');
      tasks.add('Blending Builder を1回プレイ');
    } else if (day <= 9) {
      tasks.add('IPA → Letter を2回プレイ');
      tasks.add('Word Chaining を1回プレイ');
    } else if (day <= 12) {
      tasks.add('Minimal Pair Listening を2回プレイ');
      tasks.add('Weakness Drill を1回プレイ');
    } else {
      tasks.add('全モードから3ゲームを自由に選んでプレイ');
      tasks.add('間違えた音を Learn で復習');
    }

    if (dueCount > 0) {
      tasks.insert(0, 'SRS復習: 期限到来 $dueCount 件を処理');
    }
    if (streak < 3) {
      tasks.add('連続学習を維持（今日1セッション完了）');
    }

    final phase = day <= 4
        ? '基礎'
        : day <= 9
            ? '定着'
            : '応用';

    final tip = mastery < 0.4
        ? '音を先に聞いてから選ぶと定着しやすいです。'
        : mastery < 0.7
            ? '苦手音の復習を先にすると正答率が上がります。'
            : '応用モード（IPA/Minimal Pair）中心に進めましょう。';

    return DailyMission(
      day: day,
      phase: phase,
      title: 'Day $day / 14 ミッション',
      tasks: tasks,
      tip: tip,
    );
  }
}

class DailyMission {
  const DailyMission({
    required this.day,
    required this.phase,
    required this.title,
    required this.tasks,
    required this.tip,
  });

  final int day;
  final String phase;
  final String title;
  final List<String> tasks;
  final String tip;
}

class AdaptivePlan {
  const AdaptivePlan({
    required this.level,
    required this.numOptions,
    required this.questionCount,
  });

  final String level;
  final int numOptions;
  final int questionCount;
}

extension ProgressAdaptive on ProgressService {
  static Future<AdaptivePlan> getAdaptivePlanForGroup(PhonicsGroup group) async {
    final mastery = await ProgressService.groupMastery(group);
    final weak = await ProgressService.weakItemCountForGroup(group);

    if (mastery < 0.35 || weak >= 6) {
      return AdaptivePlan(
        level: 'Starter',
        numOptions: group.items.length >= 2 ? 2 : 1,
        questionCount: 8,
      );
    }

    if (mastery < 0.7 || weak >= 3) {
      return AdaptivePlan(
        level: 'Core',
        numOptions: group.items.length >= 3 ? 3 : group.items.length,
        questionCount: 10,
      );
    }

    return AdaptivePlan(
      level: 'Challenge',
      numOptions: group.items.length >= 4 ? 4 : group.items.length,
      questionCount: 12,
    );
  }
}

// ═══════════════════════════════════════════
//  Letter Card Widget
// ═══════════════════════════════════════════

class LetterCard extends StatelessWidget {
  const LetterCard({
    super.key,
    required this.letter,
    required this.onTap,
    this.color,
    this.size = 32,
  });

  final String letter;
  final VoidCallback onTap;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
