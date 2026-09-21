import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/router/auth_status_mapper.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'app_config.dart';
import 'core/router/app_router.dart';
import 'core/router/route_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.instance = const AppConfig(
    environment: AppEnvironment.dev,
    apiBaseUrl: 'http://10.0.2.2:3000',
  );

  await configureDependencies();
  runApp(const DineFlowApp());
}

class DineFlowApp extends StatefulWidget {
  const DineFlowApp({super.key});

  @override
  State<DineFlowApp> createState() => _DineFlowAppState();
}

class _DineFlowAppState extends State<DineFlowApp> {
  late final RouterNotifier _routerNotifier;
  late final GoRouter _router;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _routerNotifier = sl<RouterNotifier>();
    _router = createRouter(notifier: _routerNotifier);
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _routerNotifier.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: _onAuthStateChanged,
        child: MaterialApp.router(
          title: 'DineFlow',
          debugShowCheckedModeBanner: true,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFFE85D04),
            useMaterial3: true,
          ),
          routerConfig: _router,
        ),
      ),
    );
  }

  /// ── The single bridge: AuthCubit → RouterNotifier ──────────────────────
  ///
  /// This is the **only** place in the app that maps [AuthState] to
  /// [AuthStatus] and pushes it into the router. Every screen that calls
  /// `context.read<AuthCubit>().login()` / `.logout()` / etc. will trigger
  /// this listener automatically because they share the same cubit instance.
  void _onAuthStateChanged(BuildContext context, AuthState state) {
    state.whenOrNull(
      authenticated: (user) {
        _routerNotifier.updateStatus(authStatusFromRole(user.role));
      },
      unauthenticated: () {
        _routerNotifier.updateStatus(AuthStatus.unauthenticated);
      },
      error: (_) {
        // Treat errors as unauthenticated so the user isn't stuck on a
        // protected screen. The individual screen can still show a SnackBar
        // via its own local BlocListener for UX feedback.
        _routerNotifier.updateStatus(AuthStatus.unauthenticated);
      },
    );
    // `initial` and `loading` are intentionally ignored — the router stays
    // on the current page while a request is in flight.
  }
}
