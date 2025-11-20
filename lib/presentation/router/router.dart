import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_timer/presentation/pages/home/home_page.dart';
import 'package:note_timer/presentation/pages/onboarding/onboarding_page.dart';
import 'package:note_timer/presentation/pages/nickname/nickname_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecase/auth/get_current_user_usecase.dart';
import '../../domain/usecase/auth/sign_out_usecase.dart';

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? '/main' : '/onboarding',
    redirect: (context, state) async {
      final currentUser = Supabase.instance.client.auth.currentUser;
      final path = state.matchedLocation;

      // 미로그인 상태
      if (currentUser == null) {
        if (path == '/onboarding') return null;
        return '/onboarding';
      }

      // 로그인 상태 → 닉네임 체크
      try {
        final getUserUseCase = getIt<GetCurrentUserUseCase>();
        final user = await getUserUseCase();

        // 닉네임 없음 → 닉네임 입력 페이지로
        if (user == null || user.nickname == null || user.nickname!.isEmpty) {
          if (path == '/nickname') return null;
          return '/nickname';
        }

        // 닉네임 있음 (정상 로그인) → 메인으로
        if (path == '/onboarding' || path == '/nickname') {
          return '/main';
        }
      } catch (e) {
        // 에러 시 온보딩으로
        if (path == '/onboarding') return null;
        return '/onboarding';
      }

      return null; // 현재 경로 유지
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const OnboardingPage()),
      ),
      GoRoute(
        path: '/nickname',
        name: 'nickname',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const NicknamePage()),
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
