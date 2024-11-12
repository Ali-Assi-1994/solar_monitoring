import 'package:fl_chart/fl_chart.dart';

extension DoubleToHourFormat on double {
  String formatDoubleValueToHHMM() {
    // Separate the integer part (hours) and decimal part (minutes)
    int hours = floor();
    int minutes = ((this - hours) * 60).round();

    // Format as HH:MM
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get formatDoubleValue => this % 1 == 0 ? toStringAsFixed(0) : toString();
}

extension WattConversion on List<FlSpot> {
  List<FlSpot> get convertWattsToKilowatts => map((spot) => FlSpot(spot.x, spot.y / 1000)).toList();

  double get minValue => map((point) => point.y).reduce((a, b) => a < b ? a : b);
}

extension DateRestrictionOnSolarDataFilter on DateTime {
  bool get canNotGetTomorrowData => year == DateTime.now().year && month == DateTime.now().month && day == DateTime.now().day;
}
