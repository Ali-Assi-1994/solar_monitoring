import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';
import 'package:solar_monitoring/features/home_screen/presentation/home_widgets.dart';
import 'package:solar_monitoring/features/monitoring/application/monitoring_provider.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/presentation/battery_consumption_monitoring_screen.dart';
import 'package:solar_monitoring/features/monitoring/presentation/house_consumption_monitoring_screen.dart';
import 'package:solar_monitoring/features/monitoring/presentation/solar_generation_monitoring_screen.dart';
import 'package:solar_monitoring/utils/theme/theme_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void preLoadData(WidgetRef ref) {
    ref.read(monitoringDataProvider(MonitoringFilter(
      filter: MonitoringType.solar,
      timestamp: ref.watch(selectedDateProvider),
    )).future);

    ref.read(monitoringDataProvider(MonitoringFilter(
      filter: MonitoringType.battery,
      timestamp: ref.watch(selectedDateProvider),
    )).future);

    ref.read(monitoringDataProvider(MonitoringFilter(
      filter: MonitoringType.house,
      timestamp: ref.watch(selectedDateProvider),
    )).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    preLoadData(ref);
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                const Icon(Icons.dark_mode),
                Switch(
                  value: ref.watch(themeNotifierProvider) == ThemeMode.light,
                  onChanged: (value) => ref.watch(themeNotifierProvider.notifier).toggleTheme(),
                ),
                const Icon(Icons.light_mode),
                const SizedBox(width: 8),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.sunny)),
                  Tab(icon: Icon(Icons.home_outlined)),
                  Tab(icon: Icon(Icons.battery_charging_full_outlined)),
                ],
              ),
              title: const Text('Solar Monitoring'),
            ),
            body: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DatePicker(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SwitchWattUnit(),
                    RefreshButton(),
                  ],
                ),
                Flexible(
                  child: TabBarView(
                    children: [
                      SolarGenerationMonitoringScreen(),
                      HouseConsumptionMonitoringScreen(),
                      BatteryConsumptionMonitoringScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
