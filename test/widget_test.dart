import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:phonics/main.dart';
import 'package:phonics/services/settings_service.dart';

void main() {
  testWidgets('App launches and shows language selection on first run', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SettingsService(),
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // アプリがクラッシュせずに起動する
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.text('Choose your app language'), findsOneWidget);
  });
}
