import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// 音声選択ボトムシート — アプリ全体で共通利用
void showVoicePicker(BuildContext context, [VoidCallback? onChanged]) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── ハンドル ──
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Voice',
                style: AppTextStyle.sectionHeading,
              ),
              const SizedBox(height: 16),
              ...VoiceType.values.map((type) {
                final info = _voiceInfo(type);
                return _VoiceOptionTile(
                  icon: info.icon,
                  label: info.label,
                  subtitle: info.subtitle,
                  selected: TtsService.voiceType == type,
                  onTap: () async {
                    await TtsService.setVoiceType(type);
                    onChanged?.call();
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  onPlaySample: () => TtsService.speakSample(type),
                );
              }),
              const SizedBox(height: 4),
            ],
          ),
        ),
      );
    },
  );
}

/// 音声アイコン取得
IconData voiceIcon(VoiceType type) {
  switch (type) {
    case VoiceType.female:
      return Icons.face_3;
    case VoiceType.male2:
      return Icons.face;
    case VoiceType.child:
      return Icons.child_care;
  }
}

// ── 内部データ ──

class _VoiceInfo {
  const _VoiceInfo(this.icon, this.label, this.subtitle);
  final IconData icon;
  final String label;
  final String subtitle;
}

_VoiceInfo _voiceInfo(VoiceType type) {
  switch (type) {
    case VoiceType.female:
      return const _VoiceInfo(Icons.face_3, 'Female', 'Jenny — Warm and clear');
    case VoiceType.male2:
      return const _VoiceInfo(Icons.face, 'Male', 'Andrew — Deep and natural');
    case VoiceType.child:
      return const _VoiceInfo(Icons.child_care, 'Child', 'Ana — Cute child voice');
  }
}

// ── タイル ──

class _VoiceOptionTile extends StatelessWidget {
  const _VoiceOptionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.onPlaySample,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onPlaySample;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.surfaceDim,
                width: selected ? AppBorder.selected : AppBorder.thin,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: selected ? AppColors.primary : AppColors.textTertiary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 22),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  iconSize: 28,
                  color: AppColors.primary,
                  tooltip: 'Play sample',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: onPlaySample,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
