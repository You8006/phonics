import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Game screens で共通のスコア表示 AppBar を生成する。
///
/// [scoreText] は `'3 / 10'` のような文字列。
AppBar scoreAppBar(String scoreText) => AppBar(
      leading: const CloseButton(color: AppColors.textSecondary),
      title: Text(
        scoreText,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
