import 'package:google_sign_in/google_sign_in.dart';
import 'social_login_provider.dart';

class GoogleLoginProvider implements SocialLoginProvider {
  final GoogleSignIn _googleSignIn;

  GoogleLoginProvider({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<Map<String, String>> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('사용자가 로그인을 취소했습니다.');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('구글 인증 토큰을 가져올 수 없습니다.');
      }

      return {
        'idToken': idToken,
        'accessToken': accessToken,
      };
    } catch (e) {
      throw Exception('구글 로그인 실패: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}