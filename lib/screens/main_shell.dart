import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';
import 'game_select_screen.dart';
import 'settings_screen.dart';
import 'audio_library_screen.dart';

/// メインナビゲーションシェル: BottomNavigationBar で4画面を切り替え
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 1;

  final _pages = const <Widget>[
    HomeScreen(),          // レッスン
    GameSelectScreen(),    // ゲーム
    AudioLibraryScreen(),  // 音声ライブラリー
    _SettingsPage(),       // 設定
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.auto_stories_rounded,
                  label: 'Lessons',
                  isSelected: _currentIndex == 0,
                  color: const Color(0xFFE8604C),
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.sports_esports_rounded,
                  label: 'Games',
                  isSelected: _currentIndex == 1,
                  color: const Color(0xFF4ECDC4),
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.music_note_rounded,
                  label: 'Library',
                  isSelected: _currentIndex == 2,
                  color: const Color(0xFF2ECC71),
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: Icons.tune_rounded,
                  label: 'Settings',
                  isSelected: _currentIndex == 3,
                  color: const Color(0xFF9B59B6),
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── ナビゲーションアイテム ──

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? color : Colors.grey.shade400,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 設定ページ（既存の設定画面からボイス選択等をラップ） ──

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: const Text(
                  '⚙️ Settings',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInDown(
                delay: const Duration(milliseconds: 50),
                child: Text(
                  'アプリの設定を変更できます',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── 音声設定 ──
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: _SettingsTile(
                  icon: Icons.record_voice_over_rounded,
                  title: 'Voice Settings',
                  subtitle: '音声の種類を変更',
                  color: const Color(0xFF3A86FF),
                  onTap: () => _showVoicePicker(context),
                ),
              ),

              const SizedBox(height: 12),

              // ── バージョン情報 ──
              FadeInUp(
                delay: const Duration(milliseconds: 150),
                child: _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'Pop Phonics v1.0.0',
                  color: const Color(0xFF9B59B6),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVoicePicker(BuildContext context) {
    // 既存の HomeScreen のボイスピッカーと同じロジック
    import_showVoicePicker(context, () {
      if (mounted) setState(() {});
    });
  }
}

/// ボイスピッカーを表示するヘルパー
void import_showVoicePicker(BuildContext context, VoidCallback onChanged) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '音声を選択',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              ...VoiceType.values.map((type) {
                final info = _voiceInfo(type);
                return _VoiceOptionTile(
                  icon: info['icon'] as IconData,
                  label: info['label'] as String,
                  subtitle: info['subtitle'] as String,
                  selected: TtsService.voiceType == type,
                  onTap: () async {
                    await TtsService.setVoiceType(type);
                    onChanged();
                    if (ctx.mounted) Navigator.pop(ctx);
                    // プレビュー
                    if (allPhonicsItems.isNotEmpty) {
                      TtsService.speakSound(allPhonicsItems.first);
                    }
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

Map<String, dynamic> _voiceInfo(VoiceType type) {
  switch (type) {
    case VoiceType.female:
      return {
        'icon': Icons.face_3,
        'label': 'Female (女性)',
        'subtitle': 'Jenny — 温かみのある声',
      };
    case VoiceType.male:
      return {
        'icon': Icons.face,
        'label': 'Male (男性)',
        'subtitle': 'Guy — クリアな声',
      };
    case VoiceType.child:
      return {
        'icon': Icons.child_care,
        'label': 'Child (子供)',
        'subtitle': 'Ana — かわいい子供の声',
      };
  }
}

// ── 設定タイル ──

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 音声選択オプション ──

class _VoiceOptionTile extends StatelessWidget {
  const _VoiceOptionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFFF8E3C);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? accentColor.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? accentColor : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: selected ? accentColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected ? accentColor : Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: accentColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
