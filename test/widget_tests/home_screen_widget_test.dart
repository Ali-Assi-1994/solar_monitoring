import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:solar_monitoring/features/home_screen/presentation/home_screen.dart';
import 'package:solar_monitoring/features/home_screen/presentation/home_widgets.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';

import '../mocks/monitoring_repository_mock.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('Initial UI renders correctly with all components', (WidgetTester tester) async {
      await tester.runAsync(() async {

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        // Check if AppBar is present with the title
        expect(find.text('Solar Monitoring'), findsOneWidget);

        // Check if TabBar has 3 tabs
        expect(find.byIcon(Icons.sunny), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
        expect(find.byIcon(Icons.battery_charging_full_outlined), findsOneWidget);

        // Check if DatePicker is rendered
        expect(find.byType(DatePicker), findsOneWidget);

        // Check if the theme switch is present
        expect(find.byType(Switch), findsNWidgets(2)); // One for theme, one for watt unit

        // Check if refresh button is present
        expect(find.byType(RefreshButton), findsOneWidget);
      });

    });

    testWidgets('Toggling the theme switch updates the theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
          ],
          child: MaterialApp(
            themeMode: ThemeMode.light,
            darkTheme: ThemeData.dark(),
            theme: ThemeData.light(),
            home: const HomeScreen(),
          ),
        ),
      );

      final themeSwitchFinder = find.byType(Switch).first;

      // Initially, it should be in the true state, which is light theme
      expect(tester.widget<Switch>(themeSwitchFinder).value, true);

      // Toggle the switch
      await tester.tap(themeSwitchFinder);
      await tester.pumpAndSettle();

      // Verify the switch value has changed
      expect(tester.widget<Switch>(themeSwitchFinder).value, false);
    });

    testWidgets('Toggling watt unit switch changes the unit state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Find the Watt Unit Switch (the second switch in the UI)
      final wattSwitchFinder = find.byType(Switch).last;

      // Initially, it should be in the "W" state
      expect(tester.widget<Switch>(wattSwitchFinder).value, true);

      // Toggle the switch
      await tester.tap(wattSwitchFinder);
      await tester.pumpAndSettle();

      // Verify the switch value has changed
      expect(tester.widget<Switch>(wattSwitchFinder).value, false);
    });

    testWidgets('DatePicker changes date on next and previous button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Get the initial displayed date
      final initialDate = DateTime.now();
      final initialDateFormatted = DateFormat('yyyy.MM.dd').format(initialDate);

      // Check initial date display
      expect(find.text(initialDateFormatted), findsOneWidget);

      // Press the "previous day" button three times
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      // Check if the date has decremented by 3 day from the initial
      final previousDateFormatted = DateFormat('yyyy.MM.dd').format(initialDate.subtract(const Duration(days: 3)));
      expect(find.text(previousDateFormatted), findsOneWidget);

      // Press the "next day" button
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      // Check if the date has incremented by 1 day ( decremented by 2 day from the initial )
      final nextDateFormatted = DateFormat('yyyy.MM.dd').format(initialDate.subtract(const Duration(days: 2)));
      expect(find.text(nextDateFormatted), findsOneWidget);
    });

    testWidgets('RefreshButton shows loading indicator when pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Verify initial state with refresh button
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap the refresh button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump(); // Begin the loading state

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Allow the loading state to complete
      await tester.pumpAndSettle();

      // Ensure loading indicator disappears after refresh
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.refresh), findsOneWidget); // Refresh icon should reappear
    });
  });
}
