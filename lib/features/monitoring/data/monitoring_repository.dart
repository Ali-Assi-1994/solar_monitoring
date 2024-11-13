import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:solar_monitoring/ApiClient/api.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';

class MonitoringRepository {
  final ApiClient apiClient;

  MonitoringRepository({required this.apiClient});

  Future<List<MonitoringModel>?> fetchData({
    required CancelToken cancelToken,
    required MonitoringFilter filter,
  }) async {
    ApiResult result = await apiClient.get(url: URLS.solarMonitoringURL, queryParameters: {
      'date': DateFormat('yyyy-MM-dd').format(filter.timestamp),
      'type': filter.filter.name,
    });
    if (result.type == ApiResultType.success) {
      await Future.delayed(const Duration(seconds: 1));
      return List<MonitoringModel>.from(result.data.map((x) => MonitoringModel.fromJson(x)));
    } else {
      throw result.errorMessage;
    }
  }
}

final monitoringRepositoryProvider = Provider<MonitoringRepository>((ref) {
  return MonitoringRepository(apiClient: ref.read(dioProvider));
});
