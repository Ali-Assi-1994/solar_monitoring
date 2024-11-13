import 'package:fl_chart/fl_chart.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';

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

extension ConvertMonitoringModelToFlSpot on List<MonitoringModel> {
  List<FlSpot> convertToFlSpotHourlyAverage() {
    // Group data by the hour
    Map<DateTime, List<MonitoringModel>> hourlyData = {};
    for (var model in this) {
      // Round down to the hour
      DateTime hourKey = DateTime(
        model.timestamp.year,
        model.timestamp.month,
        model.timestamp.day,
        model.timestamp.hour,
      );

      if (!hourlyData.containsKey(hourKey)) {
        hourlyData[hourKey] = [];
      }
      hourlyData[hourKey]!.add(model);
    }

    // Calculate the average for each hour
    List<FlSpot> hourlyAverages = [];
    for (var entry in hourlyData.entries) {
      DateTime hourKey = entry.key;
      List<MonitoringModel> hourModels = entry.value;

      double averageValue = hourModels.map((model) => model.value).reduce((a, b) => a + b) / hourModels.length;
      hourlyAverages.add(FlSpot(hourKey.hour.toDouble(), averageValue.ceilToDouble()));
    }

    return hourlyAverages;
  }
}
