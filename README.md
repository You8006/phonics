# Phonics Starter (Flutter)

英語フォニックス学習アプリの最小土台です。

## 含まれる機能

- Home / Learn / Quiz / Result の4画面
- `flutter_tts` によるフォニックス音声再生
- 3択クイズ
- `shared_preferences` でベストスコア保存

## 前提

- Flutter 3.41.0（`.fvmrc` で固定）
- Windowsでは **Developer Mode を有効化**（プラグイン利用時のsymlink要件）

## ローカル実行

1. 依存取得

   `flutter pub get`

2. 実機またはエミュレータ起動

3. アプリ実行

   `flutter run`

## テストと解析

- `flutter analyze`
- `flutter test`

## CI

GitHub Actions: [.github/workflows/ci.yml](.github/workflows/ci.yml)

- `flutter pub get`
- `flutter analyze`
- `flutter test`

## 次の拡張候補

- 音源ファイル（ネイティブ発音）への切替
- 出題数/レベル（母音・子音・二重母音）
- 学習履歴の可視化
- iOS配布向け署名・ビルドワークフロー
