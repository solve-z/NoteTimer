import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/remote/auth_data_source.dart';
import '../data_source/remote/social_login/social_login_provider.dart';
import '../data_source/remote/social_login/google_login_provider.dart';
import '../data_source/remote/social_login/kakao_login_provider.dart';
import '../data_source/remote/social_login/naver_login_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final SocialLoginProvider _googleLoginProvider;
  final SocialLoginProvider _kakaoLoginProvider;
  final SocialLoginProvider _naverLoginProvider;

  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    SocialLoginProvider? googleLoginProvider,
    SocialLoginProvider? kakaoLoginProvider,
    SocialLoginProvider? naverLoginProvider,
  }) : _authDataSource = authDataSource,
       _googleLoginProvider = googleLoginProvider ?? GoogleLoginProvider(),
       _kakaoLoginProvider = kakaoLoginProvider ?? KakaoLoginProvider(),
       _naverLoginProvider = naverLoginProvider ?? NaverLoginProvider();

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      // 1. 구글 로그인으로 토큰 획득
      final tokens = await _googleLoginProvider.signIn();
      final idToken = tokens['idToken']!;
      final accessToken = tokens['accessToken']!;

      // 2. Supabase 인증
      final user = await _authDataSource.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return user;
    } catch (e) {
      throw Exception('구글 로그인 실패: $e');
    }
  }

  @override
  Future<UserModel?> signInWithKakao() async {
    try {
      final tokens = await _kakaoLoginProvider.signIn();
      final idToken = tokens['idToken']!;
      final accessToken = tokens['accessToken']!;

      final user = await _authDataSource.signInWithIdToken(
        provider: OAuthProvider.kakao,
        idToken: idToken,
        accessToken: accessToken,
      );

      return user;
    } catch (e) {
      throw Exception('카카오 로그인 실패: $e');
    }
  }

  @override
  Future<UserModel?> signInWithNaver() async {
    throw UnimplementedError('네이버 로그인은 아직 구현되지 않았습니다.');
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _authDataSource.signOut(),
        _googleLoginProvider.signOut(),
        // 카카오, 네이버는 구현 후 추가
      ]);
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await _authDataSource.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _authDataSource.isLoggedIn();
  }

  @override
  Future<bool> checkNicknameDuplicate(String nickname) async {
    return await _authDataSource.checkNicknameDuplicate(nickname);
  }

  @override
  Future<UserModel?> updateNickname(String nickname) async {
    return await _authDataSource.updateNickname(nickname);
  }

  @override
  Future<UserModel?> updateUser(UserModel user) async {
    return await _authDataSource.updateUser(user);
  }
}
