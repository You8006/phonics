import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tts_service.dart';

class SettingsService extends ChangeNotifier {
  static const String _prefVoiceType = 'phonics_voice_type';
  static const String _prefAppLanguage = 'phonics_app_language';
  static const String _prefLanguageSelectedOnce = 'phonics_language_selected_once';
  static const String _prefIpaOnlyReading = 'phonics_audio_library_ipa_only';
  static const String _prefAudioLibraryCategory = 'phonics_audio_library_category';

  static const List<Locale> supportedLocales = [
    Locale('ja'),
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('zh'),
    Locale('hi'),
  ];

  VoiceType _voiceType = VoiceType.female;
  Locale _locale = const Locale('ja');
  bool _hasSelectedLanguage = false;
  bool _ipaOnlyReadingMode = true;
  String? _audioLibrarySelectedCategory;
  String _audioLibrarySearchQuery = '';

  VoiceType get voiceType => _voiceType;
  Locale get locale => _locale;
  bool get hasSelectedLanguage => _hasSelectedLanguage;
  bool get ipaOnlyReadingMode => _ipaOnlyReadingMode;
  String? get audioLibrarySelectedCategory => _audioLibrarySelectedCategory;
  String get audioLibrarySearchQuery => _audioLibrarySearchQuery;

  String localeLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return '日本語';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      case 'zh':
        return '中文（简体）';
      case 'hi':
        return 'हिन्दी';
      default:
        return locale.languageCode;
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVoice = prefs.getString(_prefVoiceType);
    if (savedVoice != null) {
      // Find matching enum
      try {
        _voiceType = VoiceType.values.firstWhere((e) => e.name == savedVoice);
      } catch (e) {
        _voiceType = VoiceType.female;
      }
    }

    final savedLanguage = prefs.getString(_prefAppLanguage);
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      _locale = Locale(savedLanguage);
    }
    _hasSelectedLanguage = prefs.getBool(_prefLanguageSelectedOnce) ??
        (savedLanguage != null && savedLanguage.isNotEmpty);

    final savedIpaOnly = prefs.getBool(_prefIpaOnlyReading);
    if (savedIpaOnly != null) {
      _ipaOnlyReadingMode = savedIpaOnly;
    }

    final savedCategory = prefs.getString(_prefAudioLibraryCategory);
    if (savedCategory != null && savedCategory.isNotEmpty) {
      _audioLibrarySelectedCategory = savedCategory;
    }

    // Sync TtsService internal state (prefs already loaded above, no re-save needed)
    TtsService.voiceTypeInternal = _voiceType;
    notifyListeners();
  }

  Future<void> setVoiceType(VoiceType type) async {
    _voiceType = type;
    await TtsService.setVoiceType(type);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale, {bool markSelected = true}) async {
    _locale = locale;
    if (markSelected) {
      _hasSelectedLanguage = true;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefAppLanguage, locale.languageCode);
    await prefs.setBool(_prefLanguageSelectedOnce, _hasSelectedLanguage);
    notifyListeners();
  }

  Future<void> setIpaOnlyReadingMode(bool ipaOnly) async {
    _ipaOnlyReadingMode = ipaOnly;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefIpaOnlyReading, ipaOnly);
    notifyListeners();
  }

  Future<void> setAudioLibrarySelectedCategory(String? categoryId) async {
    _audioLibrarySelectedCategory = categoryId;
    final prefs = await SharedPreferences.getInstance();
    if (categoryId == null || categoryId.isEmpty) {
      await prefs.remove(_prefAudioLibraryCategory);
    } else {
      await prefs.setString(_prefAudioLibraryCategory, categoryId);
    }
    notifyListeners();
  }

  void setAudioLibrarySearchQuery(String query) {
    _audioLibrarySearchQuery = query;
    notifyListeners();
  }
}
