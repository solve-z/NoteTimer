import 'social_login_provider.dart';

// TODO: flutter_naver_login 패키지 추가 필요
class NaverLoginProvider implements SocialLoginProvider {
  @override
  Future<Map<String, String>> signIn() async {
    // TODO: 네이버 로그인 구현
    // 1. flutter_naver_login 패키지 추가
    // 2. FlutterNaverLogin.logIn() 호출
    // 3. 네이버 토큰을 Supabase용 토큰으로 변환
    throw UnimplementedError('네이버 로그인은 아직 구현되지 않았습니다.');
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError('네이버 로그아웃은 아직 구현되지 않았습니다.');
  }
}