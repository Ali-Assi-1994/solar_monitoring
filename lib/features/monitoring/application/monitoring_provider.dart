import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';
import 'package:solar_monitoring/utils/extensions.dart';

final monitoringDataProvider = FutureProvider.family<List<FlSpot>?, MonitoringFilter>((ref, filter) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  List<MonitoringModel>? models = await ref.read(monitoringRepositoryProvider).fetchData(cancelToken: cancelToken, filter: filter);

  final List<FlSpot> hourlyAverages = models!.convertToFlSpotHourlyAverage();

  /// data polling
  final timer = Timer(const Duration(seconds: 10), () => ref.invalidateSelf());
  ref.onDispose(timer.cancel);

  return hourlyAverages;
});
