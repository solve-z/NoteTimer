import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/model/user_model.dart';

/// Supabase와의 통신만 담당하는 DataSource
class AuthDataSource {
  final SupabaseClient _supabase;

  AuthDataSource({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  /// Supabase에 ID 토큰으로 로그인
  Future<UserModel> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final response = await _supabase.auth.signInWithIdToken(
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Supabase 인증에 실패했습니다.');
      }

      return _convertToUserModel(user);
    } catch (e) {
      throw Exception('Supabase 인증 실패: $e');
    }
  }

  /// Supabase 로그아웃
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// 현재 사용자 가져오기
  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    // users 테이블에서 닉네임 가져오기
    try {
      final response = await _supabase
          .from('users')
          .select('nickname, profile_image_url')
          .eq('id', user.id)
          .maybeSingle();

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        nickname: response?['nickname'],
        profileImageUrl: response?['profile_image_url'],
        createdAt: DateTime.parse(user.createdAt),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      // users 테이블에 데이터 없으면 기본 userMetadata 사용
      return _convertToUserModel(user);
    }
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentUser != null;
  }

  /// 닉네임 중복 체크
  Future<bool> checkNicknameDuplicate(String nickname) async {
    try {
      final response = await _supabase
          .from('users')
          .select('nickname')
          .eq('nickname', nickname)
          .maybeSingle();

      return response != null; // null이면 중복 없음
    } catch (e) {
      throw Exception('닉네임 중복 체크 실패: $e');
    }
  }

  /// 닉네임 업데이트
  Future<UserModel?> updateNickname(String nickname) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      await _supabase.from('users').upsert({
        'id': userId,
        'nickname': nickname,
        'updated_at': DateTime.now().toIso8601String(),
      });

      return await getCurrentUser();
    } catch (e) {
      throw Exception('닉네임 업데이트 실패: $e');
    }
  }

  /// 사용자 정보 업데이트
  Future<UserModel?> updateUser(UserModel user) async {
    try {
      await _supabase.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'nickname': user.nickname,
        'profile_image_url': user.profileImageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      return await getCurrentUser();
    } catch (e) {
      throw Exception('사용자 정보 업데이트 실패: $e');
    }
  }

  /// Supabase User를 UserModel로 변환
  UserModel _convertToUserModel(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      nickname: user.userMetadata?['nickname'],
      profileImageUrl: user.userMetadata?['avatar_url'],
      createdAt: DateTime.parse(user.createdAt),
      lastLoginAt: DateTime.now(),
    );
  }
}