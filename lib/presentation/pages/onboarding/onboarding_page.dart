import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../main/provider/auth_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _showInfoPopup = false;
  final GlobalKey _infoIconKey = GlobalKey();

  Future<void> _handleGoogleLogin() async {
    try {
      final signIn = ref.read(signInWithGoogleProvider);
      final user = await signIn();

      if (!mounted) return;

      if (user == null) {
        // 로그인 취소
        return;
      }

      // 닉네임이 없으면 닉네임 등록 페이지로, 있으면 메인으로
      if (user.nickname == null || user.nickname!.isEmpty) {
        context.go('/nickname');
      } else {
        context.go('/main');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인에 실패했습니다'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_showInfoPopup) {
          setState(() {
            _showInfoPopup = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 120.h), // 상단 여백
              // Title
              Text(
                'NOTE TIMER',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF212121),
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 47.h), // Title ~ Logo 간격
              // App Logo Illustration (피그마 Y: 254, 200x200 영역)
              SizedBox(
                width: 200.w,
                height: 200.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 노트 (피그마 기준 190x200)
                    SvgPicture.asset(
                      'assets/icons/note.svg',
                      width: 190.w,
                      height: 200.h,
                    ),
                    // 모래시계 (노트 앞에 배치, 피그마 기준 약 100x120)
                    Positioned(
                      left: 20.w,
                      bottom: 20.h,
                      child: SvgPicture.asset(
                        'assets/icons/hourglass.svg',
                        width: 100.w,
                        height: 120.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 47.h), // Logo ~ Guide text 간격
              // Guide text
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.6),
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: Colors.black.withValues(alpha: 0.6),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(
                  '로그인하고 오늘의 집중을 노트에 담아보세요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF212121).withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.h), // Guide text ~ Social buttons 간격
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
                  SizedBox(width: 26.w),
                  _SocialLoginButton(
                    iconPath: 'assets/icons/naver_icon.svg',
                    backgroundColor: const Color(0xFF03C75A),
                    onTap: () {
                      // TODO: Naver login
                    },
                  ),
                  SizedBox(width: 26.w),
                  _SocialLoginButton(
                    iconPath: 'assets/icons/google_icon.svg',
                    backgroundColor: Colors.white,
                    onTap: _handleGoogleLogin,
                  ),
                ],
              ),
              SizedBox(height: 36.h), // Social buttons ~ Skip login 간격
              // Skip login with info icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        key: _infoIconKey,
                        onTap: () {
                          setState(() {
                            _showInfoPopup = !_showInfoPopup;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/icons/info.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          context.go('/main');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFF525252),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            '로그인 없이 사용하기',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF525252),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Info popup
                  if (_showInfoPopup)
                    Positioned(
                      bottom: 16.h + 7.h, // 아이콘 높이 + 간격
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 260.w,
                          padding: EdgeInsets.fromLTRB(17.w, 12.h, 17.w, 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.93),
                            borderRadius: BorderRadius.circular(9.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '로그인하면 이런 기능들을 이용할 수 있어요 😊',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF222222),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                '• 데이터 백업 및 동기화가 가능해요',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF222222),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '• 나의 집중 현황을 확인할 수 있어요',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF222222),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(), // 하단 여백은 유연하게
            ],
          ),
        ),
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
      child: SvgPicture.asset(iconPath, width: 52.w, height: 52.h),
    );
  }
}
