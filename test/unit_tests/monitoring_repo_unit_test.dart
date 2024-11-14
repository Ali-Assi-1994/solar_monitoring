import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:solar_monitoring/ApiClient/api.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  // Initialize the MockApiClient
  late MockApiClient mockApiClient;
  late MonitoringRepository monitoringRepository;

  // Sample data for testing
  const sampleData = [
    {"timestamp": "2024-02-12T01:25:00.000Z", "value": 3601},
    {"timestamp": "2024-02-12T01:45:00.000Z", "value": 512},
  ];

  setUp(() {
    // Create instances of mockApiClient and MonitoringRepository
    mockApiClient = MockApiClient();
    monitoringRepository = MonitoringRepository(apiClient: mockApiClient);

    // Register fallback values if needed
    registerFallbackValue(CancelToken());
    registerFallbackValue(MonitoringFilter(
      timestamp: DateTime.now(),
      filter: MonitoringType.solar,
    ));
  });

  test('fetchData returns list of MonitoringModel on success', () async {
    // Arrange: Mock the ApiClient response
    when(() => mockApiClient.get(
          url: any(named: 'url'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => ApiResult(
          type: ApiResultType.success,
          data: sampleData,
        ));

    // Act: Call fetchData
    final filter = MonitoringFilter(
      timestamp: DateTime(2023, 11, 14),
      filter: MonitoringType.solar,
    );
    final result = await monitoringRepository.fetchData(
      cancelToken: CancelToken(),
      filter: filter,
    );

    // Assert: Verify the result
    expect(result, isA<List<MonitoringModel>>());
    expect(result?.length, 2);

    // Verify that apiClient.get was called with the correct parameters
    verify(() => mockApiClient.get(
          url: URLS.solarMonitoringURL,
          queryParameters: {
            'date': DateFormat('yyyy-MM-dd').format(filter.timestamp),
            'type': filter.filter.name,
          },
        )).called(1);
  });

  test('fetchData throws an error on failure', () async {
    // Arrange: Mock the ApiClient response to fail
    when(() => mockApiClient.get(
          url: any(named: 'url'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => ApiResult(
          type: ApiResultType.failure,
          message: 'Error occurred',
        ));

    // Act & Assert: Verify that an error is thrown
    expect(
      () => monitoringRepository.fetchData(
        cancelToken: CancelToken(),
        filter: MonitoringFilter(
          timestamp: DateTime(2023, 11, 14),
          filter: MonitoringType.solar,
        ),
      ),
      throwsA('Error occurred'),
    );
  });
}
