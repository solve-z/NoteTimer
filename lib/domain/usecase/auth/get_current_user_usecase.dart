import '../../model/user_model.dart';
import '../../repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<UserModel?> call() async {
    return await _repository.getCurrentUser();
  }
}