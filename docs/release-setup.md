# リリース セットアップガイド

Windows 環境から GitHub Actions でアプリをリリースする手順。

## 前提条件

- [Apple Developer Program](https://developer.apple.com/programs/) 登録済み ($99/年)
- GitHub リポジトリにプッシュ済み

## 1. Bundle ID の変更 ✅

Bundle ID: `com.uedayohei.phonicssense` (設定済み)

## 2. Apple Developer Console 準備

| 作業                         | 場所                                  |
| ---------------------------- | ------------------------------------- |
| App ID 登録                  | Identifiers → + → App IDs             |
| 配布用証明書 (.p12) 作成     | Certificates → + → Apple Distribution |
| プロビジョニングプロファイル | Profiles → + → App Store Connect      |

**Windows で CSR を作成:**

```
openssl req -new -newkey rsa:2048 -nodes -keyout dist.key -out dist.csr -subj "/CN=Your Name/C=JP"
```

**CSR → .cer → .p12:**

```bash
openssl x509 -in distribution.cer -inform DER -out dist.pem -outform PEM
openssl pkcs12 -export -out dist.p12 -inkey dist.key -in dist.pem -password pass:YOUR_PASSWORD
```

## 3. App Store Connect API キー

1. [App Store Connect](https://appstoreconnect.apple.com) → ユーザーとアクセス → 統合 → キー
2. キーの生成 (権限: App Manager)
3. `.p8` ファイル・Key ID・Issuer ID を控える

## 4. GitHub Secrets 登録

Settings → Secrets and variables → Actions:

| Secret                             | 値                         |
| ---------------------------------- | -------------------------- |
| `P12_CERTIFICATE_BASE64`           | .p12 の Base64             |
| `P12_PASSWORD`                     | .p12 のパスワード          |
| `KEYCHAIN_PASSWORD`                | 任意の文字列               |
| `PROVISIONING_PROFILE_BASE64`      | .mobileprovision の Base64 |
| `PROVISIONING_PROFILE_NAME`        | プロファイル名             |
| `APPLE_TEAM_ID`                    | Team ID                    |
| `APP_BUNDLE_ID`                    | Bundle ID                  |
| `APP_STORE_CONNECT_API_KEY_ID`     | Key ID                     |
| `APP_STORE_CONNECT_ISSUER_ID`      | Issuer ID                  |
| `APP_STORE_CONNECT_API_KEY_BASE64` | .p8 の Base64              |

**PowerShell で Base64 変換:**

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("dist.p12")) | Set-Clipboard
```

## 5. リリース実行

```bash
# タグプッシュで自動実行
git tag v1.0.0 && git push origin v1.0.0

# または GitHub Actions → Release → Run workflow で手動実行
```

---

## Android 展開時の追加作業 (予定)

1. `release.yml` の `build-android` ジョブのコメントを解除
2. `platform` の選択肢に `android` を追加
3. 以下の Secrets を追加登録:

| Secret                    | 値                            |
| ------------------------- | ----------------------------- |
| `ANDROID_KEYSTORE_BASE64` | upload-keystore.jks の Base64 |
| `ANDROID_KEY_ALIAS`       | キーエイリアス                |
| `ANDROID_KEY_PASSWORD`    | キーパスワード                |
| `ANDROID_STORE_PASSWORD`  | ストアパスワード              |

**キーストア生成:**

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
