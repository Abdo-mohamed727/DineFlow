import 'package:dineflow/core/di/servise_locator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_config.dart';
import 'core/router/app_router.dart';
import 'core/router/route_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qttjpubolafxbtbhztbl.supabase.co',
    anonKey: 'sb_publishable_88Qio_5ZPS9KIONVqUjKxg_RUBbWvZJ',
  );

  AppConfig.instance = const AppConfig(
    environment: AppEnvironment.production,
    apiBaseUrl: 'https://api.dineflow.example.com',
  );
  configureDependencies();
  runApp(const DineFlowApp());
}

class DineFlowApp extends StatefulWidget {
  const DineFlowApp({super.key});

  @override
  State<DineFlowApp> createState() => _DineFlowAppState();
}

class _DineFlowAppState extends State<DineFlowApp> {
  late final RouterNotifier _routerNotifier;
  late final router = createRouter(notifier: _routerNotifier);

  @override
  void initState() {
    super.initState();
    _routerNotifier = sl<RouterNotifier>();
  }

  @override
  void dispose() {
    _routerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DineFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE85D04),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
