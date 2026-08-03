import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/filter_provider.dart';
import 'providers/item_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await NotificationService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: MaterialApp(
        title: 'ExpiryVault',
        theme: AppTheme.light(),
        home: const SplashScreen(),
      ),
    );
  }
}
