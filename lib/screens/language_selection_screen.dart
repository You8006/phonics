import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phonics/services/settings_service.dart';
import 'package:phonics/theme/app_theme.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selected;

  @override
  void initState() {
    super.initState();
    _selected = const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const Text(
                'Choose your app language',
                style: AppTextStyle.pageHeading,
              ),
              const SizedBox(height: 6),
              const Text(
                'アプリの言語を選択してください',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: ListView.separated(
                  itemCount: SettingsService.supportedLocales.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final locale = SettingsService.supportedLocales[index];
                    final selected = _selected?.languageCode == locale.languageCode;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        onTap: () => setState(() => _selected = locale),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: selected ? AppColors.primary : AppColors.surfaceDim,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  settings.localeLabel(locale),
                                  style: AppTextStyle.cardTitle,
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final locale = _selected ?? const Locale('en');
                    await context.read<SettingsService>().setLocale(locale);
                  },
                  child: const Text('Continue / 続ける'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
