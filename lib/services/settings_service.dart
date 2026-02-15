import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tts_service.dart';

class SettingsService extends ChangeNotifier {
  VoiceType _voiceType = VoiceType.female;

  VoiceType get voiceType => _voiceType;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVoice = prefs.getString('phonics_voice_type');
    if (savedVoice != null) {
      // Find matching enum
      try {
        _voiceType = VoiceType.values.firstWhere((e) => e.name == savedVoice);
      } catch (e) {
        _voiceType = VoiceType.female;
      }
    }
    // Sync with TtsService
    TtsService.setVoiceType(_voiceType); // This also saves to prefs, redundant but safe
    notifyListeners();
  }

  Future<void> setVoiceType(VoiceType type) async {
    _voiceType = type;
    await TtsService.setVoiceType(type);
    notifyListeners();
  }
}
