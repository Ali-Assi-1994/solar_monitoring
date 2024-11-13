import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_monitoring/main.dart';
import 'package:solar_monitoring/utils/widgets/app_snackbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to create a test environment with MaterialApp
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      key: UniqueKey(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('AppSnackBar Tests', () {
    testWidgets('displays a SnackBar with text', (WidgetTester tester) async {
      // Create the test environment
      await tester.pumpWidget(createTestWidget(Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              final snackBar = AppSnackBar();
              snackBar.showSnackBar(
                text: 'Test SnackBar',
              );
            },
            child: const Text('Show SnackBar'),
          );
        },
      )));

      // Tap the button to trigger the SnackBar
      await tester.tap(find.text('Show SnackBar'));
      await tester.pump(); // Start showing the SnackBar
      await tester.pump(const Duration(milliseconds: 500)); // Wait a bit

      // Verify if the SnackBar appears with the correct text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Test SnackBar'), findsOneWidget);
    });

    testWidgets('displays a SnackBar with custom child', (WidgetTester tester) async {
      // Create the test environment
      await tester.pumpWidget(createTestWidget(Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              final snackBar = AppSnackBar();
              snackBar.showSnackBar(
                child: const Icon(Icons.check, color: Colors.white),
                color: Colors.blue,
              );
            },
            child: const Text('Show SnackBar with Icon'),
          );
        },
      )));

      // Tap the button to trigger the SnackBar with custom child
      await tester.tap(find.text('Show SnackBar with Icon'));
      await tester.pump(); // Start showing the SnackBar
      await tester.pump(const Duration(milliseconds: 500)); // Wait a bit

      // Verify if the SnackBar appears with the custom child
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays a SnackBar with custom settings', (WidgetTester tester) async {
      // Create the test environment
      await tester.pumpWidget(createTestWidget(Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              final snackBar = AppSnackBar();
              snackBar.showSnackBar(
                text: 'Custom SnackBar',
                color: Colors.red,
                duration: const Duration(seconds: 2),
                elevation: 5,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              );
            },
            child: const Text('Show Custom SnackBar'),
          );
        },
      )));

      // Tap the button to trigger the SnackBar with custom settings
      await tester.tap(find.text('Show Custom SnackBar'));
      await tester.pump(); // Start showing the SnackBar
      await tester.pump(const Duration(milliseconds: 500)); // Wait a bit

      // Verify if the SnackBar appears with custom properties
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Custom SnackBar'), findsOneWidget);
    });
  });
}
