import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_timer/presentation/pages/home/home_page.dart';
import 'package:note_timer/presentation/pages/onboarding/onboarding_page.dart';

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? '/main' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const OnboardingPage()),
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
}
