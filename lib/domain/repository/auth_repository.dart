abstract class AuthRepository {
  /// 현재 로그인 상태 확인
  Future<bool> isLoggedIn();

  /// 로그인 처리
  Future<void> login(String provider);

  /// 로그아웃 처리
  Future<void> logout();
}