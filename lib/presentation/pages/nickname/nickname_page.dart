import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      });
      return;
    }

    // 1. 길이 체크 (2~10자)
    final isLengthValid = nickname.length >= 2 && nickname.length <= 10;

    // 2. 한글·영문·숫자만 체크
    final regex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    final isCharacterValid = regex.hasMatch(nickname);

    // 3. 중복 체크
    bool isNotDuplicate = false;
    if (isLengthValid && isCharacterValid) {
      try {
        final checkDuplicate = ref.read(checkNicknameDuplicateProvider);
        final isDuplicate = await checkDuplicate(nickname);
        isNotDuplicate = !isDuplicate;
        print('✅ 중복 체크 성공: $nickname, 중복=$isDuplicate');
      } catch (e) {
        print('❌ 중복 체크 실패: $e');
        isNotDuplicate = false;
      }
    }

    // 모든 검증 완료 후 한 번에 상태 업데이트
    setState(() {
      _isLengthValid = isLengthValid;
      _isCharacterValid = isCharacterValid;
      _isNotDuplicate = isNotDuplicate;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.h),
              // 제목
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: '사용할 '),
                    TextSpan(
                      text: '닉네임',
                      style: TextStyle(
                        backgroundColor: const Color(0xFFFFEB3B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' 을 입력해주세요'),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // 닉네임 입력 필드 + 글자수 + 시작하기 버튼
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nicknameController,
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: '이름동리먼',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: Color(0xFF212121),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            counterText: '',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // 글자수 표시
                        Text(
                          '(${nickname.length}/10)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 시작하기 버튼
                  ElevatedButton(
                    onPressed: _isValid ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isValid ? Colors.black : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // 유효성 검사 체크리스트
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
              SizedBox(height: 12.h),
              _ValidationCheckItem(
                text: '사용 가능한 닉네임이에요',
                isValid: _isNotDuplicate,
                isChecking: _isChecking && nickname.isNotEmpty,
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
      children: [
        Icon(
          Icons.check,
          size: 20.w,
          color: isValid ? const Color(0xFF4CAF50) : Colors.grey.shade300,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isValid ? const Color(0xFF4CAF50) : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
