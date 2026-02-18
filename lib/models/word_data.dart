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
  WordCategory(id: 'cvc', name: 'CVC Words', nameJa: 'CVC単語', icon: '', color: 0xFFFF6B6B),
  WordCategory(id: 'cvc_basic', name: 'CVC Basic', nameJa: 'CVC基本', icon: '', color: 0xFFE07C56),
  WordCategory(id: 'sight', name: 'Sight Words', nameJa: 'サイトワード', icon: '', color: 0xFF4ECDC4),
  WordCategory(id: 'animals', name: 'Animals', nameJa: 'どうぶつ', icon: '', color: 0xFFFFBE0B),
  WordCategory(id: 'colors', name: 'Colors', nameJa: 'いろ', icon: '', color: 0xFFFF006E),
  WordCategory(id: 'numbers', name: 'Numbers', nameJa: 'かず', icon: '', color: 0xFF8338EC),
  WordCategory(id: 'body', name: 'Body', nameJa: 'からだ', icon: '', color: 0xFF3A86FF),
  WordCategory(id: 'food', name: 'Food', nameJa: 'たべもの', icon: '', color: 0xFFE63946),
  WordCategory(id: 'family', name: 'Family', nameJa: 'かぞく', icon: '', color: 0xFF457B9D),
  WordCategory(id: 'actions', name: 'Actions', nameJa: 'うごき', icon: '', color: 0xFF2A9D8F),
  WordCategory(id: 'adjectives', name: 'Adjectives', nameJa: 'ようす', icon: '', color: 0xFFE9C46A),
  WordCategory(id: 'nature', name: 'Nature', nameJa: 'しぜん', icon: '', color: 0xFF52B788),
  WordCategory(id: 'daily', name: 'Daily Life', nameJa: 'せいかつ', icon: '', color: 0xFF8D99AE),
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

  // ── Extra Phonics Words ── おとずかん用に追加
  // -- 既存の追加分 --
  WordItem(word: 'cook', meaning: 'りょうりする', category: 'actions', phonicsNote: 'oo = /ʊ/'),
  WordItem(word: 'fork', meaning: 'フォーク', category: 'food', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'car', meaning: 'くるま', category: 'daily', phonicsNote: 'ar = /ɑː/'),
  WordItem(word: 'park', meaning: 'こうえん', category: 'nature', phonicsNote: 'ar = /ɑː/'),
  WordItem(word: 'her', meaning: 'かのじょの', category: 'sight', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'turn', meaning: 'まわる', category: 'actions', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'out', meaning: 'そと', category: 'sight', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'house', meaning: 'いえ', category: 'daily', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'coin', meaning: 'コイン', category: 'daily', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'toy', meaning: 'おもちゃ', category: 'daily', phonicsNote: 'oy = /ɔɪ/'),
  WordItem(word: 'oil', meaning: 'あぶら', category: 'food', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'near', meaning: 'ちかい', category: 'adjectives', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'hear', meaning: 'きく', category: 'actions', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'dear', meaning: 'しんあいな', category: 'adjectives', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'chin', meaning: 'あご', category: 'body', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'lunch', meaning: 'ひるごはん', category: 'food', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'much', meaning: 'たくさん', category: 'adjectives', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'jug', meaning: 'ジャグ', category: 'daily', phonicsNote: 'j = /dʒ/'),
  WordItem(word: 'jet', meaning: 'ジェット', category: 'daily', phonicsNote: 'j = /dʒ/'),
  WordItem(word: 'ring', meaning: 'ゆびわ', category: 'daily', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'king', meaning: 'おうさま', category: 'family', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'ship', meaning: 'ふね', category: 'daily', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'thin', meaning: 'うすい', category: 'adjectives', phonicsNote: 'th = /θ/'),
  WordItem(word: 'bath', meaning: 'おふろ', category: 'daily', phonicsNote: 'th = /θ/'),
  WordItem(word: 'tooth', meaning: 'は', category: 'body', phonicsNote: 'th = /θ/; oo = /uː/'),
  WordItem(word: 'this', meaning: 'これ', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'that', meaning: 'それ', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'van', meaning: 'バン', category: 'daily', phonicsNote: 'v = /v/'),
  WordItem(word: 'love', meaning: 'あい', category: 'adjectives', phonicsNote: 'v = /v/'),
  WordItem(word: 'yes', meaning: 'はい', category: 'sight', phonicsNote: 'y = /j/'),
  WordItem(word: 'yak', meaning: 'ヤク', category: 'animals', phonicsNote: 'y = /j/'),
  WordItem(word: 'zip', meaning: 'ジッパー', category: 'daily', phonicsNote: 'z = /z/'),
  WordItem(word: 'zoo', meaning: 'どうぶつえん', category: 'daily', phonicsNote: 'z = /z/'),
  WordItem(word: 'buzz', meaning: 'ブーン', category: 'nature', phonicsNote: 'zz = /z/'),
  WordItem(word: 'mix', meaning: 'まぜる', category: 'actions', phonicsNote: 'x = /ks/'),

  // -- スペリング別グルーピング用の追加単語 (94語) --
  // e_short / ea
  WordItem(word: 'bread', meaning: 'パン', category: 'food', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'dead', meaning: 'しんだ', category: 'adjectives', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'spread', meaning: 'ひろげる', category: 'actions', phonicsNote: 'ea = /ɛ/'),
  // ei / a_e
  WordItem(word: 'make', meaning: 'つくる', category: 'actions', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'name', meaning: 'なまえ', category: 'daily', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'game', meaning: 'ゲーム', category: 'daily', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'lake', meaning: 'みずうみ', category: 'nature', phonicsNote: 'a_e = /eɪ/'),
  // ei / ai
  WordItem(word: 'train', meaning: 'でんしゃ', category: 'daily', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'tail', meaning: 'しっぽ', category: 'animals', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'snail', meaning: 'カタツムリ', category: 'animals', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'wait', meaning: 'まつ', category: 'actions', phonicsNote: 'ai = /eɪ/'),
  // ei / ay
  WordItem(word: 'day', meaning: 'にち', category: 'daily', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'say', meaning: 'いう', category: 'actions', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'way', meaning: 'みち', category: 'daily', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'stay', meaning: 'とまる', category: 'actions', phonicsNote: 'ay = /eɪ/'),
  // ii / ea
  WordItem(word: 'tea', meaning: 'おちゃ', category: 'food', phonicsNote: 'ea = /iː/'),
  WordItem(word: 'sea', meaning: 'うみ', category: 'nature', phonicsNote: 'ea = /iː/'),
  // ii / e
  WordItem(word: 'me', meaning: 'わたし', category: 'sight', phonicsNote: 'e = /iː/'),
  WordItem(word: 'be', meaning: '〜である', category: 'sight', phonicsNote: 'e = /iː/'),
  // ai / i_e
  WordItem(word: 'bike', meaning: 'じてんしゃ', category: 'daily', phonicsNote: 'i_e = /aɪ/'),
  WordItem(word: 'kite', meaning: 'たこ', category: 'daily', phonicsNote: 'i_e = /aɪ/'),
  // ai / ie
  WordItem(word: 'tie', meaning: 'ネクタイ', category: 'daily', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'die', meaning: 'サイコロ', category: 'daily', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'lie', meaning: 'よこになる', category: 'actions', phonicsNote: 'ie = /aɪ/'),
  // ai / y
  WordItem(word: 'fly', meaning: 'とぶ', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'cry', meaning: 'なく', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'try', meaning: 'ためす', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'sky', meaning: 'そら', category: 'nature', phonicsNote: 'y = /aɪ/'),
  // ai / igh
  WordItem(word: 'high', meaning: 'たかい', category: 'adjectives', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'night', meaning: 'よる', category: 'nature', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'light', meaning: 'ひかり', category: 'daily', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'right', meaning: 'みぎ/ただしい', category: 'adjectives', phonicsNote: 'igh = /aɪ/'),
  // ou_long / o_e
  WordItem(word: 'home', meaning: 'いえ', category: 'daily', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'bone', meaning: 'ほね', category: 'body', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'hope', meaning: 'きぼう', category: 'adjectives', phonicsNote: 'o_e = /oʊ/'),
  // ou_long / oa
  WordItem(word: 'boat', meaning: 'ボート', category: 'daily', phonicsNote: 'oa = /oʊ/'),
  WordItem(word: 'coat', meaning: 'コート', category: 'daily', phonicsNote: 'oa = /oʊ/'),
  WordItem(word: 'goat', meaning: 'ヤギ', category: 'animals', phonicsNote: 'oa = /oʊ/'),
  // ou_long / ow
  WordItem(word: 'blow', meaning: 'ふく', category: 'actions', phonicsNote: 'ow = /oʊ/'),
  WordItem(word: 'grow', meaning: 'そだつ', category: 'actions', phonicsNote: 'ow = /oʊ/'),
  // ou_long / o
  WordItem(word: 'go', meaning: 'いく', category: 'actions', phonicsNote: 'o = /oʊ/'),
  WordItem(word: 'no', meaning: 'いいえ', category: 'sight', phonicsNote: 'o = /oʊ/'),
  // uu / oo
  WordItem(word: 'food', meaning: 'たべもの', category: 'food', phonicsNote: 'oo = /uː/'),
  WordItem(word: 'cool', meaning: 'すずしい', category: 'adjectives', phonicsNote: 'oo = /uː/'),
  // uu / ew
  WordItem(word: 'flew', meaning: 'とんだ', category: 'actions', phonicsNote: 'ew = /uː/'),
  WordItem(word: 'drew', meaning: 'えがいた', category: 'actions', phonicsNote: 'ew = /uː/'),
  WordItem(word: 'chew', meaning: 'かむ', category: 'actions', phonicsNote: 'ew = /uː/'),
  // uu / ue
  WordItem(word: 'clue', meaning: 'ヒント', category: 'daily', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'true', meaning: 'ほんとう', category: 'adjectives', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'glue', meaning: 'のり', category: 'daily', phonicsNote: 'ue = /uː/'),
  // or_sound / or
  WordItem(word: 'corn', meaning: 'トウモロコシ', category: 'food', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'born', meaning: 'うまれた', category: 'adjectives', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'sort', meaning: 'わける', category: 'actions', phonicsNote: 'or = /ɔː/'),
  // or_sound / all
  WordItem(word: 'fall', meaning: 'おちる', category: 'actions', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'tall', meaning: 'たかい', category: 'adjectives', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'wall', meaning: 'かべ', category: 'daily', phonicsNote: 'all = /ɔːl/'),
  // er_sound / er
  WordItem(word: 'fern', meaning: 'シダ', category: 'nature', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'herb', meaning: 'ハーブ', category: 'food', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'herd', meaning: 'むれ', category: 'animals', phonicsNote: 'er = /ɜː/'),
  // er_sound / ir
  WordItem(word: 'dirt', meaning: 'どろ', category: 'nature', phonicsNote: 'ir = /ɜː/'),
  WordItem(word: 'shirt', meaning: 'シャツ', category: 'daily', phonicsNote: 'ir = /ɜː/'),
  // er_sound / ur
  WordItem(word: 'burn', meaning: 'もえる', category: 'actions', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'hurt', meaning: 'いたい', category: 'adjectives', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'fur', meaning: 'けがわ', category: 'animals', phonicsNote: 'ur = /ɜː/'),
  // au_sound / ou
  WordItem(word: 'loud', meaning: 'おおきい(おと)', category: 'adjectives', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'mouth', meaning: 'くち', category: 'body', phonicsNote: 'ou = /aʊ/'),
  // au_sound / ow
  WordItem(word: 'down', meaning: 'した', category: 'adjectives', phonicsNote: 'ow = /aʊ/'),
  WordItem(word: 'town', meaning: 'まち', category: 'daily', phonicsNote: 'ow = /aʊ/'),
  // oi_sound / oi
  WordItem(word: 'join', meaning: 'くわわる', category: 'actions', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'point', meaning: 'さす', category: 'actions', phonicsNote: 'oi = /ɔɪ/'),
  // oi_sound / oy
  WordItem(word: 'joy', meaning: 'よろこび', category: 'adjectives', phonicsNote: 'oy = /ɔɪ/'),
  WordItem(word: 'enjoy', meaning: 'たのしむ', category: 'actions', phonicsNote: 'oy = /ɔɪ/'),
  // ear_sound / eer
  WordItem(word: 'deer', meaning: 'シカ', category: 'animals', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'cheer', meaning: 'おうえん', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'steer', meaning: 'かじをとる', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'peer', meaning: 'じっと見る', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  // k_sound / k
  WordItem(word: 'keep', meaning: 'たもつ', category: 'actions', phonicsNote: 'k = /k/'),
  // f_sound / ph
  WordItem(word: 'phone', meaning: 'でんわ', category: 'daily', phonicsNote: 'ph = /f/'),
  WordItem(word: 'photo', meaning: 'しゃしん', category: 'daily', phonicsNote: 'ph = /f/'),
  WordItem(word: 'dolphin', meaning: 'イルカ', category: 'animals', phonicsNote: 'ph = /f/'),
  WordItem(word: 'elephant', meaning: 'ゾウ', category: 'animals', phonicsNote: 'ph = /f/'),
  // n_sound / kn
  WordItem(word: 'knee', meaning: 'ひざ', category: 'body', phonicsNote: 'kn = /n/'),
  WordItem(word: 'knife', meaning: 'ナイフ', category: 'daily', phonicsNote: 'kn = /n/'),
  WordItem(word: 'knot', meaning: 'むすびめ', category: 'daily', phonicsNote: 'kn = /n/'),
  WordItem(word: 'know', meaning: 'しる', category: 'sight', phonicsNote: 'kn = /n/'),
  // r_sound / wr
  WordItem(word: 'write', meaning: 'かく', category: 'actions', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrong', meaning: 'まちがい', category: 'adjectives', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrap', meaning: 'つつむ', category: 'actions', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrist', meaning: 'てくび', category: 'body', phonicsNote: 'wr = /r/'),
  // w_sound / wh
  WordItem(word: 'what', meaning: 'なに', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'when', meaning: 'いつ', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'where', meaning: 'どこ', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'whale', meaning: 'クジラ', category: 'animals', phonicsNote: 'wh = /w/'),
  // z_sound
  WordItem(word: 'zero', meaning: 'ゼロ', category: 'numbers', phonicsNote: 'z = /z/'),
  WordItem(word: 'song', meaning: 'うた', category: 'daily', phonicsNote: 'ng = /ŋ/'),

  // ── MinimalPairs 追加単語 ──
  WordItem(word: 'sheep', meaning: 'ひつじ', category: 'animals', phonicsNote: 'ee = /iː/; sh = /ʃ/'),
  WordItem(word: 'full', meaning: 'いっぱいの', category: 'adjectives', phonicsNote: 'u = /ʊ/; ll'),
  WordItem(word: 'fool', meaning: 'おろかもの', category: 'adjectives', phonicsNote: 'oo = /uː/'),
  WordItem(word: 'cut', meaning: 'きる', category: 'cvc_basic', phonicsNote: 'c-u-t / kʌt'),
  WordItem(word: 'bad', meaning: 'わるい', category: 'adjectives', phonicsNote: 'b-a-d / bæd'),
  WordItem(word: 'sat', meaning: 'すわった', category: 'cvc_basic', phonicsNote: 's-a-t / sæt'),
  WordItem(word: 'pin', meaning: 'ピン', category: 'daily', phonicsNote: 'p-i-n / pɪn'),
  WordItem(word: 'cop', meaning: 'けいかん', category: 'cvc_basic', phonicsNote: 'c-o-p / kɒp'),
  WordItem(word: 'hit', meaning: 'たたく', category: 'cvc_basic', phonicsNote: 'h-i-t / hɪt'),
  WordItem(word: 'not', meaning: 'ではない', category: 'sight', phonicsNote: 'n-o-t / nɒt'),
  WordItem(word: 'bet', meaning: 'かける', category: 'cvc_basic', phonicsNote: 'b-e-t / bɛt'),
  WordItem(word: 'bat', meaning: 'バット', category: 'cvc_basic', phonicsNote: 'b-a-t / bæt'),
  WordItem(word: 'fan', meaning: 'せんぷうき', category: 'daily', phonicsNote: 'f-a-n / fæn'),
  WordItem(word: 'then', meaning: 'それから', category: 'sight', phonicsNote: 'th = /ð/; e = /ɛ/'),
  WordItem(word: 'lice', meaning: 'シラミ', category: 'animals', phonicsNote: 'i_e = /aɪ/; c = /s/'),
  WordItem(word: 'sip', meaning: 'すする', category: 'cvc_basic', phonicsNote: 's-i-p / sɪp'),
  WordItem(word: 'ban', meaning: 'きんし', category: 'cvc_basic', phonicsNote: 'b-a-n / bæn'),
  WordItem(word: 'yet', meaning: 'まだ', category: 'sight', phonicsNote: 'y = /j/; e = /ɛ/'),
  WordItem(word: 'cap', meaning: 'ぼうし', category: 'daily', phonicsNote: 'c-a-p / kæp'),
  WordItem(word: 'beer', meaning: 'ビール', category: 'food', phonicsNote: 'eer = /ɪər/'),

  // ── cvcWords & PhonicsItem.example 不足分 25語 ──
  WordItem(word: 'tip', meaning: 'チップ・先', category: 'cvc_basic', phonicsNote: 't-i-p / tɪp'),
  WordItem(word: 'tan', meaning: 'ひやけ', category: 'cvc_basic', phonicsNote: 't-a-n / tæn'),
  WordItem(word: 'pan', meaning: 'フライパン', category: 'cvc_basic', phonicsNote: 'p-a-n / pæn'),
  WordItem(word: 'nap', meaning: 'ひるね', category: 'cvc_basic', phonicsNote: 'n-a-p / næp'),
  WordItem(word: 'tap', meaning: 'じゃぐち', category: 'cvc_basic', phonicsNote: 't-a-p / tæp'),
  WordItem(word: 'tin', meaning: 'かん・ブリキ', category: 'cvc_basic', phonicsNote: 't-i-n / tɪn'),
  WordItem(word: 'met', meaning: 'あった', category: 'cvc_basic', phonicsNote: 'm-e-t / mɛt'),
  WordItem(word: 'hem', meaning: 'すそ', category: 'cvc_basic', phonicsNote: 'h-e-m / hɛm'),
  WordItem(word: 'deck', meaning: 'デッキ', category: 'cvc_basic', phonicsNote: 'd-e-ck / dɛk; ck = /k/'),
  WordItem(word: 'mad', meaning: 'おこった', category: 'cvc_basic', phonicsNote: 'm-a-d / mæd'),
  WordItem(word: 'ram', meaning: 'おすひつじ', category: 'animals', phonicsNote: 'r-a-m / ræm'),
  WordItem(word: 'dam', meaning: 'ダム', category: 'cvc_basic', phonicsNote: 'd-a-m / dæm'),
  WordItem(word: 'log', meaning: 'まるた', category: 'nature', phonicsNote: 'l-o-g / lɒɡ'),
  WordItem(word: 'bug', meaning: 'むし', category: 'animals', phonicsNote: 'b-u-g / bʌɡ'),
  WordItem(word: 'fog', meaning: 'きり', category: 'nature', phonicsNote: 'f-o-g / fɒɡ'),
  WordItem(word: 'bun', meaning: 'まるパン', category: 'food', phonicsNote: 'b-u-n / bʌn'),
  WordItem(word: 'ink', meaning: 'インク', category: 'daily', phonicsNote: 'i-nk / ɪŋk; nk = /ŋk/'),
  WordItem(word: 'net', meaning: 'ネット', category: 'cvc_basic', phonicsNote: 'n-e-t / nɛt'),
  WordItem(word: 'sock', meaning: 'くつした', category: 'daily', phonicsNote: 's-o-ck / sɒk; ck = /k/'),
  WordItem(word: 'rat', meaning: 'ネズミ', category: 'animals', phonicsNote: 'r-a-t / ræt'),
  WordItem(word: 'got', meaning: 'てにいれた', category: 'cvc_basic', phonicsNote: 'g-o-t / ɡɒt'),
  WordItem(word: 'on', meaning: 'のうえに', category: 'sight', phonicsNote: 'ɒn'),
  WordItem(word: 'up', meaning: 'うえに', category: 'sight', phonicsNote: 'ʌp'),
  WordItem(word: 'web', meaning: 'くものす', category: 'nature', phonicsNote: 'w-e-b / wɛb'),
  WordItem(word: 'queen', meaning: 'じょおう', category: 'daily', phonicsNote: 'qu = /kw/; ee = /iː/'),
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
