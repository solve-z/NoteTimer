import 'social_login_provider.dart';

// TODO: kakao_flutter_sdk 패키지 추가 필요
class KakaoLoginProvider implements SocialLoginProvider {
  @override
  Future<Map<String, String>> signIn() async {
    // TODO: 카카오 로그인 구현
    // 1. kakao_flutter_sdk 패키지 추가
    // 2. KakaoSdk.init() 초기화
    // 3. UserApi.instance.loginWithKakaoAccount() 호출
    // 4. 카카오 토큰을 Supabase용 토큰으로 변환
    throw UnimplementedError('카카오 로그인은 아직 구현되지 않았습니다.');
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError('카카오 로그아웃은 아직 구현되지 않았습니다.');
  }
}
