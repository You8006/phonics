/// 単語ライブラリー用の単語データ
class WordItem {
  const WordItem({
    required this.word,
    required this.meaning,
    required this.category,
    this.phonicsNote = '',
  });

  /// 英単語
  final String word;

  /// 日本語訳
  final String meaning;

  /// カテゴリ
  final String category;

  /// フォニックスのポイント（どの音が含まれるか等）
  final String phonicsNote;

  /// 音声ファイルのキー（ファイル名用）
  String get audioKey => word.toLowerCase().replaceAll(' ', '_');
}

/// カテゴリ定義
class WordCategory {
  const WordCategory({
    required this.id,
    required this.name,
    required this.nameJa,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String nameJa;
  final String icon;
  final int color;
}

const wordCategories = <WordCategory>[
  WordCategory(id: 'cvc', name: 'CVC Words', nameJa: 'CVC単語', icon: '🔤', color: 0xFFFF6B6B),
  WordCategory(id: 'sight', name: 'Sight Words', nameJa: 'サイトワード', icon: '👀', color: 0xFF4ECDC4),
  WordCategory(id: 'animals', name: 'Animals', nameJa: 'どうぶつ', icon: '🐾', color: 0xFFFFBE0B),
  WordCategory(id: 'colors', name: 'Colors', nameJa: 'いろ', icon: '🎨', color: 0xFFFF006E),
  WordCategory(id: 'numbers', name: 'Numbers', nameJa: 'かず', icon: '🔢', color: 0xFF8338EC),
  WordCategory(id: 'body', name: 'Body', nameJa: 'からだ', icon: '🦵', color: 0xFF3A86FF),
  WordCategory(id: 'food', name: 'Food', nameJa: 'たべもの', icon: '🍎', color: 0xFFE63946),
  WordCategory(id: 'family', name: 'Family', nameJa: 'かぞく', icon: '👨‍👩‍👧', color: 0xFF457B9D),
  WordCategory(id: 'actions', name: 'Actions', nameJa: 'うごき', icon: '🏃', color: 0xFF2A9D8F),
  WordCategory(id: 'adjectives', name: 'Adjectives', nameJa: 'ようす', icon: '✨', color: 0xFFE9C46A),
  WordCategory(id: 'nature', name: 'Nature', nameJa: 'しぜん', icon: '🌿', color: 0xFF52B788),
  WordCategory(id: 'daily', name: 'Daily Life', nameJa: 'せいかつ', icon: '🏠', color: 0xFF8D99AE),
];

/// 100単語のデータ
const wordLibrary = <WordItem>[
  // ── CVC Words (10) ──
  WordItem(word: 'cat', meaning: 'ねこ', category: 'cvc', phonicsNote: 'c-a-t / kæt'),
  WordItem(word: 'dog', meaning: 'いぬ', category: 'cvc', phonicsNote: 'd-o-g / dɒɡ'),
  WordItem(word: 'sun', meaning: 'たいよう', category: 'cvc', phonicsNote: 's-u-n / sʌn'),
  WordItem(word: 'hat', meaning: 'ぼうし', category: 'cvc', phonicsNote: 'h-a-t / hæt'),
  WordItem(word: 'pen', meaning: 'ペン', category: 'cvc', phonicsNote: 'p-e-n / pɛn'),
  WordItem(word: 'bus', meaning: 'バス', category: 'cvc', phonicsNote: 'b-u-s / bʌs'),
  WordItem(word: 'map', meaning: 'ちず', category: 'cvc', phonicsNote: 'm-a-p / mæp'),
  WordItem(word: 'bed', meaning: 'ベッド', category: 'cvc', phonicsNote: 'b-e-d / bɛd'),
  WordItem(word: 'cup', meaning: 'カップ', category: 'cvc', phonicsNote: 'c-u-p / kʌp'),
  WordItem(word: 'box', meaning: 'はこ', category: 'cvc', phonicsNote: 'b-o-x / bɒks'),

  // ── Sight Words (10) ──
  WordItem(word: 'the', meaning: 'その', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'and', meaning: 'そして', category: 'sight', phonicsNote: 'ænd'),
  WordItem(word: 'is', meaning: '〜です', category: 'sight', phonicsNote: 'ɪz'),
  WordItem(word: 'you', meaning: 'あなた', category: 'sight', phonicsNote: 'juː'),
  WordItem(word: 'it', meaning: 'それ', category: 'sight', phonicsNote: 'ɪt'),
  WordItem(word: 'he', meaning: 'かれ', category: 'sight', phonicsNote: 'hiː'),
  WordItem(word: 'she', meaning: 'かのじょ', category: 'sight', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'we', meaning: 'わたしたち', category: 'sight', phonicsNote: 'wiː'),
  WordItem(word: 'they', meaning: 'かれら', category: 'sight', phonicsNote: 'th = /ð/; ey = /eɪ/'),
  WordItem(word: 'my', meaning: 'わたしの', category: 'sight', phonicsNote: 'maɪ'),

  // ── Animals (10) ──
  WordItem(word: 'fish', meaning: 'さかな', category: 'animals', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'bird', meaning: 'とり', category: 'animals', phonicsNote: 'ir = /ɜː/'),
  WordItem(word: 'frog', meaning: 'カエル', category: 'animals', phonicsNote: 'fr- ブレンド'),
  WordItem(word: 'duck', meaning: 'アヒル', category: 'animals', phonicsNote: 'ck = /k/'),
  WordItem(word: 'pig', meaning: 'ブタ', category: 'animals', phonicsNote: 'p-i-g / pɪɡ'),
  WordItem(word: 'cow', meaning: 'うし', category: 'animals', phonicsNote: 'ow = /aʊ/'),
  WordItem(word: 'hen', meaning: 'めんどり', category: 'animals', phonicsNote: 'h-e-n / hɛn'),
  WordItem(word: 'fox', meaning: 'キツネ', category: 'animals', phonicsNote: 'x = /ks/'),
  WordItem(word: 'bee', meaning: 'ハチ', category: 'animals', phonicsNote: 'ee = /iː/'),
  WordItem(word: 'ant', meaning: 'アリ', category: 'animals', phonicsNote: 'a-n-t / ænt'),

  // ── Colors (8) ──
  WordItem(word: 'red', meaning: 'あか', category: 'colors', phonicsNote: 'r-e-d / rɛd'),
  WordItem(word: 'blue', meaning: 'あお', category: 'colors', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'green', meaning: 'みどり', category: 'colors', phonicsNote: 'ee = /iː/; gr- ブレンド'),
  WordItem(word: 'pink', meaning: 'ピンク', category: 'colors', phonicsNote: 'ng = /ŋ/; nk'),
  WordItem(word: 'black', meaning: 'くろ', category: 'colors', phonicsNote: 'bl- ブレンド; ck = /k/'),
  WordItem(word: 'white', meaning: 'しろ', category: 'colors', phonicsNote: 'wh = /w/; i_e = /aɪ/'),
  WordItem(word: 'yellow', meaning: 'きいろ', category: 'colors', phonicsNote: 'y = /j/; ow = /oʊ/'),
  WordItem(word: 'brown', meaning: 'ちゃいろ', category: 'colors', phonicsNote: 'br- ブレンド; ow = /aʊ/'),

  // ── Numbers (8) ──
  WordItem(word: 'one', meaning: 'いち', category: 'numbers', phonicsNote: 'wʌn（不規則）'),
  WordItem(word: 'two', meaning: 'に', category: 'numbers', phonicsNote: 'tuː（不規則）'),
  WordItem(word: 'three', meaning: 'さん', category: 'numbers', phonicsNote: 'th = /θ/; ee = /iː/'),
  WordItem(word: 'four', meaning: 'よん', category: 'numbers', phonicsNote: 'ou-r = /ɔː/'),
  WordItem(word: 'five', meaning: 'ご', category: 'numbers', phonicsNote: 'i_e = /aɪ/; v = /v/'),
  WordItem(word: 'six', meaning: 'ろく', category: 'numbers', phonicsNote: 's-i-x / sɪks'),
  WordItem(word: 'seven', meaning: 'なな', category: 'numbers', phonicsNote: 'v = /v/; e = /ɛ/'),
  WordItem(word: 'ten', meaning: 'じゅう', category: 'numbers', phonicsNote: 't-e-n / tɛn'),

  // ── Body (8) ──
  WordItem(word: 'hand', meaning: 'て', category: 'body', phonicsNote: 'h-a-nd / hænd'),
  WordItem(word: 'foot', meaning: 'あし', category: 'body', phonicsNote: 'oo = /ʊ/'),
  WordItem(word: 'head', meaning: 'あたま', category: 'body', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'nose', meaning: 'はな', category: 'body', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'ear', meaning: 'みみ', category: 'body', phonicsNote: 'ear = /ɪə/'),
  WordItem(word: 'eye', meaning: 'め', category: 'body', phonicsNote: 'eye = /aɪ/'),
  WordItem(word: 'leg', meaning: 'あし', category: 'body', phonicsNote: 'l-e-g / lɛɡ'),
  WordItem(word: 'arm', meaning: 'うで', category: 'body', phonicsNote: 'ar = /ɑː/'),

  // ── Food (10) ──
  WordItem(word: 'milk', meaning: 'ぎゅうにゅう', category: 'food', phonicsNote: 'm-i-lk / mɪlk'),
  WordItem(word: 'egg', meaning: 'たまご', category: 'food', phonicsNote: 'e-gg / ɛɡ'),
  WordItem(word: 'cake', meaning: 'ケーキ', category: 'food', phonicsNote: 'a_e = /eɪ/; ck = /k/'),
  WordItem(word: 'rice', meaning: 'ごはん', category: 'food', phonicsNote: 'i_e = /aɪ/; c = /s/'),
  WordItem(word: 'jam', meaning: 'ジャム', category: 'food', phonicsNote: 'j-a-m / dʒæm'),
  WordItem(word: 'nut', meaning: 'ナッツ', category: 'food', phonicsNote: 'n-u-t / nʌt'),
  WordItem(word: 'pie', meaning: 'パイ', category: 'food', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'soup', meaning: 'スープ', category: 'food', phonicsNote: 'ou = /uː/'),
  WordItem(word: 'plum', meaning: 'プラム', category: 'food', phonicsNote: 'pl- ブレンド; u = /ʌ/'),
  WordItem(word: 'chip', meaning: 'ポテトチップ', category: 'food', phonicsNote: 'ch = /tʃ/'),

  // ── Family (6) ──
  WordItem(word: 'mom', meaning: 'おかあさん', category: 'family', phonicsNote: 'm-o-m / mɒm'),
  WordItem(word: 'dad', meaning: 'おとうさん', category: 'family', phonicsNote: 'd-a-d / dæd'),
  WordItem(word: 'baby', meaning: 'あかちゃん', category: 'family', phonicsNote: 'a = /eɪ/; y = /iː/'),
  WordItem(word: 'boy', meaning: 'おとこのこ', category: 'family', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'girl', meaning: 'おんなのこ', category: 'family', phonicsNote: 'ir = /ɜː/; l'),
  WordItem(word: 'friend', meaning: 'ともだち', category: 'family', phonicsNote: 'fr- ブレンド; ie = /ɛ/'),

  // ── Actions (10) ──
  WordItem(word: 'run', meaning: 'はしる', category: 'actions', phonicsNote: 'r-u-n / rʌn'),
  WordItem(word: 'jump', meaning: 'とぶ', category: 'actions', phonicsNote: 'j-u-mp / dʒʌmp'),
  WordItem(word: 'sit', meaning: 'すわる', category: 'actions', phonicsNote: 's-i-t / sɪt'),
  WordItem(word: 'sing', meaning: 'うたう', category: 'actions', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'clap', meaning: 'たたく', category: 'actions', phonicsNote: 'cl- ブレンド; a = /æ/'),
  WordItem(word: 'swim', meaning: 'およぐ', category: 'actions', phonicsNote: 'sw- ブレンド; i = /ɪ/'),
  WordItem(word: 'read', meaning: 'よむ', category: 'actions', phonicsNote: 'ea = /iː/'),
  WordItem(word: 'play', meaning: 'あそぶ', category: 'actions', phonicsNote: 'pl- ブレンド; ay = /eɪ/'),
  WordItem(word: 'eat', meaning: 'たべる', category: 'actions', phonicsNote: 'ea = /iː/; t'),
  WordItem(word: 'stop', meaning: 'とまる', category: 'actions', phonicsNote: 'st- ブレンド; o = /ɒ/'),

  // ── Adjectives (10) ──
  WordItem(word: 'big', meaning: 'おおきい', category: 'adjectives', phonicsNote: 'b-i-g / bɪɡ'),
  WordItem(word: 'hot', meaning: 'あつい', category: 'adjectives', phonicsNote: 'h-o-t / hɒt'),
  WordItem(word: 'cold', meaning: 'つめたい', category: 'adjectives', phonicsNote: 'o = /oʊ/; ld'),
  WordItem(word: 'fast', meaning: 'はやい', category: 'adjectives', phonicsNote: 'a = /æ/; st'),
  WordItem(word: 'new', meaning: 'あたらしい', category: 'adjectives', phonicsNote: 'ew = /juː/'),
  WordItem(word: 'old', meaning: 'ふるい', category: 'adjectives', phonicsNote: 'o = /oʊ/; ld'),
  WordItem(word: 'good', meaning: 'いい', category: 'adjectives', phonicsNote: 'oo = /ʊ/; d'),
  WordItem(word: 'sad', meaning: 'かなしい', category: 'adjectives', phonicsNote: 's-a-d / sæd'),
  WordItem(word: 'fun', meaning: 'たのしい', category: 'adjectives', phonicsNote: 'f-u-n / fʌn'),
  WordItem(word: 'wet', meaning: 'ぬれた', category: 'adjectives', phonicsNote: 'w-e-t / wɛt'),

  // ── Nature (10) ──
  WordItem(word: 'rain', meaning: 'あめ', category: 'nature', phonicsNote: 'ai = /eɪ/; n'),
  WordItem(word: 'tree', meaning: 'き', category: 'nature', phonicsNote: 'tr- ブレンド; ee = /iː/'),
  WordItem(word: 'moon', meaning: 'つき', category: 'nature', phonicsNote: 'oo = /uː/; n'),
  WordItem(word: 'star', meaning: 'ほし', category: 'nature', phonicsNote: 'st- ブレンド; ar = /ɑː/'),
  WordItem(word: 'wind', meaning: 'かぜ', category: 'nature', phonicsNote: 'w-i-nd / wɪnd'),
  WordItem(word: 'rock', meaning: 'いわ', category: 'nature', phonicsNote: 'r-o-ck / rɒk'),
  WordItem(word: 'leaf', meaning: 'はっぱ', category: 'nature', phonicsNote: 'ea = /iː/; f'),
  WordItem(word: 'pond', meaning: 'いけ', category: 'nature', phonicsNote: 'p-o-nd / pɒnd'),
  WordItem(word: 'seed', meaning: 'たね', category: 'nature', phonicsNote: 'ee = /iː/; d'),
  WordItem(word: 'snow', meaning: 'ゆき', category: 'nature', phonicsNote: 'sn- ブレンド; ow = /oʊ/'),

  // ── Daily Life (10) ──
  WordItem(word: 'book', meaning: 'ほん', category: 'daily', phonicsNote: 'oo = /ʊ/; k'),
  WordItem(word: 'ball', meaning: 'ボール', category: 'daily', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'door', meaning: 'ドア', category: 'daily', phonicsNote: 'oo-r = /ɔː/'),
  WordItem(word: 'bag', meaning: 'かばん', category: 'daily', phonicsNote: 'b-a-g / bæɡ'),
  WordItem(word: 'clock', meaning: 'とけい', category: 'daily', phonicsNote: 'cl- ブレンド; ck = /k/'),
  WordItem(word: 'bell', meaning: 'ベル', category: 'daily', phonicsNote: 'b-e-ll / bɛl'),
  WordItem(word: 'shoe', meaning: 'くつ', category: 'daily', phonicsNote: 'sh = /ʃ/; oe = /uː/'),
  WordItem(word: 'lamp', meaning: 'ランプ', category: 'daily', phonicsNote: 'l-a-mp / læmp'),
  WordItem(word: 'soap', meaning: 'せっけん', category: 'daily', phonicsNote: 'oa = /oʊ/; p'),
  WordItem(word: 'key', meaning: 'かぎ', category: 'daily', phonicsNote: 'ey = /iː/'),
];

/// カテゴリごとの単語を取得
List<WordItem> getWordsByCategory(String categoryId) {
  return wordLibrary.where((w) => w.category == categoryId).toList();
}

/// 全カテゴリを取得（単語がある順番に）
List<WordCategory> get activeCategories {
  final usedIds = wordLibrary.map((w) => w.category).toSet();
  return wordCategories.where((c) => usedIds.contains(c.id)).toList();
}
