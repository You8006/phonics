import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Game screens で共通の進捗表示 AppBar を生成する。
///
/// [progressText] は `'3 / 10'` のような文字列（現在の問題番号 / 全問題数）。
AppBar progressAppBar(String progressText) => AppBar(
      leading: const CloseButton(color: AppColors.textSecondary),
      title: Text(
        progressText,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 24,
        ),
      ),
    );
