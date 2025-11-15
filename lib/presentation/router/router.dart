import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_timer/presentation/pages/auth/login_page.dart';
import 'package:note_timer/presentation/pages/home/home_page.dart';
import 'package:note_timer/presentation/pages/splash/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder:
          (context, state) =>
              MaterialPage(key: state.pageKey, child: const SplashPage()),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder:
          (context, state) =>
              MaterialPage(key: state.pageKey, child: const LoginPage()),
    ),
    GoRoute(
      path: '/main',
      name: 'main',
      pageBuilder:
          (context, state) =>
              MaterialPage(key: state.pageKey, child: const HomePage()),
    ),
  ],
);
