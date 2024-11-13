import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';
import 'package:solar_monitoring/utils/app_colors.dart';
import 'package:solar_monitoring/utils/extensions.dart';

class LineChartWidget extends ConsumerWidget {
  final List<FlSpot>? data;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color indicatorStrokeColor;

  const LineChartWidget({
    super.key,
    required this.data,
    Color? gradientColor1,
    Color? gradientColor2,
    Color? gradientColor3,
    Color? indicatorStrokeColor,
  })  : gradientColor1 = gradientColor1 ?? AppColors.contentColorBlue,
        gradientColor2 = gradientColor2 ?? AppColors.contentColorPink,
        gradientColor3 = gradientColor3 ?? AppColors.contentColorRed,
        indicatorStrokeColor = indicatorStrokeColor ?? AppColors.mainTextColor1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineBarsData = [
      LineChartBarData(
        spots: ref.watch(wattSwitchProvider) == WattUnits.kW ? data!.convertWattsToKilowatts : data!,
        isCurved: true,
        barWidth: 1,
        shadow: const Shadow(blurRadius: 8),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              gradientColor1.withOpacity(0.4),
              gradientColor2.withOpacity(0.4),
              gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: [
            gradientColor1,
            gradientColor2,
            gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    return Column(
      children: [
        AspectRatio(
          aspectRatio: (MediaQuery.sizeOf(context).width * 2.5) / MediaQuery.sizeOf(context).height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: LayoutBuilder(builder: (context, constraints) {
              return LineChart(
                LineChartData(
                  lineBarsData: lineBarsData,
                  minY: ref.watch(wattSwitchProvider) == WattUnits.kW ? (data!.minValue / 1000 - .5) : data!.minValue - 500,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        maxIncluded: false,
                        minIncluded: false,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${value.formatDoubleValue} ${ref.watch(wattSwitchProvider).name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.contentColorPink,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 6,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.formatDoubleValueToHHMM(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.contentColorPink,
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                        color: AppColors.borderColor,
                      ),
                      left: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                        color: AppColors.borderColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
