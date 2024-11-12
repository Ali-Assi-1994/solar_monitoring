import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/features/home_screen/presentation/home_screen.dart';
import 'package:solar_monitoring/utils/theme/app_themes.dart';
import 'package:solar_monitoring/utils/theme/theme_notifier.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Enpal Solar Monitoring',
      home: const HomeScreen(),
      darkTheme: AppThemes().darkTheme,
      theme: AppThemes().lightTheme,
      themeMode: ref.watch(themeNotifierProvider),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
