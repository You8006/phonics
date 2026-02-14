import 'package:flutter_test/flutter_test.dart';

import 'package:phonics/main.dart';

void main() {
  testWidgets('App launches and shows game select screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // アプリがクラッシュせずに起動する
    expect(find.byType(MyApp), findsOneWidget);
  });
}
