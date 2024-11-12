import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WattUnits { w, kW }

final wattSwitchProvider = StateProvider<WattUnits>((ref) => WattUnits.w);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void nextDay() {
    state = state.add(const Duration(days: 1));
  }

  void previousDay() {
    state = state.subtract(const Duration(days: 1));
  }

  void updateDay(DateTime day) {
    state = day;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(() {
  return SelectedDateNotifier();
});
