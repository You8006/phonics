import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:phonics/services/settings_service.dart';
import 'package:phonics/services/progress_service.dart';
import 'package:phonics/l10n/app_localizations.dart';
import 'screens/main_shell.dart';
import 'screens/language_selection_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // グローバルエラーハンドラ
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformError: $error\n$stack');
    return true;
  };

  final settingsService = SettingsService();
  try {
    await settingsService.loadSettings();
  } catch (e) {
    debugPrint('Settings load error (non-fatal): $e');
  }
  try {
    await ProgressService.recordLogin();
  } catch (e) {
    debugPrint('Login record error (non-fatal): $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: SettingsService.supportedLocales,
          locale: settings.locale,
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(context),
          home: settings.hasSelectedLanguage
              ? const MainShell()
              : const LanguageSelectionScreen(),
        );
      },
    );
  }
}
