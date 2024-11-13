import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:solar_monitoring/features/home_screen/application/home_screen_providers.dart';
import 'package:solar_monitoring/features/monitoring/application/monitoring_provider.dart';
import 'package:solar_monitoring/features/monitoring/domain/monitoring_request_filter_model.dart';
import 'package:solar_monitoring/features/monitoring/presentation/battery_consumption_monitoring_screen.dart';
import 'package:solar_monitoring/features/monitoring/presentation/house_consumption_monitoring_screen.dart';
import 'package:solar_monitoring/features/monitoring/presentation/solar_generation_monitoring_screen.dart';
import 'package:solar_monitoring/utils/extensions.dart';
import 'package:solar_monitoring/utils/theme/theme_notifier.dart';
import 'package:solar_monitoring/utils/widgets/date_picker.dart';

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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SwitchWattUnit(),
                  RefreshButton(),
                ]),
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

class SwitchWattUnit extends ConsumerWidget {
  const SwitchWattUnit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Switch(
        value: ref.watch(wattSwitchProvider) == WattUnits.w,
        inactiveTrackColor: Colors.lightGreen,
        activeTrackColor: Colors.lightBlue,
        inactiveThumbImage: const AssetImage('assets/kw.png'),
        activeThumbImage: const AssetImage('assets/w.png'),
        onChanged: (value) => value ? (ref.read(wattSwitchProvider.notifier).state = WattUnits.w) : ref.read(wattSwitchProvider.notifier).state = WattUnits.kW,
      ),
    );
  }
}

class DatePicker extends ConsumerWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime minimumDate = DateTime(2020, 1, 1, 0, 0, 0, 0, 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: !ref.watch(selectedDateProvider).isAfter(minimumDate) ? null : () => ref.read(selectedDateProvider.notifier).previousDay(),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () async {
            DateTime? selectedDateFromPicker = await CustomDatePicker(
              context: context,
              minimumDate: minimumDate,
              maximumDate: DateTime.now(),
              preSelectedDate: ref.watch(selectedDateProvider),
            ).openDatePicker();

            if (selectedDateFromPicker != null) {
              ref.read(selectedDateProvider.notifier).updateDay(selectedDateFromPicker);
            }
          },
          child: Text(
            DateFormat('yyyy.MM.dd').format(ref.watch(selectedDateProvider)),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: ref.watch(selectedDateProvider).canNotGetNextDayData ? null : () => ref.read(selectedDateProvider.notifier).nextDay(),
          disabledColor: Colors.grey,
        ),
      ],
    );
  }
}

class RefreshButton extends ConsumerStatefulWidget {
  const RefreshButton({super.key});

  @override
  RefreshButtonState createState() => RefreshButtonState();
}

class RefreshButtonState extends ConsumerState<RefreshButton> {
  bool _isLoading = false;

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);

    ref.invalidate(monitoringDataProvider);
    await Future.wait([
      ref.refresh(monitoringDataProvider(MonitoringFilter(timestamp: ref.watch(selectedDateProvider), filter: MonitoringType.solar)).future),
      ref.refresh(monitoringDataProvider(MonitoringFilter(timestamp: ref.watch(selectedDateProvider), filter: MonitoringType.house)).future),
      ref.refresh(monitoringDataProvider(MonitoringFilter(timestamp: ref.watch(selectedDateProvider), filter: MonitoringType.battery)).future),
    ]);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: _isLoading
            ? const SizedBox(
                height: 35,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : SizedBox(
                height: 35,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.refresh),
                  iconSize: 35.0,
                  onPressed: _refreshData,
                ),
              ),
      ),
    );
  }
}
