import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_tracking_flutter/src/screens/home_screen.dart';
import 'package:moto_tracking_flutter/src/screens/login_screen.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';
import 'package:moto_tracking_flutter/src/theme/app_theme.dart';

class MotoTrackingApp extends StatefulWidget {
  const MotoTrackingApp({super.key});

  @override
  State<MotoTrackingApp> createState() => _MotoTrackingAppState();
}

class _MotoTrackingAppState extends State<MotoTrackingApp> {
  late final StorageService _storage;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _storage = StorageService();
    _router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _storage,
      redirect: (context, state) {
        final loggedIn = _storage.isLoggedIn;
        final goingToLogin = state.matchedLocation == '/login';
        if (!loggedIn && !goingToLogin) return '/login';
        if (loggedIn && goingToLogin) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );
    _storage.bootstrap(); // async, will notify
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Moto Tracking',
      theme: AppTheme.light(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
