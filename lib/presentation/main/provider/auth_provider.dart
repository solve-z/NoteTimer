import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/model/user_model.dart';
import '../../../domain/usecase/auth/sign_in_with_google_usecase.dart';
import '../../../domain/usecase/auth/sign_out_usecase.dart';
import '../../../domain/usecase/auth/update_nickname_usecase.dart';
import '../../../domain/usecase/auth/check_nickname_duplicate_usecase.dart';

/// 현재 사용자 상태
final currentUserProvider = StateProvider<UserModel?>((ref) => null);

/// 로그인 로딩 상태
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// 구글 로그인
final signInWithGoogleProvider = Provider((ref) {
  return () async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      final useCase = getIt<SignInWithGoogleUseCase>();
      final user = await useCase();
      ref.read(currentUserProvider.notifier).state = user;
      return user;
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  };
});

/// 로그아웃
final signOutProvider = Provider((ref) {
  return () async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      final useCase = getIt<SignOutUseCase>();
      await useCase();
      ref.read(currentUserProvider.notifier).state = null;
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  };
});

/// 닉네임 업데이트
final updateNicknameProvider = Provider((ref) {
  return (String nickname) async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      final useCase = getIt<UpdateNicknameUseCase>();
      final user = await useCase(nickname);
      ref.read(currentUserProvider.notifier).state = user;
      return user;
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  };
});

/// 닉네임 중복 체크
final checkNicknameDuplicateProvider = Provider((ref) {
  return (String nickname) async {
    final useCase = getIt<CheckNicknameDuplicateUseCase>();
    return await useCase(nickname);
  };
});
