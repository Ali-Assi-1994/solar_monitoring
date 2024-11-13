import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';

void main() {
  group('Watt Switch Provider Tests', () {
    test('Initial state should be WattUnits.w', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Read the initial state of wattSwitchProvider
      final initialState = container.read(wattSwitchProvider);

      // Assert the initial state is WattUnits.w
      expect(initialState, WattUnits.w);
    });

    test('Changing wattSwitchProvider state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initially the state should be WattUnits.w
      expect(container.read(wattSwitchProvider), WattUnits.w);

      // Change the state to WattUnits.kW
      container.read(wattSwitchProvider.notifier).state = WattUnits.kW;

      // Verify the state change
      expect(container.read(wattSwitchProvider), WattUnits.kW);
    });
  });

  group('Selected Date Notifier Tests', () {
    late ProviderContainer container;
    late SelectedDateNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(selectedDateProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be the current date (same day)', () {
      final now = DateTime.now();
      final initialState = container.read(selectedDateProvider);

      // Assert that the initial date is on the same day as the current date
      expect(
        initialState.year == now.year && initialState.month == now.month && initialState.day == now.day,
        isTrue,
      );
    });

    test('nextDay method should increment the date by 1 day', () {
      final initialDate = container.read(selectedDateProvider);

      // Call the nextDay method
      notifier.nextDay();

      final newDate = container.read(selectedDateProvider);

      // Assert that the date is 1 day later
      expect(newDate, initialDate.add(const Duration(days: 1)));
    });

    test('previousDay method should decrement the date by 1 day', () {
      final initialDate = container.read(selectedDateProvider);

      // Call the previousDay method
      notifier.previousDay();

      final newDate = container.read(selectedDateProvider);

      // Assert that the date is 1 day earlier
      expect(newDate, initialDate.subtract(const Duration(days: 1)));
    });

    test('updateDay method should update the date to a specific day', () {
      final newDate = DateTime(2023, 11, 15);

      // Update the date to the new date
      notifier.updateDay(newDate);

      // Assert that the state is now the new date
      expect(container.read(selectedDateProvider), newDate);
    });
  });
}
