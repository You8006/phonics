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
    required this.nameJa,
    required this.color,
  });

  final String id;
  final String nameJa;
  final int color;
}

const wordCategories = <WordCategory>[
  WordCategory(id: 'cvc', nameJa: 'CVC単語', color: 0xFF8B7355),
  WordCategory(id: 'cvc_basic', nameJa: 'CVC基本', color: 0xFFA0896E),
  WordCategory(id: 'sight', nameJa: 'サイトワード', color: 0xFF6B8F9E),
  WordCategory(id: 'animals', nameJa: '動物', color: 0xFF7A9E7E),
  WordCategory(id: 'colors', nameJa: '色', color: 0xFF9E7A8E),
  WordCategory(id: 'numbers', nameJa: '数', color: 0xFF7E85A0),
  WordCategory(id: 'body', nameJa: '身体', color: 0xFF6E8CA0),
  WordCategory(id: 'food', nameJa: '食べ物', color: 0xFFA08070),
  WordCategory(id: 'family', nameJa: '家族', color: 0xFF7B8FA0),
  WordCategory(id: 'actions', nameJa: '動作', color: 0xFF6E9490),
  WordCategory(id: 'adjectives', nameJa: '形容詞', color: 0xFFA0956E),
  WordCategory(id: 'nature', nameJa: '自然', color: 0xFF6E9478),
  WordCategory(id: 'daily', nameJa: '日常', color: 0xFF8A8FA0),
];

/// 100単語のデータ
const wordLibrary = <WordItem>[
  // ── CVC Words (10) ──
  WordItem(word: 'cat', meaning: '猫', category: 'cvc', phonicsNote: 'c-a-t / kæt'),
  WordItem(word: 'dog', meaning: '犬', category: 'cvc', phonicsNote: 'd-o-g / dɒɡ'),
  WordItem(word: 'sun', meaning: '太陽', category: 'cvc', phonicsNote: 's-u-n / sʌn'),
  WordItem(word: 'hat', meaning: '帽子', category: 'cvc', phonicsNote: 'h-a-t / hæt'),
  WordItem(word: 'pen', meaning: 'ペン', category: 'cvc', phonicsNote: 'p-e-n / pɛn'),
  WordItem(word: 'bus', meaning: 'バス', category: 'cvc', phonicsNote: 'b-u-s / bʌs'),
  WordItem(word: 'map', meaning: '地図', category: 'cvc', phonicsNote: 'm-a-p / mæp'),
  WordItem(word: 'bed', meaning: 'ベッド', category: 'cvc', phonicsNote: 'b-e-d / bɛd'),
  WordItem(word: 'cup', meaning: 'カップ', category: 'cvc', phonicsNote: 'c-u-p / kʌp'),
  WordItem(word: 'box', meaning: '箱', category: 'cvc', phonicsNote: 'b-o-x / bɒks'),

  // ── Sight Words (10) ──
  WordItem(word: 'the', meaning: 'その', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'and', meaning: 'そして', category: 'sight', phonicsNote: 'ænd'),
  WordItem(word: 'is', meaning: '〜です', category: 'sight', phonicsNote: 'ɪz'),
  WordItem(word: 'you', meaning: 'あなた', category: 'sight', phonicsNote: 'juː'),
  WordItem(word: 'it', meaning: 'それ', category: 'sight', phonicsNote: 'ɪt'),
  WordItem(word: 'he', meaning: '彼', category: 'sight', phonicsNote: 'hiː'),
  WordItem(word: 'she', meaning: '彼女', category: 'sight', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'we', meaning: '私たち', category: 'sight', phonicsNote: 'wiː'),
  WordItem(word: 'they', meaning: '彼ら', category: 'sight', phonicsNote: 'th = /ð/; ey = /eɪ/'),
  WordItem(word: 'my', meaning: '私の', category: 'sight', phonicsNote: 'maɪ'),

  // ── Animals (10) ──
  WordItem(word: 'fish', meaning: '魚', category: 'animals', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'bird', meaning: '鳥', category: 'animals', phonicsNote: 'ir = /ɜː/'),
  WordItem(word: 'frog', meaning: 'カエル', category: 'animals', phonicsNote: 'fr- ブレンド'),
  WordItem(word: 'duck', meaning: 'アヒル', category: 'animals', phonicsNote: 'ck = /k/'),
  WordItem(word: 'pig', meaning: '豚', category: 'animals', phonicsNote: 'p-i-g / pɪɡ'),
  WordItem(word: 'cow', meaning: '牛', category: 'animals', phonicsNote: 'ow = /aʊ/'),
  WordItem(word: 'hen', meaning: '雌鶏', category: 'animals', phonicsNote: 'h-e-n / hɛn'),
  WordItem(word: 'fox', meaning: 'キツネ', category: 'animals', phonicsNote: 'x = /ks/'),
  WordItem(word: 'bee', meaning: '蜂', category: 'animals', phonicsNote: 'ee = /iː/'),
  WordItem(word: 'ant', meaning: '蟻', category: 'animals', phonicsNote: 'a-n-t / ænt'),

  // ── Colors (8) ──
  WordItem(word: 'red', meaning: '赤', category: 'colors', phonicsNote: 'r-e-d / rɛd'),
  WordItem(word: 'blue', meaning: '青', category: 'colors', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'green', meaning: '緑', category: 'colors', phonicsNote: 'ee = /iː/; gr- ブレンド'),
  WordItem(word: 'pink', meaning: 'ピンク', category: 'colors', phonicsNote: 'ng = /ŋ/; nk'),
  WordItem(word: 'black', meaning: '黒', category: 'colors', phonicsNote: 'bl- ブレンド; ck = /k/'),
  WordItem(word: 'white', meaning: '白', category: 'colors', phonicsNote: 'wh = /w/; i_e = /aɪ/'),
  WordItem(word: 'yellow', meaning: '黄色', category: 'colors', phonicsNote: 'y = /j/; ow = /oʊ/'),
  WordItem(word: 'brown', meaning: '茶色', category: 'colors', phonicsNote: 'br- ブレンド; ow = /aʊ/'),

  // ── Numbers (8) ──
  WordItem(word: 'one', meaning: '一', category: 'numbers', phonicsNote: 'wʌn（不規則）'),
  WordItem(word: 'two', meaning: '二', category: 'numbers', phonicsNote: 'tuː（不規則）'),
  WordItem(word: 'three', meaning: '三', category: 'numbers', phonicsNote: 'th = /θ/; ee = /iː/'),
  WordItem(word: 'four', meaning: '四', category: 'numbers', phonicsNote: 'ou-r = /ɔː/'),
  WordItem(word: 'five', meaning: '五', category: 'numbers', phonicsNote: 'i_e = /aɪ/; v = /v/'),
  WordItem(word: 'six', meaning: '六', category: 'numbers', phonicsNote: 's-i-x / sɪks'),
  WordItem(word: 'seven', meaning: '七', category: 'numbers', phonicsNote: 'v = /v/; e = /ɛ/'),
  WordItem(word: 'ten', meaning: '十', category: 'numbers', phonicsNote: 't-e-n / tɛn'),

  // ── Body (8) ──
  WordItem(word: 'hand', meaning: '手', category: 'body', phonicsNote: 'h-a-nd / hænd'),
  WordItem(word: 'foot', meaning: '足', category: 'body', phonicsNote: 'oo = /ʊ/'),
  WordItem(word: 'head', meaning: '頭', category: 'body', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'nose', meaning: '鼻', category: 'body', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'ear', meaning: '耳', category: 'body', phonicsNote: 'ear = /ɪə/'),
  WordItem(word: 'eye', meaning: '目', category: 'body', phonicsNote: 'eye = /aɪ/'),
  WordItem(word: 'leg', meaning: '脚', category: 'body', phonicsNote: 'l-e-g / lɛɡ'),
  WordItem(word: 'arm', meaning: '腕', category: 'body', phonicsNote: 'ar = /ɑː/'),

  // ── Food (10) ──
  WordItem(word: 'milk', meaning: '牛乳', category: 'food', phonicsNote: 'm-i-lk / mɪlk'),
  WordItem(word: 'egg', meaning: '卵', category: 'food', phonicsNote: 'e-gg / ɛɡ'),
  WordItem(word: 'cake', meaning: 'ケーキ', category: 'food', phonicsNote: 'a_e = /eɪ/; ck = /k/'),
  WordItem(word: 'rice', meaning: 'ご飯', category: 'food', phonicsNote: 'i_e = /aɪ/; c = /s/'),
  WordItem(word: 'jam', meaning: 'ジャム', category: 'food', phonicsNote: 'j-a-m / dʒæm'),
  WordItem(word: 'nut', meaning: 'ナッツ', category: 'food', phonicsNote: 'n-u-t / nʌt'),
  WordItem(word: 'pie', meaning: 'パイ', category: 'food', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'soup', meaning: 'スープ', category: 'food', phonicsNote: 'ou = /uː/'),
  WordItem(word: 'plum', meaning: 'プラム', category: 'food', phonicsNote: 'pl- ブレンド; u = /ʌ/'),
  WordItem(word: 'chip', meaning: 'ポテトチップ', category: 'food', phonicsNote: 'ch = /tʃ/'),

  // ── Family (6) ──
  WordItem(word: 'mom', meaning: '母', category: 'family', phonicsNote: 'm-o-m / mɒm'),
  WordItem(word: 'dad', meaning: '父', category: 'family', phonicsNote: 'd-a-d / dæd'),
  WordItem(word: 'baby', meaning: '赤ちゃん', category: 'family', phonicsNote: 'a = /eɪ/; y = /iː/'),
  WordItem(word: 'boy', meaning: '男の子', category: 'family', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'girl', meaning: '女の子', category: 'family', phonicsNote: 'ir = /ɜː/; l'),
  WordItem(word: 'friend', meaning: '友人', category: 'family', phonicsNote: 'fr- ブレンド; ie = /ɛ/'),

  // ── Actions (10) ──
  WordItem(word: 'run', meaning: '走る', category: 'actions', phonicsNote: 'r-u-n / rʌn'),
  WordItem(word: 'jump', meaning: '跳ぶ', category: 'actions', phonicsNote: 'j-u-mp / dʒʌmp'),
  WordItem(word: 'sit', meaning: '座る', category: 'actions', phonicsNote: 's-i-t / sɪt'),
  WordItem(word: 'sing', meaning: '歌う', category: 'actions', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'clap', meaning: '叩く', category: 'actions', phonicsNote: 'cl- ブレンド; a = /æ/'),
  WordItem(word: 'swim', meaning: '泳ぐ', category: 'actions', phonicsNote: 'sw- ブレンド; i = /ɪ/'),
  WordItem(word: 'read', meaning: '読む', category: 'actions', phonicsNote: 'ea = /iː/'),
  WordItem(word: 'play', meaning: '遊ぶ', category: 'actions', phonicsNote: 'pl- ブレンド; ay = /eɪ/'),
  WordItem(word: 'eat', meaning: '食べる', category: 'actions', phonicsNote: 'ea = /iː/; t'),
  WordItem(word: 'stop', meaning: '止まる', category: 'actions', phonicsNote: 'st- ブレンド; o = /ɒ/'),

  // ── Adjectives (10) ──
  WordItem(word: 'big', meaning: '大きい', category: 'adjectives', phonicsNote: 'b-i-g / bɪɡ'),
  WordItem(word: 'hot', meaning: '暑い', category: 'adjectives', phonicsNote: 'h-o-t / hɒt'),
  WordItem(word: 'cold', meaning: '冷たい', category: 'adjectives', phonicsNote: 'o = /oʊ/; ld'),
  WordItem(word: 'fast', meaning: '速い', category: 'adjectives', phonicsNote: 'a = /æ/; st'),
  WordItem(word: 'new', meaning: '新しい', category: 'adjectives', phonicsNote: 'ew = /juː/'),
  WordItem(word: 'old', meaning: '古い', category: 'adjectives', phonicsNote: 'o = /oʊ/; ld'),
  WordItem(word: 'good', meaning: '良い', category: 'adjectives', phonicsNote: 'oo = /ʊ/; d'),
  WordItem(word: 'sad', meaning: '悲しい', category: 'adjectives', phonicsNote: 's-a-d / sæd'),
  WordItem(word: 'fun', meaning: '楽しい', category: 'adjectives', phonicsNote: 'f-u-n / fʌn'),
  WordItem(word: 'wet', meaning: '濡れた', category: 'adjectives', phonicsNote: 'w-e-t / wɛt'),

  // ── Nature (10) ──
  WordItem(word: 'rain', meaning: '雨', category: 'nature', phonicsNote: 'ai = /eɪ/; n'),
  WordItem(word: 'tree', meaning: '木', category: 'nature', phonicsNote: 'tr- ブレンド; ee = /iː/'),
  WordItem(word: 'moon', meaning: '月', category: 'nature', phonicsNote: 'oo = /uː/; n'),
  WordItem(word: 'star', meaning: '星', category: 'nature', phonicsNote: 'st- ブレンド; ar = /ɑː/'),
  WordItem(word: 'wind', meaning: '風', category: 'nature', phonicsNote: 'w-i-nd / wɪnd'),
  WordItem(word: 'rock', meaning: '岩', category: 'nature', phonicsNote: 'r-o-ck / rɒk'),
  WordItem(word: 'leaf', meaning: '葉', category: 'nature', phonicsNote: 'ea = /iː/; f'),
  WordItem(word: 'pond', meaning: '池', category: 'nature', phonicsNote: 'p-o-nd / pɒnd'),
  WordItem(word: 'seed', meaning: '種', category: 'nature', phonicsNote: 'ee = /iː/; d'),
  WordItem(word: 'snow', meaning: '雪', category: 'nature', phonicsNote: 'sn- ブレンド; ow = /oʊ/'),

  // ── Daily Life (10) ──
  WordItem(word: 'book', meaning: '本', category: 'daily', phonicsNote: 'oo = /ʊ/; k'),
  WordItem(word: 'ball', meaning: 'ボール', category: 'daily', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'door', meaning: 'ドア', category: 'daily', phonicsNote: 'oo-r = /ɔː/'),
  WordItem(word: 'bag', meaning: '鞄', category: 'daily', phonicsNote: 'b-a-g / bæɡ'),
  WordItem(word: 'clock', meaning: '時計', category: 'daily', phonicsNote: 'cl- ブレンド; ck = /k/'),
  WordItem(word: 'bell', meaning: 'ベル', category: 'daily', phonicsNote: 'b-e-ll / bɛl'),
  WordItem(word: 'shoe', meaning: '靴', category: 'daily', phonicsNote: 'sh = /ʃ/; oe = /uː/'),
  WordItem(word: 'lamp', meaning: 'ランプ', category: 'daily', phonicsNote: 'l-a-mp / læmp'),
  WordItem(word: 'soap', meaning: '石鹸', category: 'daily', phonicsNote: 'oa = /oʊ/; p'),
  WordItem(word: 'key', meaning: '鍵', category: 'daily', phonicsNote: 'ey = /iː/'),

  // ── Extra Phonics Words ── おとずかん用に追加
  // -- 既存の追加分 --
  WordItem(word: 'cook', meaning: '料理する', category: 'actions', phonicsNote: 'oo = /ʊ/'),
  WordItem(word: 'fork', meaning: 'フォーク', category: 'food', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'car', meaning: '車', category: 'daily', phonicsNote: 'ar = /ɑː/'),
  WordItem(word: 'park', meaning: '公園', category: 'nature', phonicsNote: 'ar = /ɑː/'),
  WordItem(word: 'her', meaning: '彼女の', category: 'sight', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'turn', meaning: '回る', category: 'actions', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'out', meaning: '外', category: 'sight', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'house', meaning: '家', category: 'daily', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'coin', meaning: 'コイン', category: 'daily', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'toy', meaning: 'おもちゃ', category: 'daily', phonicsNote: 'oy = /ɔɪ/'),
  WordItem(word: 'oil', meaning: '油', category: 'food', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'near', meaning: '近い', category: 'adjectives', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'hear', meaning: '聞く', category: 'actions', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'dear', meaning: '親愛な', category: 'adjectives', phonicsNote: 'ear = /ɪər/'),
  WordItem(word: 'chin', meaning: '顎', category: 'body', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'lunch', meaning: '昼食', category: 'food', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'much', meaning: 'たくさん', category: 'adjectives', phonicsNote: 'ch = /tʃ/'),
  WordItem(word: 'jug', meaning: 'ジャグ', category: 'daily', phonicsNote: 'j = /dʒ/'),
  WordItem(word: 'jet', meaning: 'ジェット', category: 'daily', phonicsNote: 'j = /dʒ/'),
  WordItem(word: 'ring', meaning: '指輪', category: 'daily', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'king', meaning: '王様', category: 'family', phonicsNote: 'ng = /ŋ/'),
  WordItem(word: 'ship', meaning: '船', category: 'daily', phonicsNote: 'sh = /ʃ/'),
  WordItem(word: 'thin', meaning: '薄い', category: 'adjectives', phonicsNote: 'th = /θ/'),
  WordItem(word: 'bath', meaning: '風呂', category: 'daily', phonicsNote: 'th = /θ/'),
  WordItem(word: 'tooth', meaning: '歯', category: 'body', phonicsNote: 'th = /θ/; oo = /uː/'),
  WordItem(word: 'this', meaning: 'これ', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'that', meaning: 'それ', category: 'sight', phonicsNote: 'th = /ð/'),
  WordItem(word: 'van', meaning: 'バン', category: 'daily', phonicsNote: 'v = /v/'),
  WordItem(word: 'love', meaning: '愛', category: 'adjectives', phonicsNote: 'v = /v/'),
  WordItem(word: 'yes', meaning: 'はい', category: 'sight', phonicsNote: 'y = /j/'),
  WordItem(word: 'yak', meaning: 'ヤク', category: 'animals', phonicsNote: 'y = /j/'),
  WordItem(word: 'zip', meaning: 'ジッパー', category: 'daily', phonicsNote: 'z = /z/'),
  WordItem(word: 'zoo', meaning: '動物園', category: 'daily', phonicsNote: 'z = /z/'),
  WordItem(word: 'buzz', meaning: 'ブーン', category: 'nature', phonicsNote: 'zz = /z/'),
  WordItem(word: 'mix', meaning: '混ぜる', category: 'actions', phonicsNote: 'x = /ks/'),

  // -- スペリング別グルーピング用の追加単語 (94語) --
  // e_short / ea
  WordItem(word: 'bread', meaning: 'パン', category: 'food', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'dead', meaning: '死んだ', category: 'adjectives', phonicsNote: 'ea = /ɛ/'),
  WordItem(word: 'spread', meaning: '広げる', category: 'actions', phonicsNote: 'ea = /ɛ/'),
  // ei / a_e
  WordItem(word: 'make', meaning: '作る', category: 'actions', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'name', meaning: '名前', category: 'daily', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'game', meaning: 'ゲーム', category: 'daily', phonicsNote: 'a_e = /eɪ/'),
  WordItem(word: 'lake', meaning: '湖', category: 'nature', phonicsNote: 'a_e = /eɪ/'),
  // ei / ai
  WordItem(word: 'train', meaning: '電車', category: 'daily', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'tail', meaning: '尻尾', category: 'animals', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'snail', meaning: 'カタツムリ', category: 'animals', phonicsNote: 'ai = /eɪ/'),
  WordItem(word: 'wait', meaning: '待つ', category: 'actions', phonicsNote: 'ai = /eɪ/'),
  // ei / ay
  WordItem(word: 'day', meaning: '日', category: 'daily', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'say', meaning: '言う', category: 'actions', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'way', meaning: '道', category: 'daily', phonicsNote: 'ay = /eɪ/'),
  WordItem(word: 'stay', meaning: '留まる', category: 'actions', phonicsNote: 'ay = /eɪ/'),
  // ii / ea
  WordItem(word: 'tea', meaning: 'お茶', category: 'food', phonicsNote: 'ea = /iː/'),
  WordItem(word: 'sea', meaning: '海', category: 'nature', phonicsNote: 'ea = /iː/'),
  // ii / e
  WordItem(word: 'me', meaning: '私', category: 'sight', phonicsNote: 'e = /iː/'),
  WordItem(word: 'be', meaning: '〜である', category: 'sight', phonicsNote: 'e = /iː/'),
  // ai / i_e
  WordItem(word: 'bike', meaning: '自転車', category: 'daily', phonicsNote: 'i_e = /aɪ/'),
  WordItem(word: 'kite', meaning: '凧', category: 'daily', phonicsNote: 'i_e = /aɪ/'),
  // ai / ie
  WordItem(word: 'tie', meaning: 'ネクタイ', category: 'daily', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'die', meaning: 'サイコロ', category: 'daily', phonicsNote: 'ie = /aɪ/'),
  WordItem(word: 'lie', meaning: '横になる', category: 'actions', phonicsNote: 'ie = /aɪ/'),
  // ai / y
  WordItem(word: 'fly', meaning: '飛ぶ', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'cry', meaning: '泣く', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'try', meaning: '試す', category: 'actions', phonicsNote: 'y = /aɪ/'),
  WordItem(word: 'sky', meaning: '空', category: 'nature', phonicsNote: 'y = /aɪ/'),
  // ai / igh
  WordItem(word: 'high', meaning: '高い', category: 'adjectives', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'night', meaning: '夜', category: 'nature', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'light', meaning: '光', category: 'daily', phonicsNote: 'igh = /aɪ/'),
  WordItem(word: 'right', meaning: '右/正しい', category: 'adjectives', phonicsNote: 'igh = /aɪ/'),
  // ou_long / o_e
  WordItem(word: 'home', meaning: '家', category: 'daily', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'bone', meaning: '骨', category: 'body', phonicsNote: 'o_e = /oʊ/'),
  WordItem(word: 'hope', meaning: '希望', category: 'adjectives', phonicsNote: 'o_e = /oʊ/'),
  // ou_long / oa
  WordItem(word: 'boat', meaning: 'ボート', category: 'daily', phonicsNote: 'oa = /oʊ/'),
  WordItem(word: 'coat', meaning: 'コート', category: 'daily', phonicsNote: 'oa = /oʊ/'),
  WordItem(word: 'goat', meaning: 'ヤギ', category: 'animals', phonicsNote: 'oa = /oʊ/'),
  // ou_long / ow
  WordItem(word: 'blow', meaning: '吹く', category: 'actions', phonicsNote: 'ow = /oʊ/'),
  WordItem(word: 'grow', meaning: '育つ', category: 'actions', phonicsNote: 'ow = /oʊ/'),
  // ou_long / o
  WordItem(word: 'go', meaning: '行く', category: 'actions', phonicsNote: 'o = /oʊ/'),
  WordItem(word: 'no', meaning: 'いいえ', category: 'sight', phonicsNote: 'o = /oʊ/'),
  // uu / oo
  WordItem(word: 'food', meaning: '食べ物', category: 'food', phonicsNote: 'oo = /uː/'),
  WordItem(word: 'cool', meaning: '涼しい', category: 'adjectives', phonicsNote: 'oo = /uː/'),
  // uu / ew
  WordItem(word: 'flew', meaning: '飛んだ', category: 'actions', phonicsNote: 'ew = /uː/'),
  WordItem(word: 'drew', meaning: '描いた', category: 'actions', phonicsNote: 'ew = /uː/'),
  WordItem(word: 'chew', meaning: '噛む', category: 'actions', phonicsNote: 'ew = /uː/'),
  // uu / ue
  WordItem(word: 'clue', meaning: 'ヒント', category: 'daily', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'true', meaning: '本当', category: 'adjectives', phonicsNote: 'ue = /uː/'),
  WordItem(word: 'glue', meaning: '糊', category: 'daily', phonicsNote: 'ue = /uː/'),
  // or_sound / or
  WordItem(word: 'corn', meaning: 'トウモロコシ', category: 'food', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'born', meaning: '生まれた', category: 'adjectives', phonicsNote: 'or = /ɔː/'),
  WordItem(word: 'sort', meaning: '分ける', category: 'actions', phonicsNote: 'or = /ɔː/'),
  // or_sound / all
  WordItem(word: 'fall', meaning: '落ちる', category: 'actions', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'tall', meaning: '高い', category: 'adjectives', phonicsNote: 'all = /ɔːl/'),
  WordItem(word: 'wall', meaning: '壁', category: 'daily', phonicsNote: 'all = /ɔːl/'),
  // er_sound / er
  WordItem(word: 'fern', meaning: 'シダ', category: 'nature', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'herb', meaning: 'ハーブ', category: 'food', phonicsNote: 'er = /ɜː/'),
  WordItem(word: 'herd', meaning: '群れ', category: 'animals', phonicsNote: 'er = /ɜː/'),
  // er_sound / ir
  WordItem(word: 'dirt', meaning: '泥', category: 'nature', phonicsNote: 'ir = /ɜː/'),
  WordItem(word: 'shirt', meaning: 'シャツ', category: 'daily', phonicsNote: 'ir = /ɜː/'),
  // er_sound / ur
  WordItem(word: 'burn', meaning: '燃える', category: 'actions', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'hurt', meaning: '痛い', category: 'adjectives', phonicsNote: 'ur = /ɜː/'),
  WordItem(word: 'fur', meaning: '毛皮', category: 'animals', phonicsNote: 'ur = /ɜː/'),
  // au_sound / ou
  WordItem(word: 'loud', meaning: '大きい(音)', category: 'adjectives', phonicsNote: 'ou = /aʊ/'),
  WordItem(word: 'mouth', meaning: '口', category: 'body', phonicsNote: 'ou = /aʊ/'),
  // au_sound / ow
  WordItem(word: 'down', meaning: '下', category: 'adjectives', phonicsNote: 'ow = /aʊ/'),
  WordItem(word: 'town', meaning: '町', category: 'daily', phonicsNote: 'ow = /aʊ/'),
  // oi_sound / oi
  WordItem(word: 'join', meaning: '加わる', category: 'actions', phonicsNote: 'oi = /ɔɪ/'),
  WordItem(word: 'point', meaning: '指す', category: 'actions', phonicsNote: 'oi = /ɔɪ/'),
  // oi_sound / oy
  WordItem(word: 'joy', meaning: '喜び', category: 'adjectives', phonicsNote: 'oy = /ɔɪ/'),
  WordItem(word: 'enjoy', meaning: '楽しむ', category: 'actions', phonicsNote: 'oy = /ɔɪ/'),
  // ear_sound / eer
  WordItem(word: 'deer', meaning: '鹿', category: 'animals', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'cheer', meaning: '応援', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'steer', meaning: '舵を取る', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  WordItem(word: 'peer', meaning: 'じっと見る', category: 'actions', phonicsNote: 'eer = /ɪər/'),
  // k_sound / k
  WordItem(word: 'keep', meaning: '保つ', category: 'actions', phonicsNote: 'k = /k/'),
  // f_sound / ph
  WordItem(word: 'phone', meaning: '電話', category: 'daily', phonicsNote: 'ph = /f/'),
  WordItem(word: 'photo', meaning: '写真', category: 'daily', phonicsNote: 'ph = /f/'),
  WordItem(word: 'dolphin', meaning: 'イルカ', category: 'animals', phonicsNote: 'ph = /f/'),
  WordItem(word: 'elephant', meaning: 'ゾウ', category: 'animals', phonicsNote: 'ph = /f/'),
  // n_sound / kn
  WordItem(word: 'knee', meaning: '膝', category: 'body', phonicsNote: 'kn = /n/'),
  WordItem(word: 'knife', meaning: 'ナイフ', category: 'daily', phonicsNote: 'kn = /n/'),
  WordItem(word: 'knot', meaning: '結び目', category: 'daily', phonicsNote: 'kn = /n/'),
  WordItem(word: 'know', meaning: '知る', category: 'sight', phonicsNote: 'kn = /n/'),
  // r_sound / wr
  WordItem(word: 'write', meaning: '書く', category: 'actions', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrong', meaning: '間違い', category: 'adjectives', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrap', meaning: '包む', category: 'actions', phonicsNote: 'wr = /r/'),
  WordItem(word: 'wrist', meaning: '手首', category: 'body', phonicsNote: 'wr = /r/'),
  // w_sound / wh
  WordItem(word: 'what', meaning: '何', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'when', meaning: 'いつ', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'where', meaning: 'どこ', category: 'sight', phonicsNote: 'wh = /w/'),
  WordItem(word: 'whale', meaning: 'クジラ', category: 'animals', phonicsNote: 'wh = /w/'),
  // z_sound
  WordItem(word: 'zero', meaning: 'ゼロ', category: 'numbers', phonicsNote: 'z = /z/'),
  WordItem(word: 'song', meaning: '歌', category: 'daily', phonicsNote: 'ng = /ŋ/'),

  // ── MinimalPairs 追加単語 ──
  WordItem(word: 'sheep', meaning: '羊', category: 'animals', phonicsNote: 'ee = /iː/; sh = /ʃ/'),
  WordItem(word: 'full', meaning: '満杯の', category: 'adjectives', phonicsNote: 'u = /ʊ/; ll'),
  WordItem(word: 'fool', meaning: '愚か者', category: 'adjectives', phonicsNote: 'oo = /uː/'),
  WordItem(word: 'cut', meaning: '切る', category: 'cvc_basic', phonicsNote: 'c-u-t / kʌt'),
  WordItem(word: 'bad', meaning: '悪い', category: 'adjectives', phonicsNote: 'b-a-d / bæd'),
  WordItem(word: 'sat', meaning: '座った', category: 'cvc_basic', phonicsNote: 's-a-t / sæt'),
  WordItem(word: 'pin', meaning: 'ピン', category: 'daily', phonicsNote: 'p-i-n / pɪn'),
  WordItem(word: 'cop', meaning: '警官', category: 'cvc_basic', phonicsNote: 'c-o-p / kɒp'),
  WordItem(word: 'hit', meaning: '叩く', category: 'cvc_basic', phonicsNote: 'h-i-t / hɪt'),
  WordItem(word: 'not', meaning: 'ではない', category: 'sight', phonicsNote: 'n-o-t / nɒt'),
  WordItem(word: 'bet', meaning: '賭ける', category: 'cvc_basic', phonicsNote: 'b-e-t / bɛt'),
  WordItem(word: 'bat', meaning: 'バット', category: 'cvc_basic', phonicsNote: 'b-a-t / bæt'),
  WordItem(word: 'fan', meaning: '扇風機', category: 'daily', phonicsNote: 'f-a-n / fæn'),
  WordItem(word: 'then', meaning: 'それから', category: 'sight', phonicsNote: 'th = /ð/; e = /ɛ/'),
  WordItem(word: 'lice', meaning: 'シラミ', category: 'animals', phonicsNote: 'i_e = /aɪ/; c = /s/'),
  WordItem(word: 'sip', meaning: 'すする', category: 'cvc_basic', phonicsNote: 's-i-p / sɪp'),
  WordItem(word: 'ban', meaning: '禁止', category: 'cvc_basic', phonicsNote: 'b-a-n / bæn'),
  WordItem(word: 'yet', meaning: 'まだ', category: 'sight', phonicsNote: 'y = /j/; e = /ɛ/'),
  WordItem(word: 'cap', meaning: '帽子', category: 'daily', phonicsNote: 'c-a-p / kæp'),
  WordItem(word: 'beer', meaning: 'ビール', category: 'food', phonicsNote: 'eer = /ɪər/'),

  // ── cvcWords & PhonicsItem.example 不足分 25語 ──
  WordItem(word: 'tip', meaning: 'チップ/先端', category: 'cvc_basic', phonicsNote: 't-i-p / tɪp'),
  WordItem(word: 'tan', meaning: '日焼け', category: 'cvc_basic', phonicsNote: 't-a-n / tæn'),
  WordItem(word: 'pan', meaning: 'フライパン', category: 'cvc_basic', phonicsNote: 'p-a-n / pæn'),
  WordItem(word: 'nap', meaning: '昼寝', category: 'cvc_basic', phonicsNote: 'n-a-p / næp'),
  WordItem(word: 'tap', meaning: '蛇口', category: 'cvc_basic', phonicsNote: 't-a-p / tæp'),
  WordItem(word: 'tin', meaning: '缶/ブリキ', category: 'cvc_basic', phonicsNote: 't-i-n / tɪn'),
  WordItem(word: 'met', meaning: '会った', category: 'cvc_basic', phonicsNote: 'm-e-t / mɛt'),
  WordItem(word: 'hem', meaning: '裾', category: 'cvc_basic', phonicsNote: 'h-e-m / hɛm'),
  WordItem(word: 'deck', meaning: 'デッキ', category: 'cvc_basic', phonicsNote: 'd-e-ck / dɛk; ck = /k/'),
  WordItem(word: 'mad', meaning: '怒った', category: 'cvc_basic', phonicsNote: 'm-a-d / mæd'),
  WordItem(word: 'ram', meaning: '雄羊', category: 'animals', phonicsNote: 'r-a-m / ræm'),
  WordItem(word: 'dam', meaning: 'ダム', category: 'cvc_basic', phonicsNote: 'd-a-m / dæm'),
  WordItem(word: 'log', meaning: '丸太', category: 'nature', phonicsNote: 'l-o-g / lɒɡ'),
  WordItem(word: 'bug', meaning: '虫', category: 'animals', phonicsNote: 'b-u-g / bʌɡ'),
  WordItem(word: 'fog', meaning: '霧', category: 'nature', phonicsNote: 'f-o-g / fɒɡ'),
  WordItem(word: 'bun', meaning: '丸パン', category: 'food', phonicsNote: 'b-u-n / bʌn'),
  WordItem(word: 'ink', meaning: 'インク', category: 'daily', phonicsNote: 'i-nk / ɪŋk; nk = /ŋk/'),
  WordItem(word: 'net', meaning: 'ネット', category: 'cvc_basic', phonicsNote: 'n-e-t / nɛt'),
  WordItem(word: 'sock', meaning: '靴下', category: 'daily', phonicsNote: 's-o-ck / sɒk; ck = /k/'),
  WordItem(word: 'rat', meaning: 'ネズミ', category: 'animals', phonicsNote: 'r-a-t / ræt'),
  WordItem(word: 'got', meaning: '得た', category: 'cvc_basic', phonicsNote: 'g-o-t / ɡɒt'),
  WordItem(word: 'on', meaning: '〜の上に', category: 'sight', phonicsNote: 'ɒn'),
  WordItem(word: 'up', meaning: '上に', category: 'sight', phonicsNote: 'ʌp'),
  WordItem(word: 'web', meaning: '蜘蛛の巣', category: 'nature', phonicsNote: 'w-e-b / wɛb'),
  WordItem(word: 'queen', meaning: '女王', category: 'daily', phonicsNote: 'qu = /kw/; ee = /iː/'),
];

/// カテゴリごとの単語を取得
List<WordItem> getWordsByCategory(String categoryId) {
  return wordLibrary.where((w) => w.category == categoryId).toList();
}
