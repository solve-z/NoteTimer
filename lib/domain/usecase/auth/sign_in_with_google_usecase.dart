import '../../model/user_model.dart';
import '../../repository/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<UserModel?> call() async {
    return await _repository.signInWithGoogle();
  }
}
