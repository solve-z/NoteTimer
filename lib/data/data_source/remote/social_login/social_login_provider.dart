/// 소셜 로그인 제공자 인터페이스
abstract class SocialLoginProvider {
  /// 소셜 로그인 수행
  /// Returns: {idToken, accessToken}
  Future<Map<String, String>> signIn();

  /// 로그아웃
  Future<void> signOut();
}
