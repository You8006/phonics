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

/// 音声タイプ: female(Jenny), male2(Andrew), child(Ana)
enum VoiceType { female, male2, child }

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
        case VoiceType.male2:
          await _tts.setPitch(0.75);
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
      case VoiceType.male2:
        return 'audio/male2'; // audio/male2/sounds/, audio/male2/words/
      case VoiceType.child:
        return 'audio/child'; // audio/child/sounds/, audio/child/words/
    }
  }

  /// ファイル名用キーを生成（phonics_data の letter + sound）
  static String _audioKey(PhonicsItem item) {
    return '${item.letter}_${item.sound}'.replaceAll('-', '_');
  }

  /// 音量が小さくなりがちな音のキー一覧（TH, 鼻音 など）
  static const _quietSoundKeys = {
    'th_thh', 'th_th_voiced', // TH 系
    'm_mmm', 'n_nnn', 'ng_nng', // 鼻音
  };

  /// プリレコードされたフォニックス音を再生
  static Future<void> speakSound(PhonicsItem item) async {
    final key = _audioKey(item);
    final prefix = _voicePrefix();
    try {
      _player.stop(); // await しない — 即座に次の play へ
      // 音量が小さい音はブーストする
      if (_quietSoundKeys.contains(key)) {
        await _player.setVolume(1.5);
      } else {
        await _player.setVolume(1.0);
      }
      await _player.play(AssetSource('$prefix/sounds/sound_$key.mp3'));
    } catch (e) {
      debugPrint('No audio file for sound $key: $e');
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

  /// 単語ライブラリーの単語を再生（ゆっくり）
  static Future<void> speakLibraryWordSlow(String word) async {
    final key = word.toLowerCase().replaceAll(' ', '_');
    final prefix = _voicePrefix();
    try {
      _player.stop();
      await _player.play(AssetSource('$prefix/words_library/word_${key}_slow.mp3'));
    } catch (e) {
      debugPrint('Audio fallback for library word slow $key: $e');
      await _init();
      await _tts.setSpeechRate(0.3);
      await _tts.speak(word);
    }
  }

  /// 単語ライブラリーの単語を再生（通常速度）
  static Future<void> speakLibraryWordNormal(String word) async {
    final key = word.toLowerCase().replaceAll(' ', '_');
    final prefix = _voicePrefix();
    try {
      _player.stop();
      await _player.play(AssetSource('$prefix/words_library/word_$key.mp3'));
    } catch (e) {
      debugPrint('Audio fallback for library word $key: $e');
      await _init();
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

  /// 指定ボイスでサンプルフレーズを読み上げ (Voice Picker プレビュー用)
  static Future<void> speakSample(VoiceType type) async {
    final prev = _voiceType;
    _voiceType = type;
    _lastAppliedVoice = null; // 強制再初期化
    await _init();
    await _tts.speak("Let's practice phonics!");
    // 元のボイスに戻す
    _voiceType = prev;
    _lastAppliedVoice = null;
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
      tasks.add('Play Sound → Letter twice');
      tasks.add('Learn for 5 min (review sounds)');
    } else if (day <= 6) {
      tasks.add('Play Letter → Sound twice');
      tasks.add('Play Blending Builder once');
    } else if (day <= 9) {
      tasks.add('Play IPA → Letter twice');
      tasks.add('Play Word Chaining once');
    } else if (day <= 12) {
      tasks.add('Play Minimal Pair Listening twice');
      tasks.add('Play Weakness Drill once');
    } else {
      tasks.add('Pick 3 games from any mode');
      tasks.add('Review missed sounds in Learn');
    }

    if (dueCount > 0) {
      tasks.insert(0, 'SRS Review: $dueCount items due');
    }
    if (streak < 3) {
      tasks.add('Keep your streak (finish 1 session today)');
    }

    final phase = day <= 4
        ? 'Foundation'
        : day <= 9
            ? 'Practice'
            : 'Challenge';

    final tip = mastery < 0.4
        ? 'Listen to the sound first, then choose — it helps retention.'
        : mastery < 0.7
            ? 'Review weak sounds first to boost accuracy.'
            : 'Focus on advanced modes (IPA / Minimal Pairs).';

    return DailyMission(
      day: day,
      phase: phase,
      title: 'Day $day / 14 Mission',
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
