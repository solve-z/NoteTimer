import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_timer/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _authBoxName = 'auth';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _providerKey = 'provider';

  @override
  Future<bool> isLoggedIn() async {
    final box = await Hive.openBox(_authBoxName);
    return box.get(_isLoggedInKey, defaultValue: false);
  }

  @override
  Future<void> login(String provider) async {
    final box = await Hive.openBox(_authBoxName);
    await box.put(_isLoggedInKey, true);
    await box.put(_providerKey, provider);
  }

  @override
  Future<void> logout() async {
    final box = await Hive.openBox(_authBoxName);
    await box.delete(_isLoggedInKey);
    await box.delete(_providerKey);
  }
}
