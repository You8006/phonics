import 'package:flutter_test/flutter_test.dart';

import 'package:phonics/main.dart';

void main() {
  testWidgets('Game select screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // ゲーム選択トップが表示される
    expect(find.text('Game Select'), findsOneWidget);
    expect(find.text('Choose a Group to Play'), findsOneWidget);

    // Group 1 は解放済みで表示
    expect(find.textContaining('Group 1'), findsOneWidget);
  });
}
