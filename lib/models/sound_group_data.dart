import 'phonics_data.dart';
import 'word_data.dart';

/// フォニックスのおとずかん — 同じ音を出す綴りをグループ化
class SoundGroup {
  const SoundGroup({
    required this.id,
    required this.displayName,
    required this.ipa,
    required this.color,
    required this.spellings,
    required this.wordKeys,
  });

  /// 一意のID
  final String id;

  /// ヘッダーに表示する音名
  final String displayName;

  /// IPA発音記号
  final String ipa;

  /// グループの色 (0xAARRGGBB)
  final int color;

  /// この音を表す綴りパターン一覧
  final List<String> spellings;

  /// この音を含む単語 (wordLibrary の word フィールド)
  final List<String> wordKeys;
}

// ═══════════════════════════════════════════════════════
//  Sound Groups — 同じ音 (phoneme) ごとに綴りをまとめる
// ═══════════════════════════════════════════════════════

const soundGroups = <SoundGroup>[
  // ── 短母音 (Short Vowels) ──
  SoundGroup(
    id: 'ae',
    displayName: 'a',
    ipa: 'æ',
    color: 0xFFE53935, // red
    spellings: ['a'],
    wordKeys: [
      'cat', 'hat', 'ant', 'map', 'bag', 'dad', 'sad',
      'clap', 'hand', 'lamp', 'fast', 'jam', 'black', 'and',
    ],
  ),
  SoundGroup(
    id: 'e_short',
    displayName: 'e',
    ipa: 'ɛ',
    color: 0xFF8E24AA, // purple
    spellings: ['e', 'ea'],
    wordKeys: [
      'pen', 'bed', 'egg', 'hen', 'red', 'leg', 'wet',
      'ten', 'bell', 'head', 'seven', 'friend', 'yellow',
    ],
  ),
  SoundGroup(
    id: 'i_short',
    displayName: 'i',
    ipa: 'ɪ',
    color: 0xFFE8A100, // yellow-amber
    spellings: ['i', 'y'],
    wordKeys: [
      'pig', 'sit', 'fish', 'six', 'big', 'milk', 'wind',
      'pink', 'swim', 'it', 'is', 'chip', 'sing',
    ],
  ),
  SoundGroup(
    id: 'o_short',
    displayName: 'o',
    ipa: 'ɒ',
    color: 0xFF6D4C41, // brown
    spellings: ['o'],
    wordKeys: [
      'dog', 'box', 'hot', 'fox', 'mom', 'rock', 'pond',
      'stop', 'frog', 'clock',
    ],
  ),
  SoundGroup(
    id: 'u_short',
    displayName: 'u',
    ipa: 'ʌ',
    color: 0xFF00897B, // teal
    spellings: ['u'],
    wordKeys: [
      'sun', 'bus', 'cup', 'nut', 'run', 'fun', 'jump',
      'plum', 'duck', 'one',
    ],
  ),

  // ── 長母音 (Long Vowels) ──
  SoundGroup(
    id: 'ei',
    displayName: 'ā',
    ipa: 'eɪ',
    color: 0xFFE53935, // red
    spellings: ['a', 'ai', 'ay', 'a_e', 'ea', 'ei', 'ey'],
    wordKeys: [
      'rain', 'cake', 'play', 'baby', 'they',
    ],
  ),
  SoundGroup(
    id: 'ii',
    displayName: 'ē',
    ipa: 'iː',
    color: 0xFF8E24AA, // purple
    spellings: ['e', 'ea', 'ee', 'ey', 'ie', 'y'],
    wordKeys: [
      'tree', 'bee', 'seed', 'leaf', 'read', 'eat', 'green',
      'key', 'three', 'he', 'she', 'we',
    ],
  ),
  SoundGroup(
    id: 'ai',
    displayName: 'ī',
    ipa: 'aɪ',
    color: 0xFFD81B60, // pink
    spellings: ['i', 'ie', 'i_e', 'y', 'igh'],
    wordKeys: [
      'pie', 'five', 'rice', 'white', 'my', 'eye',
    ],
  ),
  SoundGroup(
    id: 'ou_long',
    displayName: 'ō',
    ipa: 'əʊ',
    color: 0xFFFF8F00, // amber
    spellings: ['o', 'oa', 'o_e', 'ow'],
    wordKeys: [
      'nose', 'soap', 'cold', 'old', 'snow', 'yellow',
    ],
  ),
  SoundGroup(
    id: 'uu',
    displayName: 'oo',
    ipa: 'uː',
    color: 0xFFE65100, // deep orange
    spellings: ['oo', 'ew', 'o', 'ou', 'u', 'ue', 'ui'],
    wordKeys: [
      'moon', 'blue', 'soup', 'shoe', 'two', 'new', 'you',
    ],
  ),

  // ── その他の母音 (Other Vowels) ──
  SoundGroup(
    id: 'oo_short',
    displayName: 'oo',
    ipa: 'ʊ',
    color: 0xFF1B5E20, // dark green
    spellings: ['oo', 'u'],
    wordKeys: ['book', 'foot', 'good'],
  ),
  SoundGroup(
    id: 'or_sound',
    displayName: 'or',
    ipa: 'ɔː',
    color: 0xFF0D47A1, // dark blue
    spellings: ['or', 'oor', 'our', 'all'],
    wordKeys: ['four', 'ball', 'door'],
  ),
  SoundGroup(
    id: 'ar_sound',
    displayName: 'ar',
    ipa: 'ɑː',
    color: 0xFF4E342E, // brown dark
    spellings: ['ar'],
    wordKeys: ['star', 'arm'],
  ),
  SoundGroup(
    id: 'er_sound',
    displayName: 'er',
    ipa: 'ɜː',
    color: 0xFF9C27B0, // purple
    spellings: ['er', 'ir', 'ur', 'ear', 'or'],
    wordKeys: ['bird', 'girl'],
  ),
  SoundGroup(
    id: 'au_sound',
    displayName: 'ou',
    ipa: 'aʊ',
    color: 0xFFBF360C, // deep orange
    spellings: ['ou', 'ow'],
    wordKeys: ['cow', 'brown'],
  ),
  SoundGroup(
    id: 'oi_sound',
    displayName: 'oi',
    ipa: 'ɔɪ',
    color: 0xFF1565C0, // blue
    spellings: ['oi', 'oy'],
    wordKeys: ['boy'],
  ),
  SoundGroup(
    id: 'ear_sound',
    displayName: 'ear',
    ipa: 'ɪər',
    color: 0xFF00695C, // teal dark
    spellings: ['ear', 'eer'],
    wordKeys: ['ear'],
  ),

  // ── 子音 (Consonants) ──
  SoundGroup(
    id: 'b_sound',
    displayName: 'b',
    ipa: 'b',
    color: 0xFF1565C0, // blue
    spellings: ['b', 'bb'],
    wordKeys: [
      'bus', 'bed', 'box', 'book', 'ball', 'bag', 'bell',
      'bee', 'bird', 'boy', 'baby', 'big', 'brown', 'black', 'blue',
    ],
  ),
  SoundGroup(
    id: 'k_sound',
    displayName: 'c k',
    ipa: 'k',
    color: 0xFFE65100, // orange
    spellings: ['c', 'k', 'cc', 'ch', 'ck', 'qu'],
    wordKeys: [
      'cat', 'cup', 'cake', 'cow', 'clock', 'clap', 'cold',
      'duck', 'rock', 'black', 'key', 'milk',
    ],
  ),
  SoundGroup(
    id: 'ch_sound',
    displayName: 'ch',
    ipa: 'tʃ',
    color: 0xFF6A1B9A, // deep purple
    spellings: ['ch', 'tu'],
    wordKeys: ['chip'],
  ),
  SoundGroup(
    id: 'd_sound',
    displayName: 'd',
    ipa: 'd',
    color: 0xFFEF6C00, // orange
    spellings: ['d', 'dd', 'ed'],
    wordKeys: [
      'dog', 'dad', 'duck', 'door', 'red', 'bed', 'seed',
      'old', 'cold', 'hand', 'wind', 'sad',
    ],
  ),
  SoundGroup(
    id: 'f_sound',
    displayName: 'f',
    ipa: 'f',
    color: 0xFF546E7A, // blue grey
    spellings: ['f', 'ff', 'gh', 'ph'],
    wordKeys: [
      'fish', 'fox', 'five', 'four', 'foot', 'fun', 'fast',
      'friend', 'frog', 'leaf',
    ],
  ),
  SoundGroup(
    id: 'g_sound',
    displayName: 'g',
    ipa: 'g',
    color: 0xFF7B1FA2, // purple
    spellings: ['g', 'gg'],
    wordKeys: [
      'girl', 'big', 'bag', 'egg', 'frog', 'leg', 'green',
      'good', 'pig',
    ],
  ),
  SoundGroup(
    id: 'h_sound',
    displayName: 'h',
    ipa: 'h',
    color: 0xFFAD1457, // pink dark
    spellings: ['h'],
    wordKeys: ['hat', 'hen', 'hand', 'head', 'hot', 'he'],
  ),
  SoundGroup(
    id: 'j_sound',
    displayName: 'j',
    ipa: 'dʒ',
    color: 0xFF00838F, // cyan dark
    spellings: ['j', 'g', 'ge'],
    wordKeys: ['jam', 'jump'],
  ),
  SoundGroup(
    id: 'l_sound',
    displayName: 'l',
    ipa: 'l',
    color: 0xFF2E7D32, // green
    spellings: ['l', 'll'],
    wordKeys: [
      'leg', 'lamp', 'leaf', 'ball', 'bell', 'old', 'cold',
      'milk', 'blue', 'yellow',
    ],
  ),
  SoundGroup(
    id: 'm_sound',
    displayName: 'm',
    ipa: 'm',
    color: 0xFFC62828, // red dark
    spellings: ['m', 'mm'],
    wordKeys: ['map', 'mom', 'milk', 'moon', 'my'],
  ),
  SoundGroup(
    id: 'n_sound',
    displayName: 'n',
    ipa: 'n',
    color: 0xFF00695C, // teal
    spellings: ['n', 'nn', 'kn'],
    wordKeys: [
      'nut', 'nose', 'new', 'rain', 'sun', 'pen', 'hen',
      'ten', 'green', 'one', 'run', 'fun', 'seven',
    ],
  ),
  SoundGroup(
    id: 'ng_sound',
    displayName: 'ng',
    ipa: 'ŋ',
    color: 0xFF4527A0, // deep purple
    spellings: ['ng', 'n'],
    wordKeys: ['sing', 'pink'],
  ),
  SoundGroup(
    id: 'p_sound',
    displayName: 'p',
    ipa: 'p',
    color: 0xFF283593, // indigo
    spellings: ['p', 'pp'],
    wordKeys: [
      'pen', 'pig', 'pie', 'play', 'plum', 'pond', 'pink',
      'cup', 'lamp', 'jump', 'stop', 'clap',
    ],
  ),
  SoundGroup(
    id: 'r_sound',
    displayName: 'r',
    ipa: 'r',
    color: 0xFF2E7D32, // green
    spellings: ['r', 'rr', 'wr'],
    wordKeys: ['run', 'rain', 'red', 'rice', 'rock', 'read'],
  ),
  SoundGroup(
    id: 's_sound',
    displayName: 's',
    ipa: 's',
    color: 0xFF6A1B9A, // deep purple
    spellings: ['s', 'c', 'ss', 'es'],
    wordKeys: [
      'sun', 'sit', 'six', 'sad', 'sing', 'seed', 'snow',
      'soap', 'star', 'stop', 'swim', 'seven', 'rice',
    ],
  ),
  SoundGroup(
    id: 'sh_sound',
    displayName: 'sh',
    ipa: 'ʃ',
    color: 0xFFD84315, // deep orange
    spellings: ['sh', 'ci', 'ti'],
    wordKeys: ['shoe', 'fish', 'she'],
  ),
  SoundGroup(
    id: 't_sound',
    displayName: 't',
    ipa: 't',
    color: 0xFF37474F, // blue grey dark
    spellings: ['t', 'tt'],
    wordKeys: [
      'ten', 'tree', 'two', 'hat', 'hot', 'it',
      'ant', 'nut',
    ],
  ),
  SoundGroup(
    id: 'th_voiceless',
    displayName: 'th',
    ipa: 'θ',
    color: 0xFF4E342E, // brown
    spellings: ['th'],
    wordKeys: ['three'],
  ),
  SoundGroup(
    id: 'th_voiced',
    displayName: 'th',
    ipa: 'ð',
    color: 0xFF5D4037, // brown light
    spellings: ['th'],
    wordKeys: ['the', 'they'],
  ),
  SoundGroup(
    id: 'v_sound',
    displayName: 'v',
    ipa: 'v',
    color: 0xFF1B5E20, // green dark
    spellings: ['v', 've'],
    wordKeys: ['five', 'seven'],
  ),
  SoundGroup(
    id: 'w_sound',
    displayName: 'w',
    ipa: 'w',
    color: 0xFF0277BD, // light blue dark
    spellings: ['w', 'wh'],
    wordKeys: ['we', 'wet', 'wind', 'white'],
  ),
  SoundGroup(
    id: 'y_sound',
    displayName: 'y',
    ipa: 'j',
    color: 0xFFF9A825, // yellow dark
    spellings: ['y'],
    wordKeys: ['you', 'yellow'],
  ),
  SoundGroup(
    id: 'z_sound',
    displayName: 'z',
    ipa: 'z',
    color: 0xFF0D47A1, // blue dark
    spellings: ['z', 's'],
    wordKeys: ['is'],
  ),
  SoundGroup(
    id: 'ks_sound',
    displayName: 'x',
    ipa: 'ks',
    color: 0xFF455A64, // grey
    spellings: ['x'],
    wordKeys: ['fox', 'six', 'box'],
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
  // まず IPA が一致するものを探す
  for (final item in items) {
    if (item.ipa == group.ipa) return item;
  }
  // letter が displayName に一致するものを探す
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
