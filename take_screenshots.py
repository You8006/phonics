"""
Phonics Sense — App Store スクリーンショット自動撮影
iPhone 14 Pro Max: 430x932 viewport × 3 DPR = 1290x2796 pixels

Flutter Web は Canvas 描画のため、座標ベースでクリックする。
"""

import http.server
import threading
import time
import os
from pathlib import Path
from playwright.sync_api import sync_playwright

# ── 設定 ──
PORT = 8765
BUILD_DIR = Path(__file__).parent / "build" / "web"
OUTPUT_DIR = Path(__file__).parent / "artifacts" / "screenshots"
VIEWPORT = {"width": 430, "height": 932}
DPR = 3  # → 1290 × 2796

# ── ボトムナビバーのタブ座標 ──
# Container margin: LTRB(40,0,40,8) → 内幅350px (x: 40〜390)
# _NavItem: SizedBox(width:48) × 4 in Row(spaceEvenly)
# gap = (350 - 4*48) / 5 = 31.6 → 中心 x = 40 + gap*(i) + 48*(i-1) + 24
# Container padding vertical:12, _NavItem height:36 → center y ≈ 894
NAV_Y = 894
TAB_HOME = (96, NAV_Y)
TAB_GAMES = (175, NAV_Y)
TAB_LIBRARY = (255, NAV_Y)
TAB_SETTINGS = (334, NAV_Y)

# ── 言語選択画面 ──
# 日本語は ListView の1番目のアイテム (y ≈ 154)
# Continue ボタンは画面下部 (y ≈ 888)
LANG_JP = (215, 154)
CONTINUE_BTN = (215, 888)


def serve_web():
    """build/web をローカルサーバーで配信"""
    os.chdir(BUILD_DIR)
    handler = http.server.SimpleHTTPRequestHandler
    server = http.server.HTTPServer(("127.0.0.1", PORT), handler)
    server.serve_forever()


def init_app(page):
    """アプリを開いて言語選択を済ませる"""
    page.goto(f"http://127.0.0.1:{PORT}/", wait_until="networkidle")
    page.wait_for_timeout(5000)  # Flutter 初期化待ち

    # 言語選択画面: 1) 日本語を選択  2) Continue をクリック
    page.mouse.click(*LANG_JP)
    page.wait_for_timeout(1000)
    page.mouse.click(*CONTINUE_BTN)
    page.wait_for_timeout(3000)


def take_screenshots():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport=VIEWPORT,
            device_scale_factor=DPR,
        )
        page = context.new_page()

        # アプリ起動
        print("🔄 アプリを起動中...")
        page.goto(f"http://127.0.0.1:{PORT}/", wait_until="networkidle")
        page.wait_for_timeout(5000)  # Flutter 初期化待ち

        # ── 1. 言語選択画面 (多言語対応のアピール) ──
        print("📸 01 言語選択画面...")
        page.screenshot(path=str(OUTPUT_DIR / "01_language.png"), full_page=False)
        print("  ✅ 01_language.png")

        # 言語選択: 日本語 → Continue
        page.mouse.click(*LANG_JP)
        page.wait_for_timeout(800)
        page.mouse.click(*CONTINUE_BTN)
        page.wait_for_timeout(3000)

        # ── 2. ホーム画面 ──
        print("📸 02 ホーム画面...")
        page.mouse.click(*TAB_HOME)
        page.wait_for_timeout(2000)
        page.screenshot(path=str(OUTPUT_DIR / "02_home.png"), full_page=False)
        print("  ✅ 02_home.png")

        # ── 3. ゲーム選択画面 ──
        print("📸 03 ゲーム選択画面...")
        page.mouse.click(*TAB_GAMES)
        page.wait_for_timeout(2000)
        page.screenshot(path=str(OUTPUT_DIR / "03_games.png"), full_page=False)
        print("  ✅ 03_games.png")

        # ── 4. ワードライブラリ ──
        print("📸 04 ワードライブラリ...")
        page.mouse.click(*TAB_LIBRARY)
        page.wait_for_timeout(2000)
        page.screenshot(path=str(OUTPUT_DIR / "04_library.png"), full_page=False)
        print("  ✅ 04_library.png")

        # ── 5. 設定画面 ──
        print("📸 05 設定画面...")
        page.mouse.click(*TAB_SETTINGS)
        page.wait_for_timeout(2000)
        page.screenshot(path=str(OUTPUT_DIR / "05_settings.png"), full_page=False)
        print("  ✅ 05_settings.png")

        context.close()
        browser.close()


def main():
    print("🚀 ローカルサーバーを起動中...")
    server_thread = threading.Thread(target=serve_web, daemon=True)
    server_thread.start()
    time.sleep(1)

    print(f"📷 スクリーンショット撮影開始 (viewport: {VIEWPORT['width']}x{VIEWPORT['height']} @ {DPR}x DPR)")
    print(f"   → 出力サイズ: {VIEWPORT['width'] * DPR}x{VIEWPORT['height'] * DPR} px\n")

    take_screenshots()

    print(f"\n🎉 完了！ {OUTPUT_DIR} にスクリーンショットを保存しました。")


if __name__ == "__main__":
    main()
