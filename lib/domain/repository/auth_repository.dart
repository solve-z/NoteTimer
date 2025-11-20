import '../model/user_model.dart';

abstract class AuthRepository {
  /// 구글 로그인
  Future<UserModel?> signInWithGoogle();

  /// 카카오 로그인
  Future<UserModel?> signInWithKakao();

  /// 네이버 로그인
  Future<UserModel?> signInWithNaver();

  /// 로그아웃
  Future<void> signOut();

  /// 현재 로그인된 사용자 가져오기
  Future<UserModel?> getCurrentUser();

  /// 로그인 상태 확인
  Future<bool> isLoggedIn();

  /// 닉네임 중복 체크
  Future<bool> checkNicknameDuplicate(String nickname);

  /// 닉네임 업데이트
  Future<UserModel?> updateNickname(String nickname);

  /// 사용자 정보 업데이트
  Future<UserModel?> updateUser(UserModel user);
}