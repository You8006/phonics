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

  final settingsService = SettingsService();
  await settingsService.loadSettings();
  await ProgressService.recordLogin();

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
