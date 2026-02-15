import 'dart:math';
import '../models/word_data.dart';
import '../models/phonics_data.dart';

/// 1問分のデータ
class FillInBlankQuestion {
  final WordItem wordItem;
  final String targetPhonics; // 空白にする部分 (例: "sh")
  final List<String> choices; // 選択肢 3 つ (正解含む)

  const FillInBlankQuestion({
    required this.wordItem,
    required this.targetPhonics,
    required this.choices,
  });
}

/// ゲームデータ生成マネージャ
/// phonics_data.dart に実在する PhonicsItem の letter のみを検出対象にし、
/// 音声ファイルとの100%整合を保証する。
class FillInBlankDataManager {
  FillInBlankDataManager._();

  /// phonics_data から2文字以上の letter を抽出（長い順にソート）
  /// → 音声ファイルが確実に存在するパターンだけが対象
  static late final List<String> _patterns = () {
    final letters = allPhonicsItems
        .where((i) => i.letter.length >= 2)
        .map((i) => i.letter)
        .toSet()
        .toList();
    // 長い順にソートして、先にマッチさせる
    letters.sort((a, b) => b.length.compareTo(a.length));
    return letters;
  }();

  /// 同じ「音の種類」で紛らわしい選択肢グループ
  static const _similarGroups = <List<String>>[
    ['sh', 'ch', 'th', 'ck'],
    ['ai', 'oa', 'ie', 'ee'],
    ['or', 'ar', 'er'],
    ['oo', 'ou', 'ue'],
    ['oi', 'ng', 'qu'],
  ];

  /// wordLibrary をスキャンして出題データを生成
  static List<FillInBlankQuestion> generateQuestions({int? limit}) {
    final rng = Random();
    final questions = <FillInBlankQuestion>[];

    for (final item in wordLibrary) {
      final word = item.word.toLowerCase();

      // 単語内で最初にマッチするパターンを探す (長いほうを優先)
      String? found;
      for (final p in _patterns) {
        if (word.contains(p)) {
          found = p;
          break;
        }
      }
      if (found == null) continue; // パターンなし → スキップ

      // --- 選択肢を生成 ---
      final distractors = _pickDistractors(found, 2, rng);
      final choices = <String>[found, ...distractors]..shuffle(rng);

      questions.add(FillInBlankQuestion(
        wordItem: item,
        targetPhonics: found,
        choices: choices,
      ));
    }

    questions.shuffle(rng);
    if (limit != null && questions.length > limit) {
      return questions.sublist(0, limit);
    }
    return questions;
  }

  /// 正解と紛らわしいダミーを選ぶ
  static List<String> _pickDistractors(String correct, int count, Random rng) {
    // 同グループからまず探す
    final group = _similarGroups
        .where((g) => g.contains(correct))
        .expand((g) => g)
        .where((p) => p != correct)
        .toList();

    final result = <String>{};

    // 同グループから優先的に追加
    final shuffledGroup = List<String>.from(group)..shuffle(rng);
    for (final d in shuffledGroup) {
      if (result.length >= count) break;
      result.add(d);
    }

    // 足りなければ全パターンから補充
    if (result.length < count) {
      final all = List<String>.from(_patterns)..shuffle(rng);
      for (final p in all) {
        if (result.length >= count) break;
        if (p != correct && !result.contains(p)) result.add(p);
      }
    }

    return result.toList();
  }
}
