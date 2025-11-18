import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Title
            const Text(
              'NOTE TIMER',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 80),
            // App Logo Illustration
            Stack(
              alignment: Alignment.center,
              children: [
                // 노트
                SvgPicture.asset(
                  'assets/icons/note.svg',
                  width: 180,
                  height: 200,
                ),
                // 모래시계 (노트 앞에 배치)
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: SvgPicture.asset(
                    'assets/icons/hourglass.svg',
                    width: 80,
                    height: 100,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Guide text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: const Text(
                '로그인하고 오늘의 집중을 노트에 담아보세요',
                style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialLoginButton(
                  iconPath: 'assets/icons/kakao_icon.svg',
                  backgroundColor: const Color(0xFFFEE500),
                  onTap: () {
                    // TODO: Kakao login
                  },
                ),
                const SizedBox(width: 16),
                _SocialLoginButton(
                  iconPath: 'assets/icons/naver_icon.svg',
                  backgroundColor: const Color(0xFF03C75A),
                  onTap: () {
                    // TODO: Naver login
                  },
                ),
                const SizedBox(width: 16),
                _SocialLoginButton(
                  iconPath: 'assets/icons/google_icon.svg',
                  backgroundColor: Colors.white,
                  onTap: () {
                    // TODO: Google login
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Skip login with info icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 18, color: Color(0xFF999999)),
                  onPressed: () {
                    _showLoginBenefitsDialog(context);
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.go('/main');
                  },
                  child: const Text(
                    '로그인 없이 사용하기',
                    style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLoginBenefitsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '로그인 시 사용 가능한 기능',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BenefitItem(text: '여러 기기에서 데이터 동기화'),
            _BenefitItem(text: '클라우드 백업 및 복원'),
            _BenefitItem(text: '집중 기록 통계 및 분석'),
            _BenefitItem(text: '프리미엄 테마 및 기능'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인', style: TextStyle(color: Color(0xFF333333))),
          ),
        ],
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.iconPath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 28,
            height: 28,
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;

  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}
