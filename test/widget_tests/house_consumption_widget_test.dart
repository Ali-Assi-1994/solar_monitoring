import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_monitoring/features/monitoring/data/monitoring_repository.dart';
import 'package:solar_monitoring/features/monitoring/presentation/house_consumption_monitoring_screen.dart';
import 'package:solar_monitoring/utils/widgets/retry_widget.dart';
import 'package:solar_monitoring/features/monitoring/presentation/widgets/line_chart.dart';

import '../mocks/monitoring_repository_mock.dart';

void main() {
  late MonitoringRepositoryMock monitoringRepositoryMock;

  late MonitoringRepositoryMockWithError monitoringRepositoryMockWithError;

  setUp(() {
    monitoringRepositoryMock = MonitoringRepositoryMock();
    monitoringRepositoryMockWithError = MonitoringRepositoryMockWithError();
  });

  testWidgets('displays loading indicator while data is loading', (WidgetTester tester) async {
    // Arrange - simulate loading state
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monitoringRepositoryProvider.overrideWith((ref) => monitoringRepositoryMock),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HouseConsumptionMonitoringScreen(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('displays RetryWidget when an error occurs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monitoringRepositoryProvider.overrideWith((ref) => monitoringRepositoryMockWithError),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HouseConsumptionMonitoringScreen(),
          ),
        ),
      ),
    );
    // wait till the the api call is completed and an error returned
    await tester.pumpAndSettle();
    // Assert
    expect(find.byType(RetryWidget), findsOneWidget);
  });

  testWidgets('displays LineChartWidget when data is available', (WidgetTester tester) async {
    // Arrange - simulate successful data fetch

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monitoringRepositoryProvider.overrideWith((ref) => monitoringRepositoryMock),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HouseConsumptionMonitoringScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for any animations to settle

    // Assert
    expect(find.byType(LineChartWidget), findsOneWidget);
  });

  testWidgets('RefreshIndicator refreshes data when pulled down', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monitoringRepositoryProvider.overrideWith((ref) => monitoringRepositoryMock),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HouseConsumptionMonitoringScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for any animations to settle

    // Act - perform pull down refresh
    await tester.drag(find.byType(LineChartWidget), const Offset(0, 300));
    await tester.pump(const Duration(seconds: 1));

    // Assert - RefreshIndicator should be triggered
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}
