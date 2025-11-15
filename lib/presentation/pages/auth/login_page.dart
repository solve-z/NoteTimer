import 'package:flutter/material.dart';
import 'package:note_timer/presentation/pages/auth/widgets/login_illustration.dart';
import 'package:note_timer/presentation/pages/auth/widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 120),
            // Title
            const Text(
              'NOTE TIMER',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color(0xFF927007),
                letterSpacing: 2,
              ),
            ),
            const Spacer(flex: 2),
            // Illustration
            const LoginIllustration(),
            const Spacer(flex: 1),
            // Guide text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD147).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '로그인 후 오늘의 집중을 노트에 담아보세요',
                style: TextStyle(fontSize: 14, color: Color(0xFFAB8100)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialLoginButton(
                  svgPath: 'assets/icons/kakao_icon.svg',
                  onTap: () {
                    // Kakao login
                  },
                ),
                const SizedBox(width: 16),
                SocialLoginButton(
                  svgPath: 'assets/icons/naver_icon.svg',
                  onTap: () {
                    // Naver login
                  },
                ),
                const SizedBox(width: 16),
                SocialLoginButton(
                  svgPath: 'assets/icons/google_icon.svg',
                  onTap: () {
                    // Google login
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Skip login
            TextButton(
              onPressed: () {
                // Skip login
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Color(0xFFAB8100)),
                  SizedBox(width: 4),
                  Text(
                    '로그인 없이 사용하기',
                    style: TextStyle(fontSize: 14, color: Color(0xFF525252)),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
