import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';
import 'package:solar_monitoring/features/monitoring/presentation/widgets/line_chart.dart';

void main() {
  testWidgets('LineChartWidget displays correct data and gradient colors', (WidgetTester tester) async {
    // Test data
    final List<FlSpot> testData = [
      const FlSpot(1, 100),
      const FlSpot(2, 200),
      const FlSpot(3, 150),
      const FlSpot(4, 250),
    ];

    // Build the widget tree
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: LineChartWidget(
              data: testData,
              gradientColor1: Colors.blue,
              gradientColor2: Colors.pink,
              gradientColor3: Colors.red,
              indicatorStrokeColor: Colors.black,
            ),
          ),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Check if the LineChart is rendered
    expect(find.byType(LineChart), findsOneWidget);

    // Verify if the line chart shows the provided data points
    final lineChart = tester.widget<LineChart>(find.byType(LineChart));
    expect(lineChart.data.lineBarsData.first.spots, equals(testData));

    // Check if the gradient colors are applied correctly
    final gradient = lineChart.data.lineBarsData.first.gradient;
    expect(gradient, isA<LinearGradient>());
    final linearGradient = gradient as LinearGradient;
    expect(linearGradient.colors, containsAll([Colors.blue, Colors.pink, Colors.red]));
  });

  testWidgets('LineChartWidget changes data unit when wattSwitchProvider is toggled', (WidgetTester tester) async {
    // Test data in watts
    final List<FlSpot> testData = [
      const FlSpot(1, 1000),
      const FlSpot(2, 2000),
      const FlSpot(3, 1500),
      const FlSpot(4, 2500),
    ];

    // Build the widget tree with wattSwitchProvider initially set to watts
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wattSwitchProvider.overrideWith((ref) => WattUnits.w),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LineChartWidget(
              data: testData,
            ),
          ),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Check initial state (should display data in watts)
    var lineChart = tester.widget<LineChart>(find.byType(LineChart));
    expect(lineChart.data.lineBarsData.first.spots, equals(testData));


    // Update the provider using tester's context to ensure UI updates
    await tester.runAsync(() async {
      final context = tester.element(find.byType(LineChartWidget));
      final ref = ProviderScope.containerOf(context, listen: false);

      // Switch from watts to kilowatts
      ref.read(wattSwitchProvider.notifier).state = WattUnits.kW;
    });
    await tester.pumpAndSettle();

    // Verify if the data is now displayed in kilowatts
    lineChart = tester.widget<LineChart>(find.byType(LineChart));
    final expectedDataInKilowatts = [
      const FlSpot(1, 1), // 1000 watts -> 1 kilowatt
      const FlSpot(2, 2), // 2000 watts -> 2 kilowatts
      const FlSpot(3, 1.5), // 1500 watts -> 1.5 kilowatts
      const FlSpot(4, 2.5), // 2500 watts -> 2.5 kilowatts
    ];
    expect(lineChart.data.lineBarsData.first.spots, equals(expectedDataInKilowatts));
  });
}
