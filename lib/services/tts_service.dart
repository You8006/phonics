import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phonics_data.dart';

// ═══════════════════════════════════════════
//  TTS Service
// ═══════════════════════════════════════════

/// 音声タイプ: female(Jenny), male2(Andrew), child(Ana)
enum VoiceType { female, male2, child }

class TtsService {
  TtsService._();
  static final AudioPlayer _player = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);   // 短い音声向け低遅延モード
  static final AudioPlayer _sePlayer = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);   // SE も低遅延モード

  /// 現在選択中の声
  static VoiceType _voiceType = VoiceType.female;
  static VoiceType get voiceType => _voiceType;

  /// 内部状態のみ変更（SharedPreferences 保存なし — loadSettings 復元時用）
  static set voiceTypeInternal(VoiceType type) => _voiceType = type;

  /// 声を変更して SharedPreferences に保存
  static Future<void> setVoiceType(VoiceType type) async {
    _voiceType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phonics_voice_type', type.name);
  }

  /// 任意の声タイプに対応するオーディオパスのプレフィックスを返す
  static String _voicePrefixFor(VoiceType type) {
    switch (type) {
      case VoiceType.female:
        return 'audio';
      case VoiceType.male2:
        return 'audio/male2';
      case VoiceType.child:
        return 'audio/child';
    }
  }

  /// 現在選択中の声タイプのプレフィックス
  static String _voicePrefix() => _voicePrefixFor(_voiceType);

  /// ファイル名用キーを生成（phonics_data の letter + sound）
  static String _audioKey(PhonicsItem item) {
    return '${item.letter}_${item.sound}'.replaceAll('-', '_');
  }

  /// プリレコードされたフォニックス音を再生
  static Future<void> speakSound(PhonicsItem item) async {
    final key = _audioKey(item);
    final prefix = _voicePrefix();
    try {
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource('$prefix/sounds/sound_$key.mp3'));
    } catch (e) {
      debugPrint('No audio file for sound $key: $e');
    }
  }

  /// フォニックスパターンの音を再生
  /// phonics_data.dart の PhonicsItem から正確にキーを導出する
  static Future<void> speakPhonicsPattern(String pattern) async {
    // phonics_data の全アイテムから letter が一致するものを探す
    final items = allPhonicsItems.where((i) => i.letter == pattern).toList();
    if (items.isNotEmpty) {
      // 最初にマッチした PhonicsItem の音声を再生
      await speakSound(items.first);
    }
  }

  /// 単語ライブラリーの単語を再生（ゆっくり）
  static Future<void> speakLibraryWordSlow(String word) async {
    final key = word.toLowerCase().replaceAll(' ', '_');
    final prefix = _voicePrefix();
    try {
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource('$prefix/words_library/word_${key}_slow.mp3'));
    } catch (e) {
      debugPrint('No pre-generated audio for library word slow: $key ($e)');
    }
  }

  /// 単語ライブラリーの単語を再生（通常速度）
  static Future<void> speakLibraryWordNormal(String word) async {
    final key = word.toLowerCase().replaceAll(' ', '_');
    final prefix = _voicePrefix();
    try {
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource('$prefix/words_library/word_$key.mp3'));
    } catch (e) {
      debugPrint('No pre-generated audio for library word: $key ($e)');
    }
  }

  /// 効果音の音量（フォニックス音声より控えめ — SE は本質ではないため小さめ）
  static const _seVolume = 0.10;

  /// 正解時の効果音を即時再生
  static Future<void> playCorrect() async {
    try {
      await _sePlayer.stop();
      await _sePlayer.setVolume(_seVolume);
      await _sePlayer.play(AssetSource('audio/effects/成功.mp3'));
    } catch (e) {
      debugPrint('Effect fallback for correct: $e');
    }
  }

  /// 不正解時の効果音を即時再生
  static Future<void> playWrong() async {
    try {
      await _sePlayer.stop();
      await _sePlayer.setVolume(_seVolume);
      await _sePlayer.play(AssetSource('audio/effects/失敗.mp3'));
    } catch (e) {
      debugPrint('Effect fallback for wrong: $e');
    }
  }

  /// 最終スコア効果音を再生（合格/不合格）
  static Future<void> playScoreResult({required bool passed}) async {
    final file = passed ? '最終スコア合格.mp3' : '最終スコア不合格.mp3';
    try {
      await _sePlayer.stop();
      await _sePlayer.setVolume(_seVolume);
      await _sePlayer.play(AssetSource('audio/effects/$file'));
    } catch (e) {
      debugPrint('Effect fallback for score result: $e');
    }
  }

  /// 指定ボイスでサンプルフレーズを再生 (Voice Picker プレビュー用)
  static Future<void> speakSample(VoiceType type) async {
    final prefix = _voicePrefixFor(type);
    try {
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource('$prefix/sample_phrase.mp3'));
    } catch (e) {
      debugPrint('No pre-generated sample phrase for $type: $e');
    }
  }

  /// 音声のみ停止（SE プレイヤーは止めない）
  /// ゲーム画面の dispose で使用。ResultScreen の SE を殺さないため。
  static Future<void> stopSpeech() async {
    await _player.stop();
  }

  /// 音声 + SE 全停止
  static Future<void> stop() async {
    await _player.stop();
    await _sePlayer.stop();
  }
}

