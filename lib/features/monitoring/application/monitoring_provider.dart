import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';

final monitoringDataProvider = FutureProvider.family<List<FlSpot>?, MonitoringFilter>((ref, filter) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  List<MonitoringModel>? models = await ref.read(monitoringRepositoryProvider).fetchData(cancelToken: cancelToken, filter: filter);

  // Group data by the hour
  Map<DateTime, List<MonitoringModel>> hourlyData = {};
  for (var model in models!) {
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

  /// data polling
  final timer = Timer(const Duration(seconds: 60), () => ref.invalidateSelf());
  ref.onDispose(timer.cancel);

  return hourlyAverages;
});
