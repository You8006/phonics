/// 1つのフォニックス音（文字と発音の対応）
class PhonicsItem {
  const PhonicsItem(
    this.letter,
    this.sound, {
    this.ipa = '',
    this.example = '',
  });

  /// 表示文字（例: "a", "sh"）
  final String letter;

  /// TTS で読み上げる発音テキスト
  final String sound;

  /// 発音記号（IPA）
  final String ipa;

  /// CVC 単語の例（例: "sat"）
  final String example;

  /// 学習進捗保存用の一意キー（同じ letter を区別するため）
  String get progressKey => '$letter|$sound';
}

/// Jolly Phonics 準拠の学習グループ
class PhonicsGroup {
  const PhonicsGroup({
    required this.id,
    required this.name,
    required this.items,
    required this.cvcWords,
  });

  /// 0-indexed グループ番号
  final int id;

  /// 表示名
  final String name;

  /// このグループで学ぶ音
  final List<PhonicsItem> items;

  /// ブレンディング練習用 CVC 単語
  final List<String> cvcWords;
}

// ═══════════════════════════════════════════
//  Jolly Phonics 7 Groups (42 sounds)
// ═══════════════════════════════════════════

const _group1Items = <PhonicsItem>[
  PhonicsItem('s', 'sss', ipa: 's', example: 'sun'),
  PhonicsItem('a', 'ah', ipa: 'æ', example: 'ant'),
  PhonicsItem('t', 'tuh', ipa: 't', example: 'tap'),
  PhonicsItem('i', 'ih', ipa: 'ɪ', example: 'ink'),
  PhonicsItem('p', 'puh', ipa: 'p', example: 'pan'),
  PhonicsItem('n', 'nnn', ipa: 'n', example: 'net'),
];

const _group2Items = <PhonicsItem>[
  PhonicsItem('ck', 'kuh', ipa: 'k', example: 'sock'),
  PhonicsItem('e', 'eh', ipa: 'e', example: 'egg'),
  PhonicsItem('h', 'huh', ipa: 'h', example: 'hat'),
  PhonicsItem('r', 'rrr', ipa: 'r', example: 'rat'),
  PhonicsItem('m', 'mmm', ipa: 'm', example: 'map'),
  PhonicsItem('d', 'duh', ipa: 'd', example: 'dog'),
];

const _group3Items = <PhonicsItem>[
  PhonicsItem('g', 'guh', ipa: 'g', example: 'got'),
  PhonicsItem('o', 'oh', ipa: 'ɒ', example: 'on'),
  PhonicsItem('u', 'uh', ipa: 'ʌ', example: 'up'),
  PhonicsItem('l', 'lll', ipa: 'l', example: 'log'),
  PhonicsItem('f', 'fff', ipa: 'f', example: 'fan'),
  PhonicsItem('b', 'buh', ipa: 'b', example: 'bat'),
];

const _group4Items = <PhonicsItem>[
  PhonicsItem('ai', 'ay', ipa: 'eɪ', example: 'rain'),
  PhonicsItem('j', 'juh', ipa: 'dʒ', example: 'jam'),
  PhonicsItem('oa', 'oh-ah', ipa: 'əʊ', example: 'boat'),
  PhonicsItem('ie', 'eye', ipa: 'aɪ', example: 'tie'),
  PhonicsItem('ee', 'eee', ipa: 'iː', example: 'tree'),
  PhonicsItem('or', 'or', ipa: 'ɔː', example: 'fork'),
];

const _group5Items = <PhonicsItem>[
  PhonicsItem('z', 'zzz', ipa: 'z', example: 'zip'),
  PhonicsItem('w', 'wuh', ipa: 'w', example: 'web'),
  PhonicsItem('ng', 'nng', ipa: 'ŋ', example: 'ring'),
  PhonicsItem('v', 'vvv', ipa: 'v', example: 'van'),
  PhonicsItem('oo', 'oo', ipa: 'uː', example: 'moon'),
  PhonicsItem('oo', 'oo-short', ipa: 'ʊ', example: 'book'),
];

const _group6Items = <PhonicsItem>[
  PhonicsItem('y', 'yuh', ipa: 'j', example: 'yak'),
  PhonicsItem('x', 'ks', ipa: 'ks', example: 'fox'),
  PhonicsItem('ch', 'chuh', ipa: 'tʃ', example: 'chip'),
  PhonicsItem('sh', 'shh', ipa: 'ʃ', example: 'ship'),
  PhonicsItem('th', 'thh', ipa: 'θ', example: 'thin'),
  PhonicsItem('th', 'th-voiced', ipa: 'ð', example: 'this'),
];

const _group7Items = <PhonicsItem>[
  PhonicsItem('qu', 'kwuh', ipa: 'kw', example: 'queen'),
  PhonicsItem('ou', 'ow', ipa: 'aʊ', example: 'out'),
  PhonicsItem('oi', 'oy', ipa: 'ɔɪ', example: 'coin'),
  PhonicsItem('ue', 'you', ipa: 'juː', example: 'blue'),
  PhonicsItem('er', 'er', ipa: 'ɜː', example: 'her'),
  PhonicsItem('ar', 'ar', ipa: 'ɑː', example: 'car'),
];

// ── 追加フォニックスパターン (ゲーム・ライブラリで使う単語をカバー) ──
const _extraItems = <PhonicsItem>[
  PhonicsItem('ow', 'ow', ipa: 'aʊ', example: 'cow'),
  PhonicsItem('ay', 'ay', ipa: 'eɪ', example: 'play'),
  PhonicsItem('ea', 'ee', ipa: 'iː', example: 'eat'),
  PhonicsItem('ey', 'ee', ipa: 'iː', example: 'key'),
  PhonicsItem('ew', 'yoo', ipa: 'juː', example: 'new'),
  PhonicsItem('ir', 'er', ipa: 'ɜːr', example: 'bird'),
  PhonicsItem('wh', 'wuh', ipa: 'w', example: 'white'),
  PhonicsItem('ear', 'eer', ipa: 'ɪər', example: 'ear'),
];

/// 全 7 グループ
const phonicsGroups = <PhonicsGroup>[
  PhonicsGroup(
    id: 0,
    name: 'Group 1: s a t i p n',
    items: _group1Items,
    cvcWords: ['sat', 'pin', 'tip', 'tan', 'sit', 'pan', 'nap', 'tap', 'tin', 'sip'],
  ),
  PhonicsGroup(
    id: 1,
    name: 'Group 2: ck e h r m d',
    items: _group2Items,
    cvcWords: ['hen', 'red', 'met', 'hem', 'deck', 'mad', 'ram', 'dam'],
  ),
  PhonicsGroup(
    id: 2,
    name: 'Group 3: g o u l f b',
    items: _group3Items,
    cvcWords: ['dog', 'log', 'fun', 'bug', 'fog', 'bun', 'ful', 'gob'],
  ),
  PhonicsGroup(
    id: 3,
    name: 'Group 4: ai j oa ie ee or',
    items: _group4Items,
    cvcWords: ['rain', 'jam', 'boat', 'tie', 'tree', 'fork'],
  ),
  PhonicsGroup(
    id: 4,
    name: 'Group 5: z w ng v oo',
    items: _group5Items,
    cvcWords: ['zip', 'web', 'ring', 'van', 'moon', 'book'],
  ),
  PhonicsGroup(
    id: 5,
    name: 'Group 6: y x ch sh th',
    items: _group6Items,
    cvcWords: ['yak', 'fox', 'chip', 'ship', 'thin', 'chat'],
  ),
  PhonicsGroup(
    id: 6,
    name: 'Group 7: qu ou oi ue er ar',
    items: _group7Items,
    cvcWords: ['queen', 'out', 'coin', 'blue', 'her', 'car'],
  ),
];

/// 全グループの全アイテムを1リストで返す
List<PhonicsItem> get allPhonicsItems =>
    [...phonicsGroups.expand((g) => g.items), ..._extraItems];

/// 最小ペア（1音だけ違う単語）
class MinimalPair {
  const MinimalPair(this.a, this.b, {required this.focus});

  final String a;
  final String b;
  final String focus;
}

const minimalPairs = <MinimalPair>[
  MinimalPair('ship', 'sheep', focus: 'ɪ vs iː'),
  MinimalPair('full', 'fool', focus: 'ʊ vs uː'),
  MinimalPair('cat', 'cut', focus: 'æ vs ʌ'),
  MinimalPair('hat', 'hot', focus: 'æ vs ɒ'),
  MinimalPair('fan', 'van', focus: 'f vs v'),
  MinimalPair('thin', 'then', focus: 'θ vs ð'),
  MinimalPair('rice', 'lice', focus: 'r vs l'),
  MinimalPair('sip', 'zip', focus: 's vs z'),
  MinimalPair('chip', 'ship', focus: 'tʃ vs ʃ'),
  MinimalPair('coat', 'goat', focus: 'k vs g'),
];

// ═══════════════════════════════════════════
//  Sound Categories for Game Setup
// ═══════════════════════════════════════════

/// Short vowels (a, e, i, o, u)
List<PhonicsItem> get shortVowelItems =>
    allPhonicsItems
        .where((i) => 'aeiou'.contains(i.letter) && i.letter.length == 1)
        .toList();

/// Single consonant letters
List<PhonicsItem> get consonantItems =>
    allPhonicsItems
        .where((i) => i.letter.length == 1 && !'aeiou'.contains(i.letter))
        .toList();

/// Digraphs and multi-letter sounds
List<PhonicsItem> get digraphItems =>
    allPhonicsItems.where((i) => i.letter.length > 1).toList();
