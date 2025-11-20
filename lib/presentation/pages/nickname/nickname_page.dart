import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../main/provider/auth_provider.dart';

class NicknamePage extends ConsumerStatefulWidget {
  const NicknamePage({super.key});

  @override
  ConsumerState<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends ConsumerState<NicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  Timer? _debounceTimer;

  String? _validationMessage;
  bool _isValid = false;
  bool _isChecking = false;

  // 유효성 검사 상태
  bool _isLengthValid = false;
  bool _isCharacterValid = false;
  bool _isNotDuplicate = false;
  bool _isDuplicateChecked = false; // 중복 체크 완료 여부

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onNicknameChanged);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onNicknameChanged() {
    final nickname = _nicknameController.text;

    // 디바운스: 입력을 멈춘 후 0.3초 후에 검증
    _debounceTimer?.cancel();

    // 체크 중 상태만 표시 (기존 유효성은 유지)
    setState(() {
      _isChecking = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _validateNickname(nickname);
    });
  }

  Future<void> _validateNickname(String nickname) async {
    // 빈 값일 때만 모든 상태 초기화
    if (nickname.isEmpty) {
      setState(() {
        _isChecking = false;
        _isValid = false;
        _isLengthValid = false;
        _isCharacterValid = false;
        _isNotDuplicate = false;
        _isDuplicateChecked = false;
      });
      return;
    }

    // 1. 길이 체크 (2~10자)
    final isLengthValid = nickname.length >= 2 && nickname.length <= 10;

    // 2. 한글·영문·숫자만 체크
    final regex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    final isCharacterValid = regex.hasMatch(nickname);

    // 길이/문자 유효성 먼저 업데이트 (중복 체크 전)
    setState(() {
      _isLengthValid = isLengthValid;
      _isCharacterValid = isCharacterValid;
      _isDuplicateChecked = false; // 중복 체크 초기화
    });

    // 3. 중복 체크 (길이와 문자 유효성 통과 시에만)
    bool isNotDuplicate = false;
    bool isDuplicateChecked = false;
    if (isLengthValid && isCharacterValid) {
      try {
        final checkDuplicate = ref.read(checkNicknameDuplicateProvider);
        final isDuplicate = await checkDuplicate(nickname);
        isNotDuplicate = !isDuplicate;
        isDuplicateChecked = true;
      } catch (e) {
        print('❌ 닉네임 중복 체크 실패: $e');
        isNotDuplicate = false;
        isDuplicateChecked = false;
      }
    }

    // 모든 검증 완료 후 최종 상태 업데이트
    setState(() {
      _isNotDuplicate = isNotDuplicate;
      _isDuplicateChecked = isDuplicateChecked;
      _isValid = isLengthValid && isCharacterValid && isNotDuplicate;
      _isChecking = false;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_isValid) return;

    try {
      final updateNickname = ref.read(updateNicknameProvider);
      await updateNickname(_nicknameController.text);

      if (!mounted) return;
      context.go('/main');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('닉네임 등록에 실패했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _nicknameController.text;

    // 뒤로가기 방지
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('닉네임 설정은 필수입니다'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/back_arrow.svg',
              width: 12.w,
              height: 20.h,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('닉네임 설정은 필수입니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          title: Text(
            '닉네임 만들기',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.5.h),
            child: Container(height: 0.5.h, color: const Color(0xFFC4C4C4)),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 72.h),
              // 제목
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: '사용할 '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFF600,
                            ).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Text(
                            '닉네임',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' 을 입력해주세요'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              // 닉네임 입력 필드 + 시작하기 버튼
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 35.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: TextField(
                        controller: _nicknameController,
                        maxLength: 10,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF000000),
                        ),
                        decoration: InputDecoration(
                          hintText: '이름동리먼',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13.sp,
                          ),
                          suffixText: '(${nickname.length}/10)',
                          suffixStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                          counterText: '',
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 시작하기 버튼
                  SizedBox(
                    width: 56.w,
                    height: 31.h,
                    child: ElevatedButton(
                      onPressed: _isValid ? _handleSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isValid
                                ? const Color(0xFF323232)
                                : const Color(0xFFE6E6E6),
                        foregroundColor: const Color(0xFFFFFFFF),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // 유효성 검사 체크리스트
              Center(
                child: Column(
                  children: [
                    _ValidationCheckItem(
                      text: '2-10자 이내로 입력해주세요',
                      isValid: _isLengthValid,
                      isChecking: _isChecking && nickname.isNotEmpty,
                    ),
                    SizedBox(height: 12.h),
                    _ValidationCheckItem(
                      text: '한글, 영문, 숫자만 가능해요',
                      isValid: _isCharacterValid,
                      isChecking: _isChecking && nickname.isNotEmpty,
                    ),
                    if (_isDuplicateChecked) ...[
                      SizedBox(height: 12.h),
                      _ValidationCheckItem(
                        text: _isNotDuplicate
                            ? '사용 가능한 닉네임이에요'
                            : '이미 사용 중인 닉네임이에요',
                        isValid: _isNotDuplicate,
                        isChecking: _isChecking && nickname.isNotEmpty,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValidationCheckItem extends StatelessWidget {
  final String text;
  final bool isValid;
  final bool isChecking;

  const _ValidationCheckItem({
    required this.text,
    required this.isValid,
    required this.isChecking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 17.w,
          height: 17.h,
          child: SvgPicture.asset(
            isValid ? 'assets/icons/v.svg' : 'assets/icons/x.svg',
            width: 17.w,
            height: 17.h,
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 180.w,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF212121).withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
