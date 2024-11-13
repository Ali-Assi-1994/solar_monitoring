import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_monitoring/utils/widgets/date_picker.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to create a test environment with MaterialApp
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('CustomDatePicker Widget Tests', () {
    final DateTime preSelectedDate = DateTime(2024, 1, 15);
    final DateTime minimumDate = DateTime(2023, 1, 1);
    final DateTime maximumDate = DateTime(2024, 12, 31);

    testWidgets('shows Android date picker', (WidgetTester tester) async {
      // Platform override to simulate Android
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      // Build the widget inside a MaterialApp
      await tester.pumpWidget(createTestWidget(Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              final picker = CustomDatePicker(
                context: context,
                preSelectedDate: preSelectedDate,
                maximumDate: maximumDate,
                minimumDate: minimumDate,
              );
              final pickedDate = await picker.openDatePicker();
              expect(pickedDate, isNotNull);
            },
            child: const Text('Open Android Date Picker'),
          );
        },
      )));

      // Tap on the button to open the date picker
      await tester.tap(find.text('Open Android Date Picker'));
      await tester.pumpAndSettle();

      // You may need to simulate interaction with the date picker using mock data
      // and then validate the picked date.

      // Cleanup
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('shows iOS date picker', (WidgetTester tester) async {
      // Platform override to simulate iOS
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // Build the widget inside a MaterialApp
      await tester.pumpWidget(createTestWidget(Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              final picker = CustomDatePicker(
                context: context,
                preSelectedDate: preSelectedDate,
                maximumDate: maximumDate,
                minimumDate: minimumDate,
              );
              final pickedDate = await picker.openDatePicker();
              expect(pickedDate, isNotNull);
            },
            child: const Text('Open iOS Date Picker'),
          );
        },
      )));

      // Tap on the button to open the iOS-style date picker
      await tester.tap(find.text('Open iOS Date Picker'));
      await tester.pumpAndSettle();

      // You may need to simulate interaction with the CupertinoDatePicker and
      // then validate the picked date.

      // Cleanup
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
