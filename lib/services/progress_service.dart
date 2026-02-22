import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phonics_data.dart';

// ═══════════════════════════════════════════
//  Progress Service — 学習進捗 & 統計管理
// ═══════════════════════════════════════════

class ProgressService {
  static const _prefix = 'phonics_v2_';

  // ── SharedPreferences ヘルパー ──

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

  static Future<void> _saveStringMap(
      String key, Map<String, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', json.encode(map));
  }

  // ═══════════════════════════════════════════
  //  1. 音ごとの正答・出題・不正解記録
  // ═══════════════════════════════════════════

  static Future<void> recordCorrect(String progressKey) async {
    final map = await _loadMap('correct');
    map[progressKey] = (map[progressKey] ?? 0) + 1;
    await _saveMap('correct', map);
    await _updateSrs(progressKey, wasCorrect: true);
  }

  static Future<void> recordAttempt(String progressKey) async {
    final map = await _loadMap('attempts');
    map[progressKey] = (map[progressKey] ?? 0) + 1;
    await _saveMap('attempts', map);
  }

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

  // ═══════════════════════════════════════════
  //  2. グループマスター率 & SRS
  // ═══════════════════════════════════════════

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

  static Future<double> letterMastery(String progressKey) async {
    final correct = await _loadMap('correct');
    final attempts = await _loadMap('attempts');
    final a = attempts[progressKey] ?? 0;
    final c = correct[progressKey] ?? 0;
    if (a == 0) return 0;
    return c / a;
  }

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

      final wrongRate = a == 0 ? 0 : (a - c) / a;
      final weighted = wrongRate + (w * 0.02);
      if (weighted > 0.2) {
        scored.add((item: item, score: weighted));
      }
    }

    scored.sort((x, y) => y.score.compareTo(x.score));
    return scored.take(limit).map((e) => e.item).toList();
  }

  static Future<bool> isGroupUnlocked(int groupId) async {
    if (groupId == 0) return true;
    final prev = phonicsGroups[groupId - 1];
    final mastery = await groupMastery(prev);
    return mastery >= 0.6;
  }

  static Future<int> totalCorrect() async {
    final map = await _loadMap('correct');
    return map.values.fold<int>(0, (a, b) => a + b);
  }

  // ═══════════════════════════════════════════
  //  3. ストリーク（連続学習日数）
  // ═══════════════════════════════════════════

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefix}streak') ?? 0;
  }

  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dayKey(DateTime.now());
    final lastDay = prefs.getString('${_prefix}last_day') ?? '';
    final streak = prefs.getInt('${_prefix}streak') ?? 0;

    if (lastDay == today) return;

    final yesterday = _dayKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    if (lastDay == yesterday) {
      await prefs.setInt('${_prefix}streak', streak + 1);
    } else {
      await prefs.setInt('${_prefix}streak', 1);
    }
    await prefs.setString('${_prefix}last_day', today);
  }

  // ═══════════════════════════════════════════
  //  4. レッスン受講記録
  // ═══════════════════════════════════════════

  /// レッスン完了を記録（グループIDごとにカウント）
  static Future<void> recordLessonComplete(int groupId) async {
    final map = await _loadMap('lesson_count');
    map['group_$groupId'] = (map['group_$groupId'] ?? 0) + 1;
    await _saveMap('lesson_count', map);

    // 完了日時も記録
    final prefs = await SharedPreferences.getInstance();
    final key = '${_prefix}lesson_last_group_$groupId';
    await prefs.setString(key, DateTime.now().toIso8601String());
  }

  /// グループの受講回数を取得
  static Future<int> getLessonCount(int groupId) async {
    final map = await _loadMap('lesson_count');
    return map['group_$groupId'] ?? 0;
  }

  /// 全グループの受講回数マップを取得
  static Future<Map<int, int>> getAllLessonCounts() async {
    final map = await _loadMap('lesson_count');
    final result = <int, int>{};
    for (final entry in map.entries) {
      final key = entry.key;
      if (key.startsWith('group_')) {
        final id = int.tryParse(key.substring(6));
        if (id != null) result[id] = entry.value;
      }
    }
    return result;
  }

  /// レッスン受講総回数
  static Future<int> totalLessonCount() async {
    final counts = await getAllLessonCounts();
    return counts.values.fold<int>(0, (a, b) => a + b);
  }

  // ═══════════════════════════════════════════
  //  5. ゲームセッション記録
  // ═══════════════════════════════════════════

  /// ゲームセッション完了を記録
  static Future<void> recordGameSession({
    required String gameType,
    required int score,
    required int total,
  }) async {
    // ゲーム種別ごとのプレイ回数
    final countMap = await _loadMap('game_count');
    countMap[gameType] = (countMap[gameType] ?? 0) + 1;
    await _saveMap('game_count', countMap);

    // 今日のセッション数
    final today = _dayKey(DateTime.now());
    final dailyMap = await _loadMap('game_daily_$today');
    dailyMap[gameType] = (dailyMap[gameType] ?? 0) + 1;
    await _saveMap('game_daily_$today', dailyMap);

    // 総セッション数
    final prefs = await SharedPreferences.getInstance();
    final totalKey = '${_prefix}total_sessions';
    final cur = prefs.getInt(totalKey) ?? 0;
    await prefs.setInt(totalKey, cur + 1);

    // ベストスコアの更新
    if (total > 0) {
      final accuracy = score / total;
      final bestMap = await _loadStringMap('game_best');
      final prevBest = double.tryParse(bestMap[gameType] ?? '0') ?? 0;
      if (accuracy > prevBest) {
        bestMap[gameType] = accuracy.toStringAsFixed(3);
        await _saveStringMap('game_best', bestMap);
      }
    }
  }

  /// ゲーム種別ごとのプレイ回数
  static Future<int> getGamePlayCount(String gameType) async {
    final map = await _loadMap('game_count');
    return map[gameType] ?? 0;
  }

  /// 全ゲーム種別のプレイ回数マップ
  static Future<Map<String, int>> getAllGameCounts() async {
    return _loadMap('game_count');
  }

  /// 総セッション数
  static Future<int> getTotalSessions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefix}total_sessions') ?? 0;
  }

  /// 今日のセッション数
  static Future<int> getTodaySessions() async {
    final today = _dayKey(DateTime.now());
    final dailyMap = await _loadMap('game_daily_$today');
    return dailyMap.values.fold<int>(0, (a, b) => a + b);
  }

  /// ゲーム種別のベスト正答率
  static Future<double> getGameBestAccuracy(String gameType) async {
    final bestMap = await _loadStringMap('game_best');
    return double.tryParse(bestMap[gameType] ?? '0') ?? 0;
  }

  // ═══════════════════════════════════════════
  //  6. ログイン記録（日次アクセス追跡）
  // ═══════════════════════════════════════════

  /// 今日のログインを記録
  static Future<void> recordLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dayKey(DateTime.now());

    // ログイン日のセットを読み込み
    final raw = prefs.getString('${_prefix}login_days');
    final Set<String> days;
    if (raw != null) {
      days = Set<String>.from(json.decode(raw) as List);
    } else {
      days = {};
    }

    if (!days.contains(today)) {
      days.add(today);
      await prefs.setString('${_prefix}login_days', json.encode(days.toList()));
    }

    // ログインストリーク更新
    await _updateLoginStreak(prefs, today);
  }

  /// ログインストリーク更新
  static Future<void> _updateLoginStreak(
      SharedPreferences prefs, String today) async {
    final lastLogin = prefs.getString('${_prefix}login_last') ?? '';
    final curStreak = prefs.getInt('${_prefix}login_streak') ?? 0;
    final maxStreak = prefs.getInt('${_prefix}login_max_streak') ?? 0;

    if (lastLogin == today) return; // 既に記録済み

    final yesterday = _dayKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    int newStreak;
    if (lastLogin == yesterday) {
      newStreak = curStreak + 1;
    } else {
      newStreak = 1;
    }

    await prefs.setString('${_prefix}login_last', today);
    await prefs.setInt('${_prefix}login_streak', newStreak);
    if (newStreak > maxStreak) {
      await prefs.setInt('${_prefix}login_max_streak', newStreak);
    }
  }

  /// 現在のログイン連続日数
  static Future<int> getLoginStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString('${_prefix}login_last') ?? '';
    final today = _dayKey(DateTime.now());
    final yesterday = _dayKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    // 今日または昨日がlastLoginの場合のみストリーク有効
    if (lastLogin == today || lastLogin == yesterday) {
      return prefs.getInt('${_prefix}login_streak') ?? 0;
    }
    return 0; // 2日以上空いたのでリセット
  }

  /// 最長ログイン連続日数
  static Future<int> getMaxLoginStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefix}login_max_streak') ?? 0;
  }

  /// 累計ログイン日数
  static Future<int> getTotalLoginDays() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_prefix}login_days');
    if (raw == null) return 0;
    final days = List<String>.from(json.decode(raw) as List);
    return days.length;
  }

  /// 直近N日のログイン状況（カレンダー用）
  static Future<Map<String, bool>> getLoginCalendar({int days = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_prefix}login_days');
    final Set<String> loginDays;
    if (raw != null) {
      loginDays = Set<String>.from(json.decode(raw) as List);
    } else {
      loginDays = {};
    }

    final today = DateTime.now();
    final result = <String, bool>{};
    for (int i = 0; i < days; i++) {
      final d = today.subtract(Duration(days: i));
      final key = _dayKey(d);
      result[key] = loginDays.contains(key);
    }
    return result;
  }

  /// 今日ログイン済みかどうか
  static Future<bool> hasLoggedInToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString('${_prefix}login_last') ?? '';
    return lastLogin == _dayKey(DateTime.now());
  }

  // ═══════════════════════════════════════════
  //  7. 14日学習サイクル & ミッション
  // ═══════════════════════════════════════════

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

  // ═══════════════════════════════════════════
  //  8. 統計サマリー（ホーム画面用）
  // ═══════════════════════════════════════════

  /// ダッシュボード用の統計データを一括取得
  static Future<UserStats> getUserStats() async {
    final loginStreak = await getLoginStreak();
    final maxLoginStreak = await getMaxLoginStreak();
    final totalLogins = await getTotalLoginDays();
    final totalSessions = await getTotalSessions();
    final todaySessions = await getTodaySessions();
    final totalLessons = await totalLessonCount();
    final lessonCounts = await getAllLessonCounts();
    final gameCounts = await getAllGameCounts();
    final totalCorrectCount = await totalCorrect();
    final loggedInToday = await hasLoggedInToday();

    return UserStats(
      loginStreak: loginStreak,
      maxLoginStreak: maxLoginStreak,
      totalLoginDays: totalLogins,
      totalGameSessions: totalSessions,
      todayGameSessions: todaySessions,
      totalLessonCompletions: totalLessons,
      lessonCountByGroup: lessonCounts,
      gameCountByType: gameCounts,
      totalCorrectAnswers: totalCorrectCount,
      loggedInToday: loggedInToday,
    );
  }
}

// ═══════════════════════════════════════════
//  Data Models
// ═══════════════════════════════════════════

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

class UserStats {
  const UserStats({
    required this.loginStreak,
    required this.maxLoginStreak,
    required this.totalLoginDays,
    required this.totalGameSessions,
    required this.todayGameSessions,
    required this.totalLessonCompletions,
    required this.lessonCountByGroup,
    required this.gameCountByType,
    required this.totalCorrectAnswers,
    required this.loggedInToday,
  });

  /// 現在のログイン連続日数
  final int loginStreak;

  /// 最長ログイン連続日数
  final int maxLoginStreak;

  /// 累計ログイン日数
  final int totalLoginDays;

  /// 累計ゲームセッション数
  final int totalGameSessions;

  /// 今日のゲームセッション数
  final int todayGameSessions;

  /// レッスン受講総回数
  final int totalLessonCompletions;

  /// グループ別レッスン受講回数
  final Map<int, int> lessonCountByGroup;

  /// ゲーム種別ごとのプレイ回数
  final Map<String, int> gameCountByType;

  /// 累計正答数
  final int totalCorrectAnswers;

  /// 今日ログイン済みか
  final bool loggedInToday;
}
