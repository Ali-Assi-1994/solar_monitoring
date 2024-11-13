import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solar_monitoring/features/monitoring/application/monitoring_provider.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_model.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/utils/extensions.dart';

import '../listener.dart';
import '../mocks/monitoring_repository_mock.dart';

void main() {
  test('test convert MonitoringModel data to FlSpot Hourly Average data, so it could be used in the line chart', () async {
    final monitoringModels = [
      /// 10:00 -> 10:59
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 10, 0), value: 10),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 10, 30), value: 20),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 10, 42), value: 50),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 10, 59), value: 30),

      ///  ==> hour = 10
      ///  ==> average = (10+20+50+30)/4  = 27.5  , ceilToDouble --> 28.0

      /// 11:00 -> 11:59
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 11, 0), value: 14),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 11, 12), value: 51),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 11, 13), value: 54),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 11, 26), value: 62),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 11, 58), value: 72),

      ///  ==> hour = 11
      ///  ==> average = (14+51+54+62+72)/5  = 50.6, ceilToDouble --> 51.0

      /// 17:00 -> 17:59
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 17, 25), value: 512),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 17, 42), value: 56),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 17, 55), value: 12),
      MonitoringModel(timestamp: DateTime(2023, 11, 12, 17, 59), value: 52),

      ///  ==> hour = 17
      ///  ==> average = (512+56+12+52)/4  = 158 , ceilToDouble --> 158
    ];
    final computedFlSpotHourlyAverage = monitoringModels.convertToFlSpotHourlyAverage();

    const expectedFlSpotHourlyAverage = [
      FlSpot(10, 28),
      FlSpot(11, 51),
      FlSpot(17, 158),
    ];

    expect(computedFlSpotHourlyAverage, expectedFlSpotHourlyAverage);
  });


  test('test monitoring provider', () async {
    final listener = Listener();
    final container = ProviderContainer(
      overrides: [
        monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
      ],
    );
    addTearDown(container.dispose);

    final monitoringModels = List<MonitoringModel>.from(mockedData.map((x) => MonitoringModel.fromJson(x)));
    final expectedFetchedResults = monitoringModels.convertToFlSpotHourlyAverage();

    final filter = MonitoringFilter(timestamp: DateTime(2023, 11, 12), filter: MonitoringType.house);

    /// initial state
    container.listen(
      monitoringDataProvider(filter),
      listener.call,
      fireImmediately: true,
    );
    verify(() => listener(null, const AsyncLoading<List<FlSpot>?>()));
    verifyNoMoreInteractions(listener);

    container.read(monitoringDataProvider(filter));
    await Future.delayed(const Duration(seconds: 1));
    verify(() => listener(const AsyncLoading<List<FlSpot>?>(), any(that: isA<AsyncData<List<FlSpot>?>>())));
    expect(container.read(monitoringDataProvider(filter)).value, expectedFetchedResults);
  });

  // test('monitoringDataProvider invalidates itself after 60 seconds', () async {
  //   final listener = Listener();
  //   final container = ProviderContainer(
  //     overrides: [
  //       monitoringRepositoryProvider.overrideWithValue(MonitoringRepositoryMock()),
  //     ],
  //   );
  //   addTearDown(container.dispose);
  //
  //   final filter = MonitoringFilter(timestamp: DateTime(2023, 11, 12), filter: MonitoringType.house);
  //
  //   container.listen(
  //     monitoringDataProvider(filter),
  //     listener.call,
  //     fireImmediately: true,
  //   );
  //   verify(() => listener(null, const AsyncLoading<List<FlSpot>?>()));
  //
  //   // Wait for 60 seconds (simulate timer)
  //   await Future.delayed(const Duration(seconds: 10));
  //
  //   // Verify the provider was invalidated and reloaded
  //   verify(() => listener(const AsyncLoading<List<FlSpot>?>(), any(that: isA<AsyncData<List<FlSpot>?>>())));
  //   // expect(container.read(monitoringDataProvider(filter)).value, expectedFetchedResults);
  //   // verify(() => listener(null, isNot(const AsyncLoading<List<FlSpot>?>())));
  // });


}
