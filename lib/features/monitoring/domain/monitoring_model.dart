class MonitoringModel {
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
}
