import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringModel extends Equatable {
  final DateTime timestamp;
  final int value;

  const MonitoringModel({
    required this.timestamp,
    required this.value,
  });

  factory MonitoringModel.fromJson(Map<String, dynamic> json) => MonitoringModel(
        timestamp: DateTime.parse(json["timestamp"]),
        value: json["value"],
      );

  FlSpot toFlSpot() => FlSpot((timestamp.millisecondsSinceEpoch / 1000).toDouble(), value.toDouble());

  @override
  List<Object?> get props => [timestamp, value];
}
