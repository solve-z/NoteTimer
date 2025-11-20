import '../../model/user_model.dart';
import '../../repository/auth_repository.dart';

class UpdateNicknameUseCase {
  final AuthRepository _repository;

  UpdateNicknameUseCase(this._repository);

  Future<UserModel?> call(String nickname) async {
    return await _repository.updateNickname(nickname);
  }
}
