import 'phonics_data.dart';
import 'word_data.dart';

/// フォニックスのおとずかん — 同じ音を出す綴りをグループ化
class SoundGroup {
  const SoundGroup({
    required this.id,
    required this.displayName,
    required this.ipa,
    required this.color,
    required this.spellingWords,
  });

  /// 一意のID
  final String id;

  /// ヘッダーに表示する音名
  final String displayName;

  /// IPA発音記号
  final String ipa;

  /// グループの色 (0xAARRGGBB)
  final int color;

  /// スペリングごとの単語マップ (key=つづり, value=その綴りで対象の音が出る単語)
  final Map<String, List<String>> spellingWords;

  /// スペリング一覧（表示順）
  List<String> get spellings => spellingWords.keys.toList();

  /// 全単語キー（重複排除）
  List<String> get wordKeys {
    final set = <String>{};
    for (final words in spellingWords.values) {
      set.addAll(words);
    }
    return set.toList();
  }
}

// ═══════════════════════════════════════════════════════
//  Sound Groups — 同じ音 (phoneme) ごとに綴りをまとめる
//  各スペリングに最低4つの単語を持つ
// ═══════════════════════════════════════════════════════

const soundGroups = <SoundGroup>[
  // ── 短母音 (Short Vowels) ──
  SoundGroup(
    id: 'ae',
    displayName: 'a',
    ipa: 'æ',
    color: 0xFFE53935,
    spellingWords: {
      'a': [
        'cat', 'hat', 'ant', 'map', 'bag', 'dad', 'sad',
        'clap', 'hand', 'lamp', 'fast', 'jam', 'black', 'and',
      ],
    },
  ),
  SoundGroup(
    id: 'e_short',
    displayName: 'e',
    ipa: 'ɛ',
    color: 0xFF8E24AA,
    spellingWords: {
      'e': [
        'pen', 'bed', 'egg', 'hen', 'red', 'leg', 'wet',
        'ten', 'bell', 'seven', 'yes', 'jet',
      ],
      'ea': ['head', 'bread', 'dead', 'spread'],
    },
  ),
  SoundGroup(
    id: 'i_short',
    displayName: 'i',
    ipa: 'ɪ',
    color: 0xFFE8A100,
    spellingWords: {
      'i': [
        'pig', 'sit', 'fish', 'six', 'big', 'milk', 'wind',
        'pink', 'swim', 'it', 'is', 'chip', 'sing',
      ],
    },
  ),
  SoundGroup(
    id: 'o_short',
    displayName: 'o',
    ipa: 'ɒ',
    color: 0xFF6D4C41,
    spellingWords: {
      'o': [
        'dog', 'box', 'hot', 'fox', 'mom', 'rock', 'pond',
        'stop', 'frog', 'clock',
      ],
    },
  ),
  SoundGroup(
    id: 'u_short',
    displayName: 'u',
    ipa: 'ʌ',
    color: 0xFF00897B,
    spellingWords: {
      'u': [
        'sun', 'bus', 'cup', 'nut', 'run', 'fun', 'jump',
        'plum', 'duck', 'jug', 'much', 'lunch', 'buzz',
      ],
    },
  ),

  // ── 長母音 (Long Vowels) ──
  SoundGroup(
    id: 'ei',
    displayName: 'ā',
    ipa: 'eɪ',
    color: 0xFFE53935,
    spellingWords: {
      'a_e': ['cake', 'make', 'name', 'game', 'lake'],
      'ai': ['rain', 'train', 'tail', 'snail', 'wait'],
      'ay': ['play', 'day', 'say', 'way', 'stay'],
    },
  ),
  SoundGroup(
    id: 'ii',
    displayName: 'ē',
    ipa: 'iː',
    color: 0xFF8E24AA,
    spellingWords: {
      'ee': ['tree', 'bee', 'seed', 'green', 'three'],
      'ea': ['eat', 'read', 'leaf', 'tea', 'sea'],
      'e': ['he', 'she', 'we', 'me', 'be'],
    },
  ),
  SoundGroup(
    id: 'ai',
    displayName: 'ī',
    ipa: 'aɪ',
    color: 0xFFD81B60,
    spellingWords: {
      'i_e': ['five', 'rice', 'white', 'bike', 'kite'],
      'ie': ['pie', 'tie', 'die', 'lie'],
      'y': ['my', 'fly', 'cry', 'try', 'sky'],
      'igh': ['high', 'night', 'light', 'right'],
    },
  ),
  SoundGroup(
    id: 'ou_long',
    displayName: 'ō',
    ipa: 'əʊ',
    color: 0xFFFF8F00,
    spellingWords: {
      'o_e': ['nose', 'home', 'bone', 'hope'],
      'oa': ['soap', 'boat', 'coat', 'goat'],
      'ow': ['snow', 'yellow', 'blow', 'grow'],
      'o': ['cold', 'old', 'go', 'no'],
    },
  ),
  SoundGroup(
    id: 'uu',
    displayName: 'oo',
    ipa: 'uː',
    color: 0xFFE65100,
    spellingWords: {
      'oo': ['moon', 'zoo', 'tooth', 'food', 'cool'],
      'ew': ['new', 'flew', 'drew', 'chew'],
      'ue': ['blue', 'clue', 'true', 'glue'],
    },
  ),

  // ── その他の母音 (Other Vowels) ──
  SoundGroup(
    id: 'oo_short',
    displayName: 'oo',
    ipa: 'ʊ',
    color: 0xFF1B5E20,
    spellingWords: {
      'oo': ['book', 'foot', 'good', 'cook'],
    },
  ),
  SoundGroup(
    id: 'or_sound',
    displayName: 'or',
    ipa: 'ɔː',
    color: 0xFF0D47A1,
    spellingWords: {
      'or': ['fork', 'corn', 'born', 'sort'],
      'all': ['ball', 'fall', 'tall', 'wall'],
    },
  ),
  SoundGroup(
    id: 'ar_sound',
    displayName: 'ar',
    ipa: 'ɑː',
    color: 0xFF4E342E,
    spellingWords: {
      'ar': ['star', 'arm', 'car', 'park'],
    },
  ),
  SoundGroup(
    id: 'er_sound',
    displayName: 'er',
    ipa: 'ɜː',
    color: 0xFF9C27B0,
    spellingWords: {
      'er': ['her', 'fern', 'herb', 'herd'],
      'ir': ['bird', 'girl', 'dirt', 'shirt'],
      'ur': ['turn', 'burn', 'hurt', 'fur'],
    },
  ),
  SoundGroup(
    id: 'au_sound',
    displayName: 'ou',
    ipa: 'aʊ',
    color: 0xFFBF360C,
    spellingWords: {
      'ou': ['out', 'house', 'loud', 'mouth'],
      'ow': ['cow', 'brown', 'down', 'town'],
    },
  ),
  SoundGroup(
    id: 'oi_sound',
    displayName: 'oi',
    ipa: 'ɔɪ',
    color: 0xFF1565C0,
    spellingWords: {
      'oi': ['coin', 'oil', 'join', 'point'],
      'oy': ['boy', 'toy', 'joy', 'enjoy'],
    },
  ),
  SoundGroup(
    id: 'ear_sound',
    displayName: 'ear',
    ipa: 'ɪər',
    color: 0xFF00695C,
    spellingWords: {
      'ear': ['ear', 'near', 'hear', 'dear'],
      'eer': ['deer', 'cheer', 'steer', 'peer'],
    },
  ),

  // ── 子音 (Consonants) ──
  SoundGroup(
    id: 'b_sound',
    displayName: 'b',
    ipa: 'b',
    color: 0xFF1565C0,
    spellingWords: {
      'b': [
        'bus', 'bed', 'box', 'book', 'ball', 'bag', 'bell',
        'bee', 'bird', 'boy', 'baby', 'big', 'brown', 'black', 'blue',
      ],
    },
  ),
  SoundGroup(
    id: 'k_sound',
    displayName: 'c k',
    ipa: 'k',
    color: 0xFFE65100,
    spellingWords: {
      'c': [
        'cat', 'cup', 'cake', 'cow', 'clap', 'cold', 'car',
        'cook', 'coin', 'coat', 'cool', 'corn',
      ],
      'k': ['key', 'king', 'kite', 'keep'],
      'ck': ['duck', 'rock', 'black', 'clock'],
    },
  ),
  SoundGroup(
    id: 'ch_sound',
    displayName: 'ch',
    ipa: 'tʃ',
    color: 0xFF6A1B9A,
    spellingWords: {
      'ch': ['chip', 'chin', 'lunch', 'much', 'chew', 'cheer'],
    },
  ),
  SoundGroup(
    id: 'd_sound',
    displayName: 'd',
    ipa: 'd',
    color: 0xFFEF6C00,
    spellingWords: {
      'd': [
        'dog', 'dad', 'duck', 'door', 'red', 'bed', 'seed',
        'old', 'cold', 'hand', 'wind', 'sad',
      ],
    },
  ),
  SoundGroup(
    id: 'f_sound',
    displayName: 'f',
    ipa: 'f',
    color: 0xFF546E7A,
    spellingWords: {
      'f': [
        'fish', 'fox', 'five', 'four', 'foot', 'fun', 'fast',
        'friend', 'frog', 'leaf', 'fork', 'fur', 'fern', 'fall',
      ],
      'ph': ['phone', 'photo', 'dolphin', 'elephant'],
    },
  ),
  SoundGroup(
    id: 'g_sound',
    displayName: 'g',
    ipa: 'g',
    color: 0xFF7B1FA2,
    spellingWords: {
      'g': [
        'girl', 'big', 'bag', 'egg', 'frog', 'leg', 'green',
        'good', 'pig', 'go', 'goat', 'game', 'glue', 'grow',
      ],
    },
  ),
  SoundGroup(
    id: 'h_sound',
    displayName: 'h',
    ipa: 'h',
    color: 0xFFAD1457,
    spellingWords: {
      'h': [
        'hat', 'hen', 'hand', 'head', 'hot', 'he', 'her',
        'house', 'high', 'home', 'hope', 'herd', 'herb', 'hurt',
      ],
    },
  ),
  SoundGroup(
    id: 'j_sound',
    displayName: 'j',
    ipa: 'dʒ',
    color: 0xFF00838F,
    spellingWords: {
      'j': ['jam', 'jump', 'jug', 'jet', 'join', 'joy'],
    },
  ),
  SoundGroup(
    id: 'l_sound',
    displayName: 'l',
    ipa: 'l',
    color: 0xFF2E7D32,
    spellingWords: {
      'l': [
        'leg', 'lamp', 'leaf', 'ball', 'bell', 'old', 'cold',
        'milk', 'blue', 'yellow', 'lake', 'lie', 'light', 'loud',
      ],
    },
  ),
  SoundGroup(
    id: 'm_sound',
    displayName: 'm',
    ipa: 'm',
    color: 0xFFC62828,
    spellingWords: {
      'm': ['map', 'mom', 'milk', 'moon', 'my', 'make', 'me', 'mix', 'mouth'],
    },
  ),
  SoundGroup(
    id: 'n_sound',
    displayName: 'n',
    ipa: 'n',
    color: 0xFF00695C,
    spellingWords: {
      'n': [
        'nut', 'nose', 'new', 'rain', 'sun', 'pen', 'hen',
        'ten', 'green', 'run', 'fun', 'seven', 'name', 'no', 'night', 'near',
      ],
      'kn': ['knee', 'knife', 'knot', 'know'],
    },
  ),
  SoundGroup(
    id: 'ng_sound',
    displayName: 'ng',
    ipa: 'ŋ',
    color: 0xFF4527A0,
    spellingWords: {
      'ng': ['sing', 'ring', 'king', 'song'],
    },
  ),
  SoundGroup(
    id: 'p_sound',
    displayName: 'p',
    ipa: 'p',
    color: 0xFF283593,
    spellingWords: {
      'p': [
        'pen', 'pig', 'pie', 'play', 'plum', 'pond', 'pink',
        'cup', 'lamp', 'jump', 'stop', 'clap', 'park', 'point',
      ],
    },
  ),
  SoundGroup(
    id: 'r_sound',
    displayName: 'r',
    ipa: 'r',
    color: 0xFF2E7D32,
    spellingWords: {
      'r': ['run', 'rain', 'red', 'rice', 'rock', 'read', 'right', 'ring'],
      'wr': ['write', 'wrong', 'wrap', 'wrist'],
    },
  ),
  SoundGroup(
    id: 's_sound',
    displayName: 's',
    ipa: 's',
    color: 0xFF6A1B9A,
    spellingWords: {
      's': [
        'sun', 'sit', 'six', 'sad', 'sing', 'seed', 'snow',
        'soap', 'star', 'stop', 'swim', 'seven', 'say', 'sea',
        'sky', 'stay', 'sort', 'snail', 'spread', 'steer',
      ],
    },
  ),
  SoundGroup(
    id: 'sh_sound',
    displayName: 'sh',
    ipa: 'ʃ',
    color: 0xFFD84315,
    spellingWords: {
      'sh': ['shoe', 'fish', 'she', 'ship', 'shirt'],
    },
  ),
  SoundGroup(
    id: 't_sound',
    displayName: 't',
    ipa: 't',
    color: 0xFF37474F,
    spellingWords: {
      't': [
        'ten', 'tree', 'two', 'hat', 'hot', 'it', 'ant', 'nut',
        'train', 'tail', 'tall', 'town', 'tie', 'try', 'true', 'tea',
      ],
    },
  ),
  SoundGroup(
    id: 'th_voiceless',
    displayName: 'th',
    ipa: 'θ',
    color: 0xFF4E342E,
    spellingWords: {
      'th': ['three', 'thin', 'bath', 'tooth'],
    },
  ),
  SoundGroup(
    id: 'th_voiced',
    displayName: 'th',
    ipa: 'ð',
    color: 0xFF5D4037,
    spellingWords: {
      'th': ['the', 'they', 'this', 'that'],
    },
  ),
  SoundGroup(
    id: 'v_sound',
    displayName: 'v',
    ipa: 'v',
    color: 0xFF1B5E20,
    spellingWords: {
      'v': ['five', 'seven', 'van', 'love'],
    },
  ),
  SoundGroup(
    id: 'w_sound',
    displayName: 'w',
    ipa: 'w',
    color: 0xFF0277BD,
    spellingWords: {
      'w': ['we', 'wet', 'wind', 'wait', 'way', 'wall'],
      'wh': ['white', 'what', 'when', 'where', 'whale'],
    },
  ),
  SoundGroup(
    id: 'y_sound',
    displayName: 'y',
    ipa: 'j',
    color: 0xFFF9A825,
    spellingWords: {
      'y': ['you', 'yellow', 'yes', 'yak'],
    },
  ),
  SoundGroup(
    id: 'z_sound',
    displayName: 'z',
    ipa: 'z',
    color: 0xFF0D47A1,
    spellingWords: {
      'z': ['zip', 'zoo', 'buzz', 'zero'],
    },
  ),
  SoundGroup(
    id: 'ks_sound',
    displayName: 'x',
    ipa: 'ks',
    color: 0xFF455A64,
    spellingWords: {
      'x': ['fox', 'six', 'box', 'mix'],
    },
  ),
];

// ═══════════════════════════════════════════════════════
//  カテゴリ別グルーピング
// ═══════════════════════════════════════════════════════

/// 短母音グループ
List<SoundGroup> get shortVowelGroups =>
    soundGroups.where((g) => ['ae', 'e_short', 'i_short', 'o_short', 'u_short'].contains(g.id)).toList();

/// 長母音グループ
List<SoundGroup> get longVowelGroups =>
    soundGroups.where((g) => ['ei', 'ii', 'ai', 'ou_long', 'uu'].contains(g.id)).toList();

/// その他の母音グループ
List<SoundGroup> get otherVowelGroups =>
    soundGroups.where((g) => ['oo_short', 'or_sound', 'ar_sound', 'er_sound', 'au_sound', 'oi_sound', 'ear_sound'].contains(g.id)).toList();

/// 子音グループ
List<SoundGroup> get consonantGroups =>
    soundGroups.where((g) {
      return !['ae', 'e_short', 'i_short', 'o_short', 'u_short',
               'ei', 'ii', 'ai', 'ou_long', 'uu',
               'oo_short', 'or_sound', 'ar_sound', 'er_sound',
               'au_sound', 'oi_sound', 'ear_sound'].contains(g.id);
    }).toList();

/// セクション名付きの全グループリスト
List<MapEntry<String, List<SoundGroup>>> get soundGroupSections => [
  MapEntry('たんぼいん（みじかい母音）', shortVowelGroups),
  MapEntry('ちょうぼいん（ながい母音）', longVowelGroups),
  MapEntry('そのたの母音', otherVowelGroups),
  MapEntry('しいん（子音）', consonantGroups),
];

/// SoundGroupからPhonicsItemを検索（音声再生用）
PhonicsItem? findPhonicsItemForGroup(SoundGroup group) {
  final items = allPhonicsItems;
  for (final item in items) {
    if (item.ipa == group.ipa) return item;
  }
  for (final item in items) {
    if (item.letter == group.displayName) return item;
  }
  return null;
}

/// スペリングからPhonicsItemを検索（音声再生用）
PhonicsItem? findPhonicsItemForSpelling(String spelling) {
  final items = allPhonicsItems;
  for (final item in items) {
    if (item.letter == spelling) return item;
  }
  return null;
}

/// wordKeys から WordItem リストを取得
List<WordItem> getWordsForGroup(SoundGroup group) {
  return group.wordKeys
      .map((key) {
        try {
          return wordLibrary.firstWhere(
            (w) => w.word.toLowerCase() == key.toLowerCase(),
          );
        } catch (_) {
          return null;
        }
      })
      .whereType<WordItem>()
      .toList();
}

/// 特定スペリングの WordItem リストを取得
List<WordItem> getWordsForSpelling(SoundGroup group, String spelling) {
  final keys = group.spellingWords[spelling] ?? [];
  return keys
      .map((key) {
        try {
          return wordLibrary.firstWhere(
            (w) => w.word.toLowerCase() == key.toLowerCase(),
          );
        } catch (_) {
          return null;
        }
      })
      .whereType<WordItem>()
      .toList();
}
