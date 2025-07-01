// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:countdown_app/main.dart';
import 'package:countdown_app/providers/countdown_provider.dart';
import 'package:countdown_app/providers/theme_provider.dart';

void main() {
  testWidgets('Countdown app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CountdownProvider()),
        ],
        child: const CountdownApp(),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that our app shows the home screen
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('添加'), findsOneWidget);
    expect(find.text('发现'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });
}
