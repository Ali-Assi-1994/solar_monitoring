import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';
import 'package:solar_monitoring/features/monitoring/application/monitoring_provider.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/presentation/widgets/line_chart.dart';
import 'package:solar_monitoring/utils/widgets/retry_widget.dart';

class SolarGenerationMonitoringScreen extends ConsumerWidget {
  const SolarGenerationMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(
          monitoringDataProvider(
            MonitoringFilter(
              filter: MonitoringType.solar,
              timestamp: ref.watch(selectedDateProvider),
            ),
          ),
        )
        .when(
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  RefreshIndicator(
                    onRefresh: () => ref.refresh(monitoringDataProvider(MonitoringFilter(filter: MonitoringType.solar, timestamp: ref.watch(selectedDateProvider))).future),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: LineChartWidget(data: data),
                    ),
                  )
                ],
              ),
            );
          },
          error: (error, __) {
            return RetryWidget(
              retryFunction: () => ref.refresh(
                monitoringDataProvider(
                  MonitoringFilter(
                    filter: MonitoringType.solar,
                    timestamp: ref.watch(selectedDateProvider),
                  ),
                ).future,
              ),
              height: MediaQuery.sizeOf(context).height * .13,
            );
          },
          loading: () => Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 326,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
